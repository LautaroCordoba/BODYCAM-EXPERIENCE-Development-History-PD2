if not FPCameraPlayerBase then
    return
end

-- Author: Brouken

_G.BODYCAM =
    _G.BODYCAM or {}

local BC =
    _G.BODYCAM

BC.mode =
    BC.mode or 1

BC.base_path =
    ModPath or "mods/BODYCAM/"

BC.runtime =
    BC.runtime or {}

local RT =
    BC.runtime

RT.last_yaw =
    RT.last_yaw or 0

RT.last_pitch =
    RT.last_pitch or 0

RT.last_center_x =
    RT.last_center_x or 0

RT.last_center_y =
    RT.last_center_y or 0

RT.last_center_z =
    RT.last_center_z or 0

RT.shoulder_applied =
    false

RT.vanilla_overshot =
    RT.vanilla_overshot or nil

RT.bodycam_overshot_applied =
    false

local function clamp(
    value,
    minimum,
    maximum
)

    if value < minimum then
        return minimum
    end

    if value > maximum then
        return maximum
    end

    return value

end

local function safe_number(
    value,
    fallback
)

    if type(value) == "number"
    and value == value
    and value ~= math.huge
    and value ~= -math.huge then

        return value

    end

    return fallback or 0

end

-- PAYDAY Vector3 exposes numeric x/y/z properties here.
-- vector:x()
-- vector:y()
-- vector:z()

local function copy_vector(vector)

    if not vector then
        return nil
    end

    return Vector3(
        safe_number(
            vector.x,
            0
        ),

        safe_number(
            vector.y,
            0
        ),

        safe_number(
            vector.z,
            0
        )
    )

end

function BC:notify(text)

    log(
        "[BODYCAM] "
        .. tostring(text)
    )

    if managers
    and managers.hud
    and managers.hud.show_hint then

        managers.hud:show_hint({
            text =
                "BODYCAM | "
                .. tostring(text)
        })

    end

end

function BC:load_tuning()

    local path =
        self.base_path
        .. "tuning.lua"

    local file =
        io.open(
            path,
            "r"
        )

    if not file then

        self:notify(
            "ERROR: tuning.lua no encontrado"
        )

        return false

    end

    file:close()

    _G.BODYCAM_TUNING =
        nil

    local ok, err =
        pcall(
            dofile,
            path
        )

    if not ok then

        log(
            "[BODYCAM] TUNING ERROR: "
            .. tostring(err)
        )

        self:notify(
            "ERROR EN TUNING"
        )

        return false

    end

    if type(
        _G.BODYCAM_TUNING
    ) ~= "table" then

        self:notify(
            "BODYCAM_TUNING INVALIDO"
        )

        return false

    end

    self.modes =
        _G.BODYCAM_TUNING

    if self.mode > #self.modes then

        self.mode =
            1

    end

    return true

end

function BC:show_mode()

    if not self.modes then
        return
    end

    local profile =
        self.modes[
            self.mode
        ]

    if not profile then
        return
    end

    self:notify(
        tostring(self.mode)
        .. "/"
        .. tostring(#self.modes)
        .. " | "
        .. tostring(profile.name)
    )

end

function BC:remove_shoulder_offset(
    shoulder
)

    if not RT.shoulder_applied then
        return
    end

    if shoulder
    and shoulder.rotation then

        local previous_rotation =
            Rotation(
                RT.last_yaw,
                RT.last_pitch,
                0
            )

        shoulder.rotation =
            shoulder.rotation
            * previous_rotation:inverse()

    end

    if shoulder
    and shoulder.translation then

        shoulder.translation =
            shoulder.translation
            -
            Vector3(
                RT.last_center_x,
                RT.last_center_y,
                RT.last_center_z
            )

    end

    RT.last_yaw =
        0

    RT.last_pitch =
        0

    RT.last_center_x =
        0

    RT.last_center_y =
        0

    RT.last_center_z =
        0

    RT.shoulder_applied =
        false

end

function BC:capture_vanilla_overshot(
    overshot
)

    if not overshot then
        return
    end

    if RT.vanilla_overshot then
        return
    end

    RT.vanilla_overshot = {

        yaw_neg =
            overshot.yaw_neg,

        yaw_pos =
            overshot.yaw_pos,

        pitch_neg =
            overshot.pitch_neg,

        pitch_pos =
            overshot.pitch_pos,

        pivot =
            copy_vector(
                overshot.pivot
            )

    }

    log(
        "[BODYCAM] Vanilla overshot captured."
    )

end

function BC:restore_vanilla_overshot(
    overshot
)

    if not overshot then
        return
    end

    local vanilla =
        RT.vanilla_overshot

    if not vanilla then
        return
    end

    overshot.yaw_neg =
        vanilla.yaw_neg

    overshot.yaw_pos =
        vanilla.yaw_pos

    overshot.pitch_neg =
        vanilla.pitch_neg

    overshot.pitch_pos =
        vanilla.pitch_pos

    if overshot.pivot
    and vanilla.pivot then

        mvector3.set(
            overshot.pivot,
            vanilla.pivot
        )

    end

    RT.bodycam_overshot_applied =
        false

end

function BC:next_mode()

    if not self.modes
    or #self.modes == 0 then
        return
    end

    self.mode =
        self.mode + 1

    if self.mode > #self.modes then

        self.mode =
            1

    end

    if _G.BODYCAM_FREEAIM
    and BODYCAM_FREEAIM.full_reset then

        BODYCAM_FREEAIM:full_reset()

    end

    self:show_mode()

end

BC:load_tuning()

log("========================================")
log("[BODYCAM] V0.12.2 STABLE CAMERA")
log("[BODYCAM] SHOULDER FREE AIM")
log("[BODYCAM] Author: Brouken")
log("========================================")

local initialized =
    false

Hooks:PostHook(
    FPCameraPlayerBase,
    "update",
    "BODYCAM_V0122_StableCamera",

    function(self, unit, t, dt)

        if not BC.modes then
            return
        end

        local profile =
            BC.modes[
                BC.mode
            ]

        if not profile then
            return
        end

        local shoulder =
            self._shoulder_stance

        BC:remove_shoulder_offset(
            shoulder
        )

        local cfg =
            _G.BODYCAM_FREEAIM_TUNING

        if not cfg
        or not cfg.enabled then

            -- Restore PAYDAY movement.

            if RT.bodycam_overshot_applied
            and self._vel_overshot then

                BC:restore_vanilla_overshot(
                    self._vel_overshot
                )

            end

            return

        end

        if self._vel_overshot then

            -- Capture vanilla BEFORE BODYCAM writes.

            if not RT.bodycam_overshot_applied then

                BC:capture_vanilla_overshot(
                    self._vel_overshot
                )

            end

            local inertia_yaw =
                tonumber(
                    profile.inertia_yaw
                )
                or 0

            local inertia_pitch =
                tonumber(
                    profile.inertia_pitch
                )
                or 0

            self._vel_overshot.yaw_neg =
                inertia_yaw

            self._vel_overshot.yaw_pos =
                -inertia_yaw

            self._vel_overshot.pitch_neg =
                -inertia_pitch

            self._vel_overshot.pitch_pos =
                inertia_pitch

            if self._vel_overshot.pivot then

                mvector3.set(
                    self._vel_overshot.pivot,

                    Vector3(
                        tonumber(
                            profile.pivot_x
                        )
                        or 0,

                        tonumber(
                            profile.pivot_y
                        )
                        or 0,

                        tonumber(
                            profile.pivot_z
                        )
                        or 0
                    )
                )

            end

            RT.bodycam_overshot_applied =
                true

        end

        if not shoulder
        or not shoulder.rotation then
            return
        end

        local FA =
            _G.BODYCAM_FREEAIM

        if not FA then
            return
        end

        local shoulder_yaw =
            tonumber(
                profile.shoulder_yaw
            )
            or 1

        local shoulder_pitch =
            tonumber(
                profile.shoulder_pitch
            )
            or 1

        local free_yaw =
            safe_number(
                FA.yaw,
                0
            )
            *
            shoulder_yaw

        local free_pitch =
            safe_number(
                FA.pitch,
                0
            )
            *
            shoulder_pitch

        local visual_max_yaw =
            (
                tonumber(
                    profile.max_yaw
                )
                or 15
            )
            *
            shoulder_yaw

        local visual_max_pitch =
            (
                tonumber(
                    profile.max_pitch
                )
                or 9
            )
            *
            shoulder_pitch

        free_yaw =
            clamp(
                free_yaw,
                -visual_max_yaw,
                visual_max_yaw
            )

        free_pitch =
            clamp(
                free_pitch,
                -visual_max_pitch,
                visual_max_pitch
            )

        local center_x =
            tonumber(
                profile.center_x
            )
            or 0

        local center_y =
            tonumber(
                profile.center_y
            )
            or 0

        local center_z =
            tonumber(
                profile.center_z
            )
            or 0

        if free_yaw ~= 0
        or free_pitch ~= 0 then

            shoulder.rotation =
                shoulder.rotation
                *
                Rotation(
                    free_yaw,
                    free_pitch,
                    0
                )

        end

        if shoulder.translation
        and (
            center_x ~= 0
            or center_y ~= 0
            or center_z ~= 0
        ) then

            shoulder.translation =
                shoulder.translation
                +
                Vector3(
                    center_x,
                    center_y,
                    center_z
                )

        end

        RT.last_yaw =
            free_yaw

        RT.last_pitch =
            free_pitch

        RT.last_center_x =
            center_x

        RT.last_center_y =
            center_y

        RT.last_center_z =
            center_z

        RT.shoulder_applied =
            true

        if not initialized then

            initialized =
                true

            log(
                "[BODYCAM] Stable camera ACTIVE."
            )

            BC:show_mode()

        end

    end
)

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
    ModPath or
    "mods/BODYCAM/"

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

        log(
            "[BODYCAM] Ruta: "
            .. tostring(path)
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

        self:notify(
            "ERROR AL RECARGAR TUNING"
        )

        log(
            "[BODYCAM] LUA ERROR: "
            .. tostring(err)
        )

        return false
    end

    if type(
        _G.BODYCAM_TUNING
    ) ~= "table" then

        self:notify(
            "ERROR: BODYCAM_TUNING no existe"
        )

        return false
    end

    if #_G.BODYCAM_TUNING == 0 then

        self:notify(
            "ERROR: tuning sin perfiles"
        )

        return false
    end

    self.modes =
        _G.BODYCAM_TUNING

    if self.mode > #self.modes then

        self.mode = 1

    end

    log("----------------------------------------")
    log("[BODYCAM] TUNING RECARGADO")

    log(
        "[BODYCAM] Perfiles: "
        .. tostring(#self.modes)
    )

    log("----------------------------------------")

    return true
end

function BC:show_mode()

    if not self.modes then
        return
    end

    local mode =
        self.modes[self.mode]

    if not mode then
        return
    end

    local text =
        tostring(self.mode)
        .. "/"
        .. tostring(#self.modes)
        .. " | "
        .. tostring(mode.name)

    if managers
    and managers.hud
    and managers.hud.show_hint then

        managers.hud:show_hint({
            text =
                "BODYCAM | "
                .. text
        })

    end

    log("----------------------------------------")

    log(
        "[BODYCAM] PERFIL "
        .. text
    )

    log(
        "[BODYCAM] YAW="
        .. tostring(mode.yaw)
        .. " | PITCH="
        .. tostring(mode.pitch)
    )

    log(
        "[BODYCAM] PIVOT=("
        .. tostring(mode.pivot_x)
        .. ", "
        .. tostring(mode.pivot_y)
        .. ", "
        .. tostring(mode.pivot_z)
        .. ")"
    )

    log("----------------------------------------")
end

function BC:next_mode()

    if not self.modes
    or #self.modes == 0 then

        return

    end

    self.mode =
        self.mode + 1

    if self.mode > #self.modes then

        self.mode = 1

    end

    self:show_mode()
end

log("========================================")
log("[BODYCAM] V0.7.3")
log("[BODYCAM] Weapon Inertia Engine")
log("[BODYCAM] Author: Brouken")
log("========================================")

BC:load_tuning()

local initialized =
    false

Hooks:PostHook(
    FPCameraPlayerBase,
    "update",
    "BODYCAM_V073_InertiaUpdate",

    function(
        self,
        unit,
        t,
        dt
    )

        if not self._parent_unit
        or not alive(self._parent_unit) then

            return

        end

        if not self._vel_overshot then
            return
        end

        if not BC.modes then
            return
        end

        local mode =
            BC.modes[BC.mode]

        if not mode then
            return
        end

        local yaw =
            tonumber(mode.yaw)
            or 0

        local pitch =
            tonumber(mode.pitch)
            or 0

        local pivot_x =
            tonumber(mode.pivot_x)
            or 0

        local pivot_y =
            tonumber(mode.pivot_y)
            or 0

        local pivot_z =
            tonumber(mode.pivot_z)
            or 0

        self._vel_overshot.yaw_neg =
            yaw

        self._vel_overshot.yaw_pos =
            -yaw

        self._vel_overshot.pitch_neg =
            -pitch

        self._vel_overshot.pitch_pos =
            pitch

        if self._vel_overshot.pivot then

            mvector3.set(
                self._vel_overshot.pivot,

                Vector3(
                    pivot_x,
                    pivot_y,
                    pivot_z
                )
            )

        end

        if not initialized then

            initialized =
                true

            log(
                "[BODYCAM] FPCameraPlayerBase OK."
            )

            log(
                "[BODYCAM] Vel overshot encontrado."
            )

            log(
                "[BODYCAM] Inertia Engine ACTIVO."
            )

            BC:show_mode()

        end

    end
)

if not FPCameraPlayerBase then
    return
end

-- Author: Brouken

_G.BODYCAM_FREEAIM =
    _G.BODYCAM_FREEAIM or {}

local FA =
    _G.BODYCAM_FREEAIM

FA.yaw =
    FA.yaw or 0

FA.pitch =
    FA.pitch or 0

FA.last_camera_yaw =
    nil

FA.last_camera_pitch =
    nil

FA.initialized =
    false

FA.weapon_found =
    false

FA.pivot_found =
    false

FA.camera_base =
    nil

FA.camera_unit =
    nil

FA.player_unit =
    nil

FA.weapon_unit =
    nil

FA.weapon_pivot =
    nil

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

local function angle_delta(
    current,
    previous
)

    local delta =
        current - previous

    if delta > 180 then

        delta =
            delta - 360

    elseif delta < -180 then

        delta =
            delta + 360

    end

    return delta
end

log("========================================")
log("[BODYCAM] V0.7.3")
log("[BODYCAM] WEAPON PIVOT FREE AIM")
log("[BODYCAM] Author: Brouken")
log("========================================")

Hooks:PostHook(
    FPCameraPlayerBase,
    "update",
    "BODYCAM_FreeAim_V073_Update",

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

        if not self._unit
        or not alive(self._unit) then

            return

        end

        FA.camera_base =
            self

        FA.camera_unit =
            self._unit

        FA.player_unit =
            self._parent_unit

        local inventory =
            self._parent_unit:inventory()

        if not inventory then
            return
        end

        local weapon =
            inventory:equipped_unit()

        if not weapon
        or not alive(weapon) then

            FA.weapon_unit =
                nil

            return

        end

        FA.weapon_unit =
            weapon

        if not FA.weapon_found then

            FA.weapon_found =
                true

            log(
                "[BODYCAM] Weapon Unit encontrada."
            )

        end

        -- FIND a_weapon_right

        local weapon_pivot =
            nil

        local pivot_ok,
        pivot_result =
            pcall(
                function()

                    return self._unit:get_object(
                        Idstring(
                            "a_weapon_right"
                        )
                    )

                end
            )

        if pivot_ok then

            weapon_pivot =
                pivot_result

        end

        if not weapon_pivot then

            if not FA.pivot_error_logged then

                FA.pivot_error_logged =
                    true

                log(
                    "[BODYCAM] ERROR: a_weapon_right no encontrado."
                )

            end

            return

        end

        FA.weapon_pivot =
            weapon_pivot

        if not FA.pivot_found then

            FA.pivot_found =
                true

            log(
                "[BODYCAM] a_weapon_right encontrado."
            )

            log(
                "[BODYCAM] Weapon Pivot disponible."
            )

        end

        local cfg =
            _G.BODYCAM_FREEAIM_TUNING

        if not cfg then
            return
        end

        if not cfg.enabled then

            -- No aplicamos absolutamente ninguna
            -- transformacion cuando esta OFF.
            -- PAYDAY mantiene el arma vanilla.

            return

        end

        local camera_rotation =
            self._unit:rotation()

        if not camera_rotation then
            return
        end

        local current_yaw =
            camera_rotation:yaw()

        local current_pitch =
            camera_rotation:pitch()

        if FA.last_camera_yaw == nil then

            FA.last_camera_yaw =
                current_yaw

            FA.last_camera_pitch =
                current_pitch

            return

        end

        local dyaw =
            angle_delta(
                current_yaw,
                FA.last_camera_yaw
            )

        local dpitch =
            angle_delta(
                current_pitch,
                FA.last_camera_pitch
            )

        FA.last_camera_yaw =
            current_yaw

        FA.last_camera_pitch =
            current_pitch

        dyaw =
            clamp(
                dyaw,
                -15,
                15
            )

        dpitch =
            clamp(
                dpitch,
                -15,
                15
            )

        local sensitivity =
            tonumber(
                cfg.sensitivity
            )
            or 1

        local max_yaw =
            tonumber(
                cfg.max_yaw
            )
            or 30

        local max_pitch =
            tonumber(
                cfg.max_pitch
            )
            or 20

        FA.yaw =
            FA.yaw
            - dyaw
            * sensitivity

        FA.pitch =
            FA.pitch
            + dpitch
            * sensitivity

        FA.yaw =
            clamp(
                FA.yaw,
                -max_yaw,
                max_yaw
            )

        FA.pitch =
            clamp(
                FA.pitch,
                -max_pitch,
                max_pitch
            )

        -- Este transform ya fue actualizado por PAYDAY.

        local pivot_position =
            weapon_pivot:position()

        local pivot_rotation =
            weapon_pivot:rotation()

        if not pivot_position
        or not pivot_rotation then

            return

        end

        local offset_rotation =
            Rotation(
                FA.yaw,
                FA.pitch,
                0
            )

        local final_rotation =
            pivot_rotation
            * offset_rotation

        -- PAYDAY ya posiciono el arma en
        -- a_weapon_right.
        -- Nosotros mantenemos esa posicion y solamente
        -- alteramos su orientacion.

        weapon:set_position(
            pivot_position
        )

        weapon:set_rotation(
            final_rotation
        )

        if not FA.initialized then

            FA.initialized =
                true

            log(
                "[BODYCAM] V0.7.3 Free Aim aplicado al Weapon Unit."
            )

            log(
                "[BODYCAM] Base transform = a_weapon_right."
            )

            log(
                "[BODYCAM] F8 = comparar ON/OFF."
            )

            if managers
            and managers.hud
            and managers.hud.show_hint then

                managers.hud:show_hint({
                    text =
                        "BODYCAM | WEAPON FREE AIM V0.7.3"
                })

            end

        end

    end
)

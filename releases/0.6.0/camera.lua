if not FPCameraPlayerBase then
    return
end

log("[BODYCAM] V0.6 - Weapon inertia cargado.")

local BC = {
    initialized = false,

    -- Intensidad horizontal
    yaw = 18,

    -- Intensidad vertical
    pitch = 14,

    -- Qué tan lejos está el pivote.
    -- Cuanto más negativo Y, más sensación de arrastre.
    pivot_y = -35
}

Hooks:PostHook(
    FPCameraPlayerBase,
    "update",
    "BODYCAM_WeaponInertia",
    function(self, unit, t, dt)

        if not self._parent_unit
        or not alive(self._parent_unit) then
            return
        end

        if not self._vel_overshot then
            return
        end

        self._vel_overshot.yaw_neg = BC.yaw
        self._vel_overshot.yaw_pos = -BC.yaw

        self._vel_overshot.pitch_neg = -BC.pitch
        self._vel_overshot.pitch_pos = BC.pitch

        if self._vel_overshot.pivot then
            mvector3.set(
                self._vel_overshot.pivot,
                Vector3(0, BC.pivot_y, 0)
            )
        end

        if not BC.initialized then
            BC.initialized = true

            log("[BODYCAM] FPCameraPlayerBase OK.")
            log("[BODYCAM] Vel overshot encontrado.")
            log("[BODYCAM] Inercia aplicada a arma/brazos.")
        end
    end
)

if not PlayerStandard then
    return
end

-- Author: Brouken

log("========================================")
log("[BODYCAM] Main V0.7.3 cargado.")
log("[BODYCAM] Author: Brouken")
log("========================================")

local initialized = false

Hooks:PostHook(
    PlayerStandard,
    "update",
    "BODYCAM_PlayerStandard_V073_Update",
    function(self, t, dt)

        if initialized then
            return
        end

        if not self._unit
        or not alive(self._unit) then
            return
        end

        initialized = true

        log("[BODYCAM] PlayerStandard detectado.")
        log("[BODYCAM] Jugador OK.")
    end
)

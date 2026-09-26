-- Author: Brouken

if not PlayerStandard then
    return
end

_G.BODYCAM =
    _G.BODYCAM or {}

local initialized =
    false

log("[BODYCAM] V0.15.0 | Experimental - disparo orientado por el canon; base estable 0.14.1 | Brouken")

Hooks:PostHook(
    PlayerStandard,
    "update",
    "BODYCAM_V0122_PlayerUpdate",

    function(self, t, dt)

        if initialized then
            return
        end

        if not self._unit
        or not alive(self._unit) then
            return
        end

        initialized =
            true

        log(
            "[BODYCAM] Jugador inicializado."
        )

    end
)

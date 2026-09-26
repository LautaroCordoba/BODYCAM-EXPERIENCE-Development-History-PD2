-- Author: Brouken

if not _G.BODYCAM_FREEAIM_TUNING then

    log(
        "[BODYCAM] ERROR: FREE AIM no cargado."
    )

    return

end

BODYCAM_FREEAIM_TUNING.enabled =
    not BODYCAM_FREEAIM_TUNING.enabled

if _G.BODYCAM_FREEAIM
and BODYCAM_FREEAIM.full_reset then

    BODYCAM_FREEAIM:full_reset()

end

local state

if BODYCAM_FREEAIM_TUNING.enabled then

    state =
        "FreeAim + inercia: ON"

else

    state =
        "FreeAim + inercia: OFF"

end

log("[BODYCAM] " .. state)

if managers
and managers.hud
and managers.hud.show_hint then

    managers.hud:show_hint({
        text =
            "BODYCAM | "
            .. state
    })

end

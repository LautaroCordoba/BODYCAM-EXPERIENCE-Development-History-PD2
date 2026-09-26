-- Author: Brouken

if not _G.BODYCAM_FREEAIM_TUNING then

    log(
        "[BODYCAM] ERROR: FREEAIM_TUNING no existe."
    )

    return
end

BODYCAM_FREEAIM_TUNING.enabled =
    not BODYCAM_FREEAIM_TUNING.enabled

if _G.BODYCAM_FREEAIM then

    BODYCAM_FREEAIM.yaw =
        0

    BODYCAM_FREEAIM.pitch =
        0

    BODYCAM_FREEAIM.last_camera_yaw =
        nil

    BODYCAM_FREEAIM.last_camera_pitch =
        nil

end

local state_text

if BODYCAM_FREEAIM_TUNING.enabled then

    state_text =
        "FREE AIM: ON"

else

    state_text =
        "FREE AIM: OFF"

end

log("========================================")
log("[BODYCAM] " .. state_text)
log("========================================")

if managers
and managers.hud
and managers.hud.show_hint then

    managers.hud:show_hint({
        text =
            "BODYCAM | "
            .. state_text
    })

end

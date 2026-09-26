-- Author: Brouken

if not _G.BODYCAM then

    log(
        "[BODYCAM] ERROR: BODYCAM no cargado."
    )

    return

end

if not BODYCAM.load_tuning then

    log(
        "[BODYCAM] ERROR: load_tuning no existe."
    )

    return

end

local success =
    BODYCAM:load_tuning()

if not success then

    log(
        "[BODYCAM] ERROR recargando tuning."
    )

    return

end

if _G.BODYCAM_FREEAIM
and BODYCAM_FREEAIM.full_reset then

    BODYCAM_FREEAIM:full_reset()

end

BODYCAM:notify(
    "TUNING RECARGADO"
)

BODYCAM:show_mode()

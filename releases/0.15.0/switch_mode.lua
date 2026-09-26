-- Author: Brouken

if not _G.BODYCAM then

    log(
        "[BODYCAM] ERROR: BODYCAM no cargado."
    )

    return

end

if not BODYCAM.next_mode then

    log(
        "[BODYCAM] ERROR: next_mode no existe."
    )

    return

end

BODYCAM:next_mode()

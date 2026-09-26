-- Author: Brouken

if not _G.BODYCAM then

    log(
        "[BODYCAM] ERROR: BODYCAM no esta cargado."
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

if success then

    BODYCAM:notify(
        "TUNING RECARGADO"
    )

    BODYCAM:show_mode()

else

    log(
        "[BODYCAM] ERROR recargando tuning."
    )

end

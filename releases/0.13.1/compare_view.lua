-- BODYCAM V0.13.1 - session-only view comparison
if _G.BODYCAM and BODYCAM.next_view then
    BODYCAM:next_view()
else
    log("[BODYCAM] ERROR: comparacion de vista no cargada.")
end

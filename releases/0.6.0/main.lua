if not PlayerStandard then
    return
end

log("[BODYCAM] V0.2 cargado.")

local BC = {
    time = 0,
    initialized = false
}

Hooks:PostHook(
    PlayerStandard,
    "update",
    "BODYCAM_PlayerStandard_Update",
    function(self, t, dt)

        if not self._unit or not alive(self._unit) then
            return
        end

        local camera = self._unit:camera()

        if not camera then
            return
        end

        local camera_base = camera:camera_unit()

        if not camera_base or not alive(camera_base) then
            return
        end

        -- Intentamos encontrar el arma equipada.
        local inventory = self._unit:inventory()

        if not inventory then
            return
        end

        local weapon = inventory:equipped_unit()

        if not weapon or not alive(weapon) then
            return
        end

        if not BC.initialized then
            BC.initialized = true

            log("[BODYCAM] Jugador OK.")
            log("[BODYCAM] Camara OK.")
            log("[BODYCAM] Arma equipada detectada.")
            log("[BODYCAM] Iniciando prueba procedural.")
        end

        BC.time = BC.time + dt

        local horizontal = math.sin(BC.time * 2) * 0.4
        local vertical   = math.sin(BC.time * 4) * 0.15

        -- Por ahora NO modificamos el arma directamente.
        -- Primero calculamos el movimiento para confirmar
        -- que nuestro update funciona correctamente.

        BC.offset_x = horizontal
        BC.offset_y = vertical
    end
)

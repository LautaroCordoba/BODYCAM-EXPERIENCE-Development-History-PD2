-- Author: Brouken
-- F6 = cambiar perfil
-- F7 = recargar tuning
-- F8 = Free Aim ON/OFF

_G.BODYCAM_TUNING = {

    {
        name = "DEFAULT",

        yaw = 0,
        pitch = 0,

        pivot_x = 0,
        pivot_y = 0,
        pivot_z = 0
    },

    {
        name = "V0.6 ORIGINAL",

        yaw = 18,
        pitch = 14,

        pivot_x = 0,
        pivot_y = -35,
        pivot_z = 0
    },

    {
        name = "ROTACION FUERTE",

        yaw = 30,
        pitch = 22,

        pivot_x = 0,
        pivot_y = -25,
        pivot_z = 0
    },

    {
        name = "PIVOTE HOMBRO",

        yaw = 24,
        pitch = 18,

        pivot_x = 12,
        pivot_y = -40,
        pivot_z = -8
    },

    {
        name = "BRAZOS SUAVES",

        yaw = 14,
        pitch = 11,

        pivot_x = 0,
        pivot_y = -18,
        pivot_z = -4
    },

    {
        name = "MUNECA / CANON",

        yaw = 20,
        pitch = 15,

        pivot_x = 4,
        pivot_y = -12,
        pivot_z = -6
    }

}

_G.BODYCAM_FREEAIM_TUNING =
    _G.BODYCAM_FREEAIM_TUNING or {}

-- Solo definimos enabled si todavía no existe.
-- De esta forma F7 NO pisa el estado que hayas
-- seleccionado con F8.

if _G.BODYCAM_FREEAIM_TUNING.enabled == nil then

    _G.BODYCAM_FREEAIM_TUNING.enabled =
        true

end

_G.BODYCAM_FREEAIM_TUNING.max_yaw =
    30

_G.BODYCAM_FREEAIM_TUNING.max_pitch =
    20

_G.BODYCAM_FREEAIM_TUNING.sensitivity =
    2.0

_G.BODYCAM_FREEAIM_TUNING.smoothing =
    12

-- Author: Brouken

_G.BODYCAM_TUNING = {

    {
        name = "DEFAULT",

        max_yaw = 15,
        max_pitch = 9,

        sensitivity = 0.25,

        shoulder_yaw = 0.78,
        shoulder_pitch = 0.68,

        soft_start = 0.60,
        edge_multiplier = 0.28,

        inertia_yaw = 7,
        inertia_pitch = 5,

        pivot_x = 3,
        pivot_y = -10,
        pivot_z = -5,

        center_x = 0,
        center_y = 0,
        center_z = 0
    },

    {
        name = "HYBRID",

        max_yaw = 16,
        max_pitch = 10,

        sensitivity = 0.24,

        shoulder_yaw = 0.80,
        shoulder_pitch = 0.70,

        soft_start = 0.59,
        edge_multiplier = 0.27,

        inertia_yaw = 25,
        inertia_pitch = 18,

        pivot_x = 4,
        pivot_y = -12,
        pivot_z = -6,

        center_x = 0,
        center_y = 0,
        center_z = 0
    },

    {
        name = "Wrist",

        max_yaw = 16,
        max_pitch = 10,

        sensitivity = 0.25,

        shoulder_yaw = 0.88,
        shoulder_pitch = 0.64,

        soft_start = 0.66,
        edge_multiplier = 0.25,

        inertia_yaw = 17,
        inertia_pitch = 10,

        pivot_x = 3,
        pivot_y = -7,
        pivot_z = -4,

        center_x = 0,
        center_y = 0,
        center_z = 0
    }
}

_G.BODYCAM_FREEAIM_TUNING =
    _G.BODYCAM_FREEAIM_TUNING or {}

if _G.BODYCAM_FREEAIM_TUNING.enabled == nil then

    _G.BODYCAM_FREEAIM_TUNING.enabled =
        true

end

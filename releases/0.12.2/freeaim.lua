if not FPCameraPlayerBase then
    return
end

-- Author: Brouken

_G.BODYCAM_FREEAIM =
    _G.BODYCAM_FREEAIM or {}

local FA =
    _G.BODYCAM_FREEAIM

FA.yaw =
    FA.yaw or 0

FA.pitch =
    FA.pitch or 0

FA.amount =
    FA.amount or 0

FA.last_camera_yaw =
    nil

FA.last_camera_pitch =
    nil

FA.last_weapon_key =
    nil

FA.initialized =
    false

local function clamp(
    value,
    minimum,
    maximum
)

    if value < minimum then
        return minimum
    end

    if value > maximum then
        return maximum
    end

    return value

end

local function smoothstep(value)

    value =
        clamp(
            value,
            0,
            1
        )

    return
        value
        * value
        * (3 - 2 * value)

end

local function angle_delta(
    current,
    previous
)

    local delta =
        current - previous

    while delta > 180 do

        delta =
            delta - 360

    end

    while delta < -180 do

        delta =
            delta + 360

    end

    return delta

end

local function valid_number(value)

    if type(value) ~= "number" then
        return false
    end

    if value ~= value then
        return false
    end

    if value == math.huge
    or value == -math.huge then
        return false
    end

    return true

end

local function get_weapon_key()

    if not managers
    or not managers.player then
        return nil
    end

    local player =
        managers.player:player_unit()

    if not player
    or not alive(player) then
        return nil
    end

    local inventory =
        player:inventory()

    if not inventory then
        return nil
    end

    local weapon =
        inventory:equipped_unit()

    if not weapon
    or not alive(weapon) then
        return nil
    end

    return tostring(
        weapon:key()
    )

end

function FA:reset_tracking()

    self.last_camera_yaw =
        nil

    self.last_camera_pitch =
        nil

end

function FA:reset_position()

    self.yaw =
        0

    self.pitch =
        0

    self.amount =
        0

    self:reset_tracking()

end

function FA:full_reset()

    self:reset_position()

    self.last_weapon_key =
        get_weapon_key()

end

function FA:sanitize(profile)

    local max_yaw =
        tonumber(
            profile.max_yaw
        )
        or 15

    local max_pitch =
        tonumber(
            profile.max_pitch
        )
        or 9

    if not valid_number(
        self.yaw
    ) then

        log(
            "[BODYCAM] Invalid FA.yaw -> RESET."
        )

        self.yaw =
            0

    end

    if not valid_number(
        self.pitch
    ) then

        log(
            "[BODYCAM] Invalid FA.pitch -> RESET."
        )

        self.pitch =
            0

    end

    self.yaw =
        clamp(
            self.yaw,
            -max_yaw,
            max_yaw
        )

    self.pitch =
        clamp(
            self.pitch,
            -max_pitch,
            max_pitch
        )

end

function FA:edge_weight(
    current,
    maximum,
    movement,
    profile
)

    if maximum <= 0 then
        return 1
    end

    if current > 0
    and movement < 0 then

        return 1

    end

    if current < 0
    and movement > 0 then

        return 1

    end

    local amount =
        math.abs(current)
        /
        maximum

    amount =
        clamp(
            amount,
            0,
            1
        )

    local soft_start =
        tonumber(
            profile.soft_start
        )
        or 0.60

    local minimum =
        tonumber(
            profile.edge_multiplier
        )
        or 0.28

    if amount <= soft_start then

        return 1

    end

    local edge =
        (amount - soft_start)
        /
        math.max(
            1 - soft_start,
            0.001
        )

    edge =
        smoothstep(
            edge
        )

    return
        1
        -
        edge
        * (1 - minimum)

end

log("========================================")
log("[BODYCAM] V0.12.2 STABLE FREE AIM")
log("[BODYCAM] CAMERA SPEED UNRESTRICTED")
log("[BODYCAM] NO CAMERA JUMP FILTER")
log("[BODYCAM] Author: Brouken")
log("========================================")

Hooks:PostHook(
    FPCameraPlayerBase,
    "update",
    "BODYCAM_V0122_StableFreeAim",

    function(self, unit, t, dt)

        local BC =
            _G.BODYCAM

        if not BC
        or not BC.modes then
            return
        end

        local profile =
            BC.modes[
                BC.mode
            ]

        if not profile then
            return
        end

        FA:sanitize(
            profile
        )

        local cfg =
            _G.BODYCAM_FREEAIM_TUNING

        if not cfg
        or not cfg.enabled then

            FA:reset_tracking()

            return

        end

        local weapon_key =
            get_weapon_key()

        if weapon_key
        and FA.last_weapon_key
        and weapon_key ~= FA.last_weapon_key then

            FA:reset_position()

        end

        FA.last_weapon_key =
            weapon_key

        if not self._unit
        or not alive(self._unit) then

            FA:reset_tracking()

            return

        end

        local rotation =
            self._unit:rotation()

        if not rotation then

            FA:reset_tracking()

            return

        end

        local current_yaw =
            rotation:yaw()

        local current_pitch =
            rotation:pitch()

        if not valid_number(
            current_yaw
        )
        or not valid_number(
            current_pitch
        ) then

            FA:reset_tracking()

            return

        end

        if FA.last_camera_yaw == nil
        or FA.last_camera_pitch == nil then

            FA.last_camera_yaw =
                current_yaw

            FA.last_camera_pitch =
                current_pitch

            return

        end

        local dyaw =
            angle_delta(
                current_yaw,
                FA.last_camera_yaw
            )

        local dpitch =
            angle_delta(
                current_pitch,
                FA.last_camera_pitch
            )

        FA.last_camera_yaw =
            current_yaw

        FA.last_camera_pitch =
            current_pitch

        if not valid_number(
            dyaw
        )
        or not valid_number(
            dpitch
        ) then

            FA:reset_tracking()

            return

        end

        local sensitivity =
            tonumber(
                profile.sensitivity
            )
            or 0.25

        local max_yaw =
            tonumber(
                profile.max_yaw
            )
            or 15

        local max_pitch =
            tonumber(
                profile.max_pitch
            )
            or 9

        local yaw_weight =
            FA:edge_weight(
                FA.yaw,
                max_yaw,
                dyaw,
                profile
            )

        local pitch_weight =
            FA:edge_weight(
                FA.pitch,
                max_pitch,
                dpitch,
                profile
            )

        FA.yaw =
            FA.yaw
            +
            dyaw
            * sensitivity
            * yaw_weight

        FA.pitch =
            FA.pitch
            +
            dpitch
            * sensitivity
            * pitch_weight

        FA.yaw =
            clamp(
                FA.yaw,
                -max_yaw,
                max_yaw
            )

        FA.pitch =
            clamp(
                FA.pitch,
                -max_pitch,
                max_pitch
            )

        FA:sanitize(
            profile
        )

        local yaw_amount =
            math.abs(
                FA.yaw
            )
            /
            math.max(
                max_yaw,
                0.001
            )

        local pitch_amount =
            math.abs(
                FA.pitch
            )
            /
            math.max(
                max_pitch,
                0.001
            )

        FA.amount =
            clamp(
                math.max(
                    yaw_amount,
                    pitch_amount
                ),
                0,
                1
            )

        if not FA.initialized then

            FA.initialized =
                true

            log(
                "[BODYCAM] Stable Free Aim ACTIVE."
            )

        end

    end
)

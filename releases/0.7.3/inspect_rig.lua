-- Author: Brouken

if not _G.BODYCAM_FREEAIM then

    log(
        "[BODYCAM][RIG] ERROR: BODYCAM_FREEAIM no existe."
    )

    return
end

local FA =
    _G.BODYCAM_FREEAIM

local function separator()

    log(
        "============================================================"
    )

end

local function vector_string(v)

    if not v then
        return "NIL"
    end

    return string.format(
        "(%.3f, %.3f, %.3f)",
        v.x,
        v.y,
        v.z
    )

end

local function rotation_string(r)

    if not r then
        return "NIL"
    end

    return string.format(
        "YAW=%.3f PITCH=%.3f ROLL=%.3f",
        r:yaw(),
        r:pitch(),
        r:roll()
    )

end

local function inspect_object(
    label,
    object
)

    log(
        "[BODYCAM][RIG] "
        .. label
    )

    if not object then

        log(
            "[BODYCAM][RIG]   EXISTE = NO"
        )

        return
    end

    log(
        "[BODYCAM][RIG]   EXISTE = SI"
    )

    local ok_pos, pos =
        pcall(
            function()
                return object:position()
            end
        )

    if ok_pos then

        log(
            "[BODYCAM][RIG]   POS = "
            .. vector_string(pos)
        )

    else

        log(
            "[BODYCAM][RIG]   POS = ERROR"
        )

    end

    local ok_rot, rot =
        pcall(
            function()
                return object:rotation()
            end
        )

    if ok_rot then

        log(
            "[BODYCAM][RIG]   ROT = "
            .. rotation_string(rot)
        )

    else

        log(
            "[BODYCAM][RIG]   ROT = ERROR"
        )

    end

end

separator()

log(
    "[BODYCAM][RIG] V0.7.2 INSPECCION"
)

log(
    "[BODYCAM][RIG] Author: Brouken"
)

local cfg =
    _G.BODYCAM_FREEAIM_TUNING

if cfg then

    log(
        "[BODYCAM][RIG] FREE AIM = "
        .. (
            cfg.enabled
            and "ON"
            or "OFF"
        )
    )

else

    log(
        "[BODYCAM][RIG] FREE AIM CONFIG = NIL"
    )

end

log(
    "[BODYCAM][RIG] FA YAW = "
    .. tostring(FA.yaw)
)

log(
    "[BODYCAM][RIG] FA PITCH = "
    .. tostring(FA.pitch)
)

local camera_unit =
    FA.camera_unit

if not camera_unit
or not alive(camera_unit) then

    log(
        "[BODYCAM][RIG] ERROR: Camera Unit no disponible."
    )

    separator()

    return
end

log(
    "[BODYCAM][RIG] CAMERA UNIT = OK"
)

local camera_pos =
    camera_unit:position()

local camera_rot =
    camera_unit:rotation()

log(
    "[BODYCAM][RIG] CAMERA POS = "
    .. vector_string(camera_pos)
)

log(
    "[BODYCAM][RIG] CAMERA ROT = "
    .. rotation_string(camera_rot)
)

local camera_orientation =
    nil

local orientation_ok,
orientation_result =
    pcall(
        function()
            return camera_unit:orientation_object()
        end
    )

if orientation_ok then

    camera_orientation =
        orientation_result
end

inspect_object(
    "CAMERA orientation_object",
    camera_orientation
)

local object_names = {

    "a_weapon_right",
    "a_weapon_left",

    "a_weapon_right_front",
    "a_weapon_left_front",

    "a_weapon"

}

for _, object_name
in ipairs(object_names) do

    local object =
        nil

    local ok, result =
        pcall(
            function()

                return camera_unit:get_object(
                    Idstring(object_name)
                )

            end
        )

    if ok then

        object =
            result

    end

    inspect_object(
        "CAMERA " .. object_name,
        object
    )

end

local weapon =
    FA.weapon_unit

if not weapon
or not alive(weapon) then

    log(
        "[BODYCAM][RIG] ERROR: Weapon Unit no disponible."
    )

    separator()

    return
end

log(
    "[BODYCAM][RIG] WEAPON UNIT = OK"
)

local weapon_pos =
    weapon:position()

local weapon_rot =
    weapon:rotation()

log(
    "[BODYCAM][RIG] WEAPON POS = "
    .. vector_string(weapon_pos)
)

log(
    "[BODYCAM][RIG] WEAPON ROT = "
    .. rotation_string(weapon_rot)
)

local weapon_orientation =
    nil

local weapon_orientation_ok,
weapon_orientation_result =
    pcall(
        function()

            return weapon:orientation_object()

        end
    )

if weapon_orientation_ok then

    weapon_orientation =
        weapon_orientation_result

end

inspect_object(
    "WEAPON orientation_object",
    weapon_orientation
)

local fire_object =
    nil

local fire_ok,
fire_result =
    pcall(
        function()

            return weapon:get_object(
                Idstring("fire")
            )

        end
    )

if fire_ok then

    fire_object =
        fire_result

end

inspect_object(
    "WEAPON fire",
    fire_object
)

-- RaycastWeaponBase expone fire_object().

local weapon_base =
    nil

local base_ok,
base_result =
    pcall(
        function()

            return weapon:base()

        end
    )

if base_ok then

    weapon_base =
        base_result

end

if weapon_base then

    local base_fire =
        nil

    local base_fire_ok,
    base_fire_result =
        pcall(
            function()

                if weapon_base.fire_object then

                    return weapon_base:fire_object()

                end

                return nil

            end
        )

    if base_fire_ok then

        base_fire =
            base_fire_result

    end

    inspect_object(
        "WEAPON base():fire_object()",
        base_fire
    )

end

log(
    "[BODYCAM][RIG] INSPECCION TERMINADA"
)

separator()

if managers
and managers.hud
and managers.hud.show_hint then

    managers.hud:show_hint({
        text =
            "BODYCAM | RIG INSPECCIONADO"
    })

end

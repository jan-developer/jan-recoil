local QBCore = exports['qb-core']:GetCoreObject()
local uiOpen = false
local currentRecoil = Config.DefaultRecoil

-- Weapons names ( add what u want)
local WeaponNames = {
    [`WEAPON_PISTOL`] = "Pistol",
    [`WEAPON_COMBATPISTOL`] = "Combat Pistol",
    [`WEAPON_APPISTOL`] = "AP Pistol",
    [`WEAPON_MICROSMG`] = "Micro SMG",
    [`WEAPON_SMG`] = "SMG",
    [`WEAPON_ASSAULTRIFLE`] = "Assault Rifle",
    [`WEAPON_CARBINERIFLE`] = "Carbine Rifle",
    [`WEAPON_PUMPSHOTGUN`] = "Pump Shotgun",

}


RegisterCommand(Config.Command, function()
    if uiOpen then return end
    uiOpen = true
    SetNuiFocus(true, true)

    local weapon = GetSelectedPedWeapon(PlayerPedId())
    currentRecoil = Config.CustomRecoil[weapon] or Config.WeaponRecoil[weapon] or Config.DefaultRecoil

    SendNUIMessage({
        action = 'toggle',
        open = true,
        recoil = currentRecoil,
        weapon = GetWeaponLabel(weapon)
    })
end)


RegisterNUICallback('setRecoil', function(data, cb)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    local val = tonumber(data.recoil) or Config.DefaultRecoil
    Config.CustomRecoil[weapon] = val
    currentRecoil = val
    cb('ok')
end)

RegisterNUICallback('saveRecoil', function(_, cb)
    cb('ok')
end)

RegisterNUICallback('resetRecoil', function(_, cb)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    Config.CustomRecoil[weapon] = Config.WeaponRecoil[weapon] or Config.DefaultRecoil
    currentRecoil = Config.CustomRecoil[weapon]
    SendNUIMessage({ action = 'update', recoil = currentRecoil })
    cb('ok')
end)

RegisterNUICallback('closeUI', function(_, cb)
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'toggle', open = false })
    cb('ok')
end)


function GetWeaponLabel(hash)
    return WeaponNames[hash] or "Unknown Weapon"
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local weapon = GetSelectedPedWeapon(ped)
            local recoil = Config.CustomRecoil[weapon] or Config.WeaponRecoil[weapon] or Config.DefaultRecoil

            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', recoil * 0.03)

            local camRot = GetGameplayCamRot(0)
            local pitchAdd = recoil * (1.0 + math.random() * 0.25)
            SetGameplayCamRelativePitch(camRot.x + pitchAdd, 0.15)
        end
    end
end)

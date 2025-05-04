-- GitHub: https://github.com/vedrion
-- Website: https://ved.tebex.io/

local wasMenuOpen = false
local holdingMap = false
local mapNet = nil

local function Log(level, message)
    if not Config.Debug then return end
    -- ^1 = Red, ^2 = Green, ^3 = Yellow, ^4 = Blue, ^5 = Light Blue, ^6 = Purple, ^7 = White
    local levels = { INFO = 1, WARN = 2, ERROR = 3 }
    local colors = { INFO = "^5", WARN = "^3", ERROR = "^1" }
    local currentLevel = levels[Config.LogLevel] or 1
    local msgLevel = levels[level] or 1

    if msgLevel >= currentLevel then
        local color = colors[level] or "^7"
        print(("^2[Pause Map]^7 [%s%s^7] %s"):format(color, level, message))
    end
end

local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function SafeDeleteEntity(entity)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end

local function IsPlayerAbleToHoldMap()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    return weapon == `WEAPON_UNARMED` and not IsPedInAnyVehicle(ped, false)
end

local function CreateMap()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not IsPlayerAbleToHoldMap() then
        Log("WARN", "Can't open map: player not unarmed or in vehicle.")
        return
    end

    LoadModel(Config.MapModel)
    LoadAnimDict(Config.AnimDict)

    local mapSpawned = CreateObject(GetHashKey(Config.MapModel), playerCoords.x, playerCoords.y, playerCoords.z + 0.2,
        true, true, true)
    if not DoesEntityExist(mapSpawned) then
        Log("ERROR", "Failed to create map object.")
        return
    end

    local netId = ObjToNet(mapSpawned)
    if not NetworkDoesNetworkIdExist(netId) then
        Log("ERROR", "Network ID not valid for map object.")
        return
    end

    SetNetworkIdCanMigrate(netId, false)
    SetEntityAsMissionEntity(mapSpawned, true, true)
    AttachEntityToEntity(mapSpawned, playerPed, GetPedBoneIndex(playerPed, 60309),
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    ClearPedSecondaryTask(playerPed)
    TaskPlayAnim(playerPed, Config.AnimDict, Config.AnimName, 8.0, -8.0, -1, 49, 0, false, false, false)

    mapNet = netId
    holdingMap = true

    Log("INFO", "Map opened and attached to player.")
end

local function RemoveMap()
    local playerPed = PlayerPedId()

    if holdingMap and mapNet then
        ClearPedSecondaryTask(playerPed)

        local mapObj = NetToObj(mapNet)
        if DoesEntityExist(mapObj) then
            DetachEntity(mapObj, true, true)
            SafeDeleteEntity(mapObj)
        end

        mapNet = nil
    end

    holdingMap = false
    Log("INFO", "Map removed from player.")
end

-- Auto open/close on pause menu
CreateThread(function()
    while true do
        Wait(300)

        if IsPauseMenuActive() and not wasMenuOpen then
            if not holdingMap then
                TriggerEvent("ved-pauseMap:ToggleMap")
            end
            wasMenuOpen = true
        elseif not IsPauseMenuActive() and wasMenuOpen then
            Wait(500)
            if holdingMap then
                TriggerEvent("ved-pauseMap:ToggleMap")
            end
            wasMenuOpen = false
        end
    end
end)

-- Manual open/close with key
if Config.AllowKeyOpen then
    CreateThread(function()
        while true do
            Wait(0)
            if IsControlJustReleased(0, Config.OpenKey) then
                if not holdingMap and IsPlayerAbleToHoldMap() then
                    TriggerEvent("ved-pauseMap:ToggleMap")
                elseif holdingMap then
                    TriggerEvent("ved-pauseMap:ToggleMap")
                end
            end
        end
    end)
end

-- Auto close on death, fall, weapon, or vehicle
CreateThread(function()
    while true do
        Wait(500)

        local ped = PlayerPedId()

        if holdingMap then
            if (Config.CloseOnDeath and IsEntityDead(ped)) then
                Log("WARN", "Closing map: player died.")
                TriggerEvent("ved-pauseMap:ToggleMap")
            elseif (Config.CloseOnFall and (IsPedRagdoll(ped) or IsPedFalling(ped))) then
                Log("WARN", "Closing map: player fell or ragdolled.")
                TriggerEvent("ved-pauseMap:ToggleMap")
            elseif (Config.CloseInVehicle and IsPedInAnyVehicle(ped, false)) then
                Log("WARN", "Closing map: player entered a vehicle.")
                TriggerEvent("ved-pauseMap:ToggleMap")
            elseif (Config.CloseOnWeapon and GetSelectedPedWeapon(ped) ~= `WEAPON_UNARMED`) then
                Log("WARN", "Closing map: player switched weapon.")
                TriggerEvent("ved-pauseMap:ToggleMap")
            end
        end
    end
end)

-- Toggle map event
RegisterNetEvent("ved-pauseMap:ToggleMap", function()
    if not holdingMap then
        Log("INFO", "Toggling map: opening...")
        CreateMap()
    else
        Log("INFO", "Toggling map: closing...")
        RemoveMap()
    end
end)

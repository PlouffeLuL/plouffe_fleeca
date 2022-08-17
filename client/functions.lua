local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")
local Interface = exports.plouffe_lib:Get("Interface")
local Lang = exports.plouffe_lib:Get("Lang")

local Wait = Wait
local GetEntityCoords = GetEntityCoords
local GetEntityRotation = GetEntityRotation
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local PlayerPedId = PlayerPedId

local GetPedBoneIndex = GetPedBoneIndex
local DoesEntityExist = DoesEntityExist
local SetEntityCollision = SetEntityCollision
local SetEntityCoords = SetEntityCoords
local AttachEntityToEntity = AttachEntityToEntity
local DeleteEntity = DeleteEntity
local GetClosestObjectOfType = GetClosestObjectOfType
local DetachEntity = DetachEntity
local FreezeEntityPosition = FreezeEntityPosition
local SetEntityNoCollisionEntity = SetEntityNoCollisionEntity
local SetEntityVisible = SetEntityVisible
local SetEntityRotation = SetEntityRotation
local PlaceObjectOnGroundProperly = PlaceObjectOnGroundProperly
local SetModelAsNoLongerNeeded = SetModelAsNoLongerNeeded
local SetEntityAsNoLongerNeeded = SetEntityAsNoLongerNeeded
local SetPtfxAssetNextCall = SetPtfxAssetNextCall
local StartNetworkedParticleFxLoopedOnEntity = StartNetworkedParticleFxLoopedOnEntity
local TaskPlayAnim = TaskPlayAnim
local ClearPedTasks = ClearPedTasks
local RemoveAnimDict = RemoveAnimDict
local StopParticleFxLooped = StopParticleFxLooped
local RemovePtfxAsset = RemovePtfxAsset

local GetGameTimer = GetGameTimer
local DisableControlAction = DisableControlAction
local HasAnimEventFired = HasAnimEventFired
local IsEntityVisible = IsEntityVisible

local GetAnimInitialOffsetPosition = GetAnimInitialOffsetPosition
local NetworkCreateSynchronisedScene = NetworkCreateSynchronisedScene
local NetworkAddPedToSynchronisedScene = NetworkAddPedToSynchronisedScene
local NetworkAddEntityToSynchronisedScene = NetworkAddEntityToSynchronisedScene
local NetworkStartSynchronisedScene = NetworkStartSynchronisedScene
local NetworkStopSynchronisedScene = NetworkStopSynchronisedScene

local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity

function Fle:Start()
    self:ExportAllZones()
    self:RegisterEvents()

    local data = {}
    for k,v in pairs(self.Trolley) do
        table.insert(data, joaat(v.trolley))
    end

    if GetConvar("plouffe_fleeca:qtarget", "") == "true" then
        if GetResourceState("qtarget") ~= "missing" then
            local breakCount = 0
            while GetResourceState("qtarget") ~= "started" and breakCount < 30 do
                breakCount += 1
                Wait(1000)
            end

            if GetResourceState("qtarget") ~= "started" then
                return
            end

            exports.qtarget:AddTargetModel(data,{
                distance = 1.5,
                options = {
                    {
                        icon = 'fas fa-info',
                        label = Lang.bank_tryLoot,
                        action = Fle.TryLoot
                    },
                    {
                        icon = 'fas fa-viruses',
                        label = Lang.bank_tryDestroy,
                        action = Fle.TryDestroyLoot
                    }
                }
            })
        end
    end
end

function Fle:ExportAllZones()
    for k,v in pairs(self.Banks) do
        for x,y in pairs(v.coords) do
            y.name = ("%s_%s"):format(k,x)
            local registered, reason = exports.plouffe_lib:Register(y)
        end
    end
end

function Fle:RegisterEvents()
    AddEventHandler("plouffe_fleeca:inFleeca", function(params)
        self.Utils.currentFleeca = params
    end)

    AddEventHandler("plouffe_fleeca:exitFleeca", function(params)
        self.Utils.currentFleeca = nil
    end)

    AddEventHandler("trolley:TryLoot", Fle.TryLoot)
    AddEventHandler("trolley:destroy", Fle.TryDestroyLoot)

    Utils:RegisterNetEvent("plouffe_fleeca:tryHack", Fle.TryThermal)
    Utils:RegisterNetEvent("plouffe_fleeca:tryThermal", Fle.TryHack)
end

function Fle:HackAnimation()
    local dict = "anim@heists@ornate_bank@hack"
    local animLoaded = Utils:AssureAnim(dict, true)

    local ped = PlayerPedId()
    local pedRotation = GetEntityRotation(ped)
    local pedCoords = GetEntityCoords(ped)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.1)

    local animPos = GetAnimInitialOffsetPosition(dict, "hack_enter", offset.x, offset.y, offset.z, pedRotation.x, pedRotation.y, pedRotation.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(dict, "hack_loop", offset.x, offset.y, offset.z, pedRotation.x, pedRotation.y, pedRotation.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(dict, "hack_exit", offset.x, offset.y, offset.z, pedRotation.x, pedRotation.y, pedRotation.z, 0, 2)

    -- FreezeEntityPosition(ped, true)

    local bagEntity =  Utils:CreateProp("hei_p_m_bag_var22_arm_s",  {x = offset.x, y = offset.y, z = offset.z - 5.0}, nil, true, true)
    local laptopEntity =  Utils:CreateProp("hei_prop_hst_laptop",  {x = offset.x, y = offset.y, z = offset.z - 8.0}, nil, true, true)
    local cardEntity =  Utils:CreateProp("hei_prop_heist_card_hack_02",  {x = offset.x, y = offset.y, z = offset.z - 12.0}, nil, true, true)

    SetEntityCollision(bagEntity, false, true)
    SetEntityCollision(laptopEntity, false, true)
    SetEntityCollision(cardEntity, false, true)

    local scene = NetworkCreateSynchronisedScene(animPos.x, animPos.y, animPos.z + 0.7, pedRotation.x, pedRotation.y, pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene, dict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagEntity, scene, dict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptopEntity, scene, dict, "hack_enter_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cardEntity, scene, dict, "hack_enter_card", 4.0, -8.0, 1)

    local scene2 = NetworkCreateSynchronisedScene(animPos2.x, animPos2.y, animPos2.z + 0.7, pedRotation.x, pedRotation.y, pedRotation.z, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene2, dict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagEntity, scene2, dict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptopEntity, scene2, dict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(cardEntity, scene2, dict, "hack_loop_card", 4.0, -8.0, 1)

    Wait(200)
    NetworkStartSynchronisedScene(scene)
    Wait(6300)
    NetworkStartSynchronisedScene(scene2)

    return function()
        local scene3 = NetworkCreateSynchronisedScene(animPos3.x, animPos3.y, animPos3.z + 0.7, pedRotation.x, pedRotation.y, pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene3, dict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bagEntity, scene3, dict, "hack_exit_bag", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(laptopEntity, scene3, dict, "hack_exit_laptop", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(cardEntity, scene3, dict, "hack_exit_card", 4.0, -8.0, 1)

        NetworkStartSynchronisedScene(scene3)
        Wait(4600)
        NetworkStopSynchronisedScene(scene3)

        RemoveAnimDict(dict)
        DeleteEntity(bagEntity)
        DeleteEntity(laptopEntity)
        DeleteEntity(cardEntity)
    end
end

function Fle:ThermalAnimation()
    local ped = PlayerPedId()
    local pedRotation = GetEntityRotation(ped)
    local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.4, 0.1)
    local boneIndex = GetPedBoneIndex(ped, 28422)
    local dict = "anim@heists@ornate_bank@thermal_charge"

    local fxLoaded = Utils:AssureFxAsset("scr_ornate_heist", true)
    local animLoaded = Utils:AssureAnim(dict, true)

    local bagEntity = Utils:CreateProp("hei_p_m_bag_var22_arm_s",{x = offset.x, y = offset.y, z = offset.z - 10.0}, nil, true, true)
    local bombEntity = Utils:CreateProp("hei_prop_heist_thermite",{x = offset.x, y = offset.y, z = offset.z - 12.0}, nil, true, true)

    SetEntityCollision(bagEntity, false, true)
    SetEntityCollision(bombEntity, false, true)
    local animScene = NetworkCreateSynchronisedScene(offset.x, offset.y, offset.z, pedRotation.x, pedRotation.y, pedRotation.z, 2, false, false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, animScene, dict, "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagEntity, animScene, dict, "bag_thermal_charge", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(animScene)

    -- SetPedComponentVariation(ped, 5, 0, 0, 0)
    Wait(1500)

    AttachEntityToEntity(bombEntity, ped, boneIndex, 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)

    Wait(4000)

    DeleteEntity(bagEntity)
    DetachEntity(bombEntity, 1, 1)
    FreezeEntityPosition(bombEntity, true)

    return function(succes)
        NetworkStopSynchronisedScene(animScene)

        if succes then
            SetPtfxAssetNextCall("scr_ornate_heist")
            local ptfx = StartNetworkedParticleFxLoopedOnEntity('scr_heist_ornate_thermal_burn', bombEntity, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false, 0)

            TaskPlayAnim(ped, dict, "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
            TaskPlayAnim(ped, dict, "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
            Wait(2000)
            ClearPedTasks(ped)
            Wait(3800)
            StopParticleFxLooped(ptfx, 0)
        end

        DeleteEntity(bombEntity)

        RemoveAnimDict(dict)
        RemovePtfxAsset("scr_ornate_heist")
    end
end

function Fle:GetTrolley(coords)
    local entity = nil

    for k,v in pairs(self.Trolley) do
        entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, v.trolley, false, false, false)
        if entity ~= 0 then
            return entity, v, k
        end
    end
end

function Fle.TryThermal()
    if not Fle.Utils.currentFleeca then
        return
    end

    for k,v in pairs(Fle.thermal_items) do
        if Utils:GetItemCount(k) < v then
            return
        end
    end

    local zone = Fle.Utils.currentFleeca.zone

    if not exports.plouffe_lib:IsInZone(("%s_%s"):format(zone, "vault_gate_1")) then
        return
    end

    local finished = Fle:ThermalAnimation()

    local succes = Interface.MemorySquares.New({
        time = 10,
        amount = 4,
        solutionAmount = 5,
        errors = 0,
        delay = 2
    })

    finished(succes)
    TriggerServerEvent("plouffe_fleeca:finished_thermal", zone, succes, Fle.Utils.MyAuthKey)
end
exports("TryThermal", Fle.TryThermal)

function Fle.TryHack()
    if not Fle.Utils.currentFleeca then
        return
    end

    for k,v in pairs(Fle.hack_items) do
        if Utils:GetItemCount(k) < v then
            return
        end
    end

    local zone = Fle.Utils.currentFleeca.zone

    if not exports.plouffe_lib:IsInZone(("%s_%s"):format(zone, "hacking")) then
        return
    end

    local canRob, reason = Callback:Sync("plouffe_fleeca:canRob", zone, Fle.Utils.MyAuthKey)

    if not canRob then
        return Interface.Notifications.Show({
            style = "error",
            header = "Fleeca bank",
            message = reason
        })
    end

    if GetResourceState("plouffe_dispatch") == "started" then
        exports.plouffe_dispatch:SendAlert("10-90 C")
    end

    local finish = Fle:HackAnimation()
    local succes = Interface.MovingSquare.New({
        time = 20,
        amount = 6,
        errors = 0,
        delay = 6
    })

    finish()

    if not succes then
        return TriggerServerEvent("plouffe_fleeca:hacking_failed", Fle.Utils.MyAuthKey)
    end

    local waitTimer = math.random(1000 * 60 * 6, 1000 * 60 * 10)

    TriggerServerEvent("plouffe_fleeca:hacking_finished", zone, waitTimer,  Fle.Utils.MyAuthKey)

    CreateThread(function()
        local timeout = 1000
        local times = 0

        Interface.Notifications.Show({
            message = Lang.bank_timeUntilDoorOpens:format(math.ceil(waitTimer / 1000 / 60))
        })

        while Fle.Utils.currentFleeca and waitTimer > 0 do
            waitTimer = waitTimer - timeout
            times = times + 1

            if times == 60 then
                times = 0
                Interface.Notifications.Show({
                    message = Lang.bank_timeUntilDoorOpens:format(math.ceil(waitTimer / 1000 / 60))
                })
            end

            Wait(timeout)
        end

        if not Fle.Utils.currentFleeca then
            return
        end

        exports.plouffe_doorlock:OpenAutomated(("%s_%s"):format(zone, "vault"))
    end)
end
exports("TryHack",Fle.TryHack)

function Fle.TryDestroyLoot()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local trolleyEntity, data, key = Fle:GetTrolley(pedCoords)

    if not trolleyEntity then
        return
    end

    TriggerServerEvent("plouffe_fleeca:TryDestroyLoots", NetworkGetNetworkIdFromEntity(trolleyEntity), Fle.Utils.currentFleeca.zone, Fle.Utils.MyAuthKey)
end
exports("TryDestroyLoot",Fle.TryDestroyLoot)

function Fle.TryLoot()
    if not Fle.Utils.currentFleeca then
        return
    end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local trolleyEntity, data, key = Fle:GetTrolley(pedCoords)

    if not trolleyEntity then
        return
    end

    local trolleyRotation = GetEntityRotation(trolleyEntity)
    local trolleyCoords = GetEntityCoords(trolleyEntity)
    local boneIndex = GetPedBoneIndex(ped, 60309)

    local emptyTrolley = Utils:CreateProp(data.empty,{x = trolleyCoords.x, y = trolleyCoords.y, z = trolleyCoords.z - 12.0}, nil, true, true)

    SetEntityRotation(emptyTrolley, trolleyRotation.x, trolleyRotation.y, trolleyRotation.z)
    FreezeEntityPosition(emptyTrolley, true)

    local lootEntity = Utils:CreateProp(data.prop,{x = trolleyCoords.x, y = trolleyCoords.y, z = trolleyCoords.z - 10.0}, nil, true, true)

    FreezeEntityPosition(lootEntity, true)
    SetEntityNoCollisionEntity(lootEntity, ped)
    SetEntityVisible(lootEntity, false, false)
    AttachEntityToEntity(lootEntity, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

    local emptyModelLoaded = Utils:AssureModel(data.empty, true)
    local hasEntityControl = Utils:AssureEntityControl(trolleyEntity)
    local animLoaded = Utils:AssureAnim("anim@heists@ornate_bank@grab_cash", true)

    local bagEntity = Utils:CreateProp("hei_p_m_bag_var22_arm_s",{x = pedCoords.x, y = pedCoords.y, z = pedCoords.z - 10.0}, nil, true, true)

    local scene = NetworkCreateSynchronisedScene(trolleyCoords.x, trolleyCoords.y, trolleyCoords.z, trolleyRotation.x, trolleyRotation.y, trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagEntity, scene, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local scene2 = NetworkCreateSynchronisedScene(trolleyCoords.x, trolleyCoords.y, trolleyCoords.z, trolleyRotation.x, trolleyRotation.y, trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bagEntity, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(trolleyEntity, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
        NetworkStartSynchronisedScene(scene2)
    end)

    Fle:HandleLootEvents(ped, lootEntity)

    local scene3 = NetworkCreateSynchronisedScene(trolleyCoords.x, trolleyCoords.y, trolleyCoords.z, trolleyRotation.x, trolleyRotation.y, trolleyRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bagEntity, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)

    TriggerServerEvent("plouffe_fleeca:requestLoots", NetworkGetNetworkIdFromEntity(trolleyEntity), Fle.Utils.currentFleeca.zone, Fle.Utils.MyAuthKey)
    local init = GetGameTimer()

    while DoesEntityExist(trolleyEntity) and GetGameTimer() - init < 5000 do
        Wait(0)
    end

    if DoesEntityExist(trolleyEntity) then
        DeleteEntity(emptyTrolley)
    else
        DeleteEntity(trolleyEntity)
        SetEntityCoords(emptyTrolley, trolleyCoords.x, trolleyCoords.y, trolleyCoords.z)
        PlaceObjectOnGroundProperly(emptyTrolley)
        SetEntityAsNoLongerNeeded(emptyTrolley)
    end

    Wait(1800)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(data.empty)
    DeleteEntity(bagEntity)
end
exports("TryLoot",Fle.TryLoot)

function Fle:HandleLootEvents(ped, entity)
    local init = GetGameTimer()
    local timeout = 37 * 1000
    local cash_appear = joaat("CASH_APPEAR")
    local cash_destroyed = joaat("RELEASE_CASH_DESTROY")

    self.looting = true

    while GetGameTimer() - init < timeout and self.looting do
        Wait(0)

        DisableControlAction(0, 73, true)
        if HasAnimEventFired(ped, cash_appear) then
            if not IsEntityVisible(entity) then
                SetEntityVisible(entity, true, false)
            end
        end
        if HasAnimEventFired(ped, cash_destroyed) then
            if IsEntityVisible(entity) then
                SetEntityVisible(entity, false, false)
            end
        end
    end

    self.looting = false
    DeleteEntity(entity)
end

RegisterCommand('hackk', Fle.TryHack)
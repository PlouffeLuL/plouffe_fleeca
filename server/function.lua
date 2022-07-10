local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId
local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity
local SetResourceKvpInt = SetResourceKvpInt
local GetResourceKvpInt = GetResourceKvpInt
local CreateObject = CreateObject
local DeleteEntity = DeleteEntity
local DoesEntityExist = DoesEntityExist
local SetEntityRotation = SetEntityRotation
local Wait = Wait

local robIntervall = 60 * 60 * 1
local lastRob = 0

function Fle.Init()
    for k,v in pairs(Fle.Banks) do
        v.lastRob = GetResourceKvpInt(("lastrob_%s"):format(k)) or 0
        v.currentMoney = GetResourceKvpInt(("currentMoney_%s"):format(k)) or 0
    end

    Server.ready = true

    local sleepTimer = 1000 * 60 * 15

    while true do
        for k,v in pairs(Fle.Banks) do
            v.currentMoney = Fle:AddBankMoney(k,v)
        end 
        Wait(sleepTimer)
    end
end

function Fle:GetData()
    local retval = {}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

function Fle:AddBankMoney(index,data)
    local addition = math.random(2000, 5000)
    local newMoney = data.currentMoney + addition < data.maxMoney and data.currentMoney + addition or data.maxMoney
    SetResourceKvpInt(("currentMoney_%s"):format(index), newMoney)
    return newMoney
end

function Fle:FinishedThermal(playerId, zone, succes)
    exports.ox_inventory:RemoveItem(playerId, "thermal_charge", 1)

    if succes then
        local index = ("%s_vault_gate"):format(zone)
        exports.plouffe_doorlock:UpdateDoorState(index,false)
    end
end

function Fle:RequestLoots(playerId, netId, index)
    local data = self.Banks[index].trolleySpawns
    for k,v in pairs(data) do
        if v.netId and v.netId == netId then
            if exports.ox_inventory:CanCarryItem(playerId, "money_bag", 1, {weight = math.ceil(0.1 * v.value), description = ("Contiens pour %s $ de billets marquer"):format(v.value), value = v.value}) then
                local entity = NetworkGetEntityFromNetworkId(v.netId)
                DeleteEntity(entity)
                v.netId = nil
                
                self.Banks[index].currentMoney = math.ceil(self.Banks[index].currentMoney - v.value)
                SetResourceKvpInt(("currentMoney_%s"):format(index), self.Banks[index].currentMoney)

                exports.ox_inventory:AddItem(playerId, "money_bag", 1, {weight = math.ceil(0.1 * v.value), description = ("Contiens pour %s $ de billets marquer"):format(v.value), value = v.value})
                break
            else
                TriggerClientEvent("plouffe_lib:notify", playerId, {type = "inform", txt = ("Vous ne pouvez pas porter ce sac d'argent"), length = 5000})
                break
            end
        end
    end
end

function Fle:DestroyLoots(playerId, netId, index)
    local data = self.Banks[index].trolleySpawns

    for k,v in pairs(data) do
        if v.netId and v.netId == netId then
            local entity = NetworkGetEntityFromNetworkId(v.netId)
            DeleteEntity(entity)
            v.netId = nil
        end
    end
end

function Fle:CreateTrolley(index)
    local bank = self.Banks[index]
    local data = bank.trolleySpawns
    local model = joaat(self.Trolley.cash.trolley)
    local value = math.ceil(bank.currentMoney / Utils:TableLen(data))

    for k,v in pairs(data) do
        local randi = math.random(0,1)
        local create = false
        
        if v.isExtra and randi == 1 then
            create = true
        elseif not v.isExtra then
            create = true
        end

        if create then
            local entity = CreateObject(model, v.coords.x, v.coords.y, v.coords.z, true, true, false)
            local init = os.time()

            while not DoesEntityExist(entity) and os.time() - init < 2 do
                Wait(0)
            end

            if DoesEntityExist(entity) then
                local netId = NetworkGetNetworkIdFromEntity(entity) 
                
                SetEntityRotation(entity, v.rotation.x, v.rotation.y, v.rotation.z, 2, true)
                -- Entity(netId).state:Set("bankEntity", true, true)
                v.value = value
                v.netId = netId
            end
        end
    end
end

function Fle:StartRobbery(playerId,index,waitTimer)
    local time = os.time()
    local canRob, reason = self:CanRob(index)

    if not canRob then
        return
    end

    local reduced, reason = Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 48)

    if not reduced then
        return
    end

    local count = exports.ox_inventory:Search(playerId, "count", "card_fleeca")

    if count < 1 then
        return
    end

    exports.ox_inventory:RemoveItem(playerId, "card_fleeca", 1)

    lastRob = time
    self.Banks[index].lastRob = time

    SetResourceKvpInt(("lastrob_%s"):format(index), time)

    self:CreateTrolley(index)
end

function Fle:CanRob(index)
    local time = os.time()
    
    if time - lastRob < robIntervall then
        return false, ("Une banque a déjà été braquer dernièrement")
    end

    if time - self.Banks[index].lastRob < 60 * 60 * 12 then
        return false, ("Cette banque a déjà été voler dernierement")
    end

    local cops = exports.plouffe_society:GetPlayersPerJob("police")

    if not cops or Utils:TableLen(cops) < 4 then
        return false, ("Il n'y a pas asser de policier en service présentement")
    end

    return true
end

Callback:RegisterServerCallback("plouffe_fleeca:canRob", function(source, cb, index, authkey)
    local _source = source
    if Auth:Validate(_source,authkey) and Auth:Events(_source,"plouffe_fleeca:canRob") then
        cb(Fle:CanRob(index))
    else
        cb(false)
    end
end)
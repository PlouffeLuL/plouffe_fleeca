CreateThread(Fle.Init)

RegisterNetEvent("plouffe_fleeca:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local cbArray = Fle:GetData()
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_fleeca:getConfig", playerId, cbArray)
    else
        TriggerClientEvent("plouffe_fleeca:getConfig", playerId, nil)
    end
end)

RegisterNetEvent("plouffe_fleeca:hacking_finished",function(zone, waitTimer, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_fleeca:hacking_finished") then
        Fle:StartRobbery(playerId,zone,waitTimer)
    end
end)

RegisterNetEvent("plouffe_fleeca:hacking_failed",function(authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_fleeca:hacking_finished") then
        Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 24)
    end
end)

RegisterNetEvent("plouffe_fleeca:requestLoots",function(netId, zone, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_fleeca:requestLoots") then
        Fle:RequestLoots(playerId, netId, zone)
    end
end)

RegisterNetEvent("plouffe_fleeca:finished_thermal",function(zone, succes, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_fleeca:finished_thermal") then
        Fle:FinishedThermal(playerId, zone, succes)
    end
end)
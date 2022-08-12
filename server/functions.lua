local Auth = exports.plouffe_lib:Get("Auth")
local Utils = exports.plouffe_lib:Get("Utils")
local Callback = exports.plouffe_lib:Get("Callback")
local Groups = exports.plouffe_lib:Get("Groups")
local Inventory = exports.plouffe_lib:Get("Inventory")
local Lang = exports.plouffe_lib:Get("Lang")

local automatedDoors = {
    fleeca_vinewood_vault = {
		model = 2121050683,
		heading = {close = 249.86596679688, open = 160.0, modifier = -0.01},
		coords = vector3(313, -282, 55)
	},

	fleeca_square_vault = {
		model = 2121050683,
		heading = {close = 249.84596679688, open = 160.0, modifier = -0.01},
		coords = vector3(148, -1044, 29)
	},

	fleeca_centreville_vault = {
		model = 2121050683,
		heading = {close = 250.859, open = 160.0, modifier = -0.01},
		coords = vector3(-352.7,-53.5,49.17)
	},

	fleeca_vescpucci_vault = {
		model = 2121050683,
		heading = {close = 296.86596679688, open = 208.0, modifier = -0.01},
		coords = vector3(-1211,-334,37.9)
	},

	fleeca_beach_vault = {
		model = -63539571,
		heading = {close = 357.54, open = 267.0, modifier = -0.01},
		coords = vector3(-2958,482,15.8)
	},

	fleeca_sandy_vault = {
		model = 2121050683,
		heading = {close = 90.0, open = 1.0, modifier = -0.01},
		coords = vector3(1175, 2710, 38.2)
	}
}

local gateDoors = {
    fleeca_vinewood_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(313.92529296875, -285.71078491211, 54.143028259277), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(314.623871, -285.994476, 54.463009)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    },

	fleeca_square_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(149.47538757324, -1047.3817138672, 29.346324920654), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(150.291321, -1047.629028, 29.666298)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    },

	fleeca_centreville_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(-351.33309936523, -56.362380981445, 49.014827728271), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(-350.414368, -56.797054, 49.334797)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    },

	fleeca_vescpucci_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(-1208.0946044922, -335.42147827148, 37.759296417236), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(-1207.328247, -335.128937, 38.079254)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    },

	fleeca_beach_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(-2956.1752929688, 484.65213012695, 15.675336837769), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(-2956.116211, 485.420593, 15.995309)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    },

	fleeca_sandy_vault_gate = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(1173.1110839844, 2713.0883789063, 38.066291809082), maxDst = 0.8}
		},
		doors = {
			{model = -1591004109, coords = vec3(1172.291138, 2713.146240, 38.386253)}
		},
        access = {
			jobs = {
				police = {rankSpecific = 7}
			}
        }
    }
}

local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId
local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity
local SetResourceKvpInt = SetResourceKvpInt
local GetResourceKvpInt = GetResourceKvpInt
local CreateObject = CreateObject
local DeleteEntity = DeleteEntity
local DoesEntityExist = DoesEntityExist
local SetEntityRotation = SetEntityRotation
local Wait = Wait

local lastRob = 0

local ready = false

function Fle.Init()
    Fle.ValidateConfig()

    Utils:CreateDepencie("plouffe_doorlock", Fle.ExportsAllDoors)

    for k,v in pairs(Fle.Banks) do
        v.lastRob = GetResourceKvpInt(("lastrob_%s"):format(k)) or 0
        v.currentMoney = GetResourceKvpInt(("currentMoney_%s"):format(k)) or 0
    end

    ready = true

    while true do
        for k,v in pairs(Fle.Banks) do
            v.currentMoney = Fle:AddBankMoney(k,v)
        end

        Wait(Fle.addMoneyIntervall)
    end
end

function Fle.ValidateConfig()
    Fle.MoneyItem = GetConvar("plouffe_fleeca:money_item", "")
    Fle.MoneyMeta = GetConvar("plouffe_fleeca:use_money_metadata", "false")
    Fle.MinCops = tonumber(GetConvar("plouffe_fleeca:min_cops", ""))
    Fle.PoliceGroups = json.decode(GetConvar("plouffe_fleeca:police_groups", ""))
    Fle.robIntervall = (tonumber(GetConvar("plouffe_fleeca:global_rob_interval", ""))) * (60 * 1000 * 60)
    Fle.banksIntervall = (tonumber(GetConvar("plouffe_fleeca:banks_rob_interval", ""))) * (60 * 1000 * 60)
    Fle.addMoneyIntervall = (tonumber(GetConvar("plouffe_fleeca:add_money_interval", ""))) * (1000 * 60)
    Fle.minMoneyAddition = tonumber(GetConvar("plouffe_fleeca:min_money_addition", ""))
    Fle.maxMoneyAddition = tonumber(GetConvar("plouffe_fleeca:max_money_addition", ""))

    local data = json.decode(GetConvar("plouffe_fleeca:hack_item", ""))
    if data and type(data) == "table" then
        Fle.hack_items = {}

        for k,v in pairs(data) do
            local one, two = v:find(":")
            Fle.hack_items[v:sub(0,one - 1)] = tonumber(v:sub(one + 1,v:len()))
        end
        data = nil
    end

    data = json.decode(GetConvar("plouffe_fleeca:thermal_item", ""))
    if data and type(data) == "table" then
        Fle.thermal_items = {}

        for k,v in pairs(data) do
            local one, two = v:find(":")
            Fle.thermal_items[v:sub(0,one - 1)] = tonumber(v:sub(one + 1,v:len()))
        end
    end

    if not Fle.hack_items or type(Fle.hack_items) ~= "table" then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'hack_items' convar. Refer to documentation")
        end
    elseif not Fle.thermal_items or type(Fle.thermal_items) ~= "table" then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'thermal_items' convar. Refer to documentation")
        end
    elseif not Fle.MoneyItem or type(Fle.MoneyItem) ~= "string" or Fle.MoneyItem:len() < 1 then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'money_item' convar. Refer to documentation")
        end
    elseif not Fle.PoliceGroups or type(Fle.PoliceGroups) ~= "table" then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'police_groups' convar. Refer to documentation")
        end
    elseif not Fle.MinCops then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'min_cops' convar. Refer to documentation")
        end
    elseif not Fle.PoliceGroups then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'police_groups' convar. Refer to documentation")
        end
    elseif not Fle.robIntervall then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'robIntervall' convar. Refer to documentation")
        end
    elseif not Fle.banksIntervall then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'banks_rob_interval' convar. Refer to documentation")
        end
    elseif not Fle.addMoneyIntervall then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'add_money_interval' convar. Refer to documentation")
        end
    elseif not Fle.minMoneyAddition then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'min_money_addition' convar. Refer to documentation")
        end
    elseif not Fle.maxMoneyAddition then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'max_money_addition' convar. Refer to documentation")
        end
    end

    Fle.robIntervall = Fle.robIntervall * (60 * 1000 * 60)
    Fle.banksIntervall = Fle.banksIntervall * (60 * 1000 * 60)
    Fle.addMoneyIntervall = Fle.addMoneyIntervall * (1000 * 60)

    return true
end

function Fle.ExportsAllDoors()
    for k,v in pairs(automatedDoors) do
        exports.plouffe_doorlock:RegisterDoor(k,v,true)
    end

    for k,v in pairs(gateDoors) do
        exports.plouffe_doorlock:RegisterDoor(k,v, false)
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

function Fle.LoadPlayer()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    while not ready do
        Wait(100)
    end

    if registred then
        local cbArray = Fle:GetData()
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_fleeca:getConfig", playerId, cbArray)
    else
        TriggerClientEvent("plouffe_fleeca:getConfig", playerId, nil)
    end
end

function Fle:AddBankMoney(index,data)
    local addition = math.random(self.minMoneyAddition, self.maxMoneyAddition)
    local newMoney = data.currentMoney + addition < data.maxMoney and data.currentMoney + addition or data.maxMoney
    SetResourceKvpInt(("currentMoney_%s"):format(index), newMoney)
    return newMoney
end

function Fle.FinishedThermal(zone, succes, authkey)
    local playerId = source

    if not Auth:Validate(playerId,authkey) or not Auth:Events(playerId,"plouffe_fleeca:finished_thermal") then
        return
    end

    for k,v in pairs(Fle.thermal_items) do
        Inventory.RemoveItem(playerId, k, v)
    end

    if succes then
        local index = ("%s_vault_gate"):format(zone)
        exports.plouffe_doorlock:UpdateDoorState(index,false)
    end
end

function Fle.RequestLoots(netId, index, authkey)
    local playerId = source

    if not Auth:Validate(playerId,authkey) or not Auth:Events(playerId,"plouffe_fleeca:requestLoots") then
        return
    end

    local data = Fle.Banks[index].trolleySpawns
    for k,v in pairs(data) do
        if v.netId and v.netId == netId then
            local canCarry = (Fle.MoneyMeta == "false" and Inventory.CanCarryItem(playerId, Fle.MoneyItem, v.value)) or (Fle.MoneyMeta == "true" and Inventory.CanCarryItem(playerId, Fle.MoneyItem, 1, {weight = math.ceil(0.1 * v.value), description = Lang.bank_moneyItemMeta:format(v.value), value = v.value}))

            if canCarry then
                local entity = NetworkGetEntityFromNetworkId(v.netId)
                DeleteEntity(entity)
                v.netId = nil

                Fle.Banks[index].currentMoney = math.ceil(Fle.Banks[index].currentMoney - v.value)
                SetResourceKvpInt(("currentMoney_%s"):format(index), Fle.Banks[index].currentMoney)

                if Fle.MoneyMeta == "true" then
                    Inventory.AddItem(playerId, Fle.MoneyItem, 1, {weight = math.ceil(0.1 * v.value), description = Lang.bank_moneyItemMeta:format(v.value), value = v.value})
                else
                    Inventory.AddItem(playerId, Fle.MoneyItem, v.value)
                end

                break
            else
                TriggerClientEvent("plouffe_lib:notify", playerId, {type = "inform", txt = Lang.bank_cantCarryMoney, length = 5000})
                break
            end
        end
    end
end

function Fle.DestroyLoots(netId, index, authkey)
    local playerId = source

    if not Auth:Validate(playerId,authkey) or not Auth:Events(playerId,"plouffe_fleeca:destroyLoots") then
        return
    end

    local data = Fle.Banks[index].trolleySpawns

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

function Fle.StartRobbery(index, waitTimer, authkey)
    local playerId = source

    if not Auth:Validate(playerId,authkey) or not Auth:Events(playerId,"plouffe_fleeca:hacking_finished") then
        return
    end

    local time = os.time()
    local canRob, reason = Fle:CanRob(index)

    if not canRob then
        return
    end

    for k,v in pairs(Fle.hack_items) do
        local reduced, reason = Inventory.ReduceDurability(playerId, k, 60 * 60 * 48)

        if not reduced then
            return
        end
    end

    for k,v in pairs(Fle.hack_items) do
        local count = Inventory.Search(playerId, "count", k)

        if count < v then
            return
        end
    end

    for k,v in pairs(Fle.hack_items) do
        Inventory.RemoveItem(playerId, v, v)
    end

    lastRob = time
    Fle.Banks[index].lastRob = time

    SetResourceKvpInt(("lastrob_%s"):format(index), time)

    Fle:CreateTrolley(index)
end

function Fle:CanRob(index)
    local time = os.time()

    if time - lastRob < self.robIntervall then
        return false, Lang.bank_robbedLately
    end

    if time - self.Banks[index].lastRob < self.banksIntervall then
        return false, Lang.bank_thisBankIsRobbed
    end

    for k,v in pairs(Fle.PoliceGroups) do
        local cops = Groups:GetGroupPlayers(v)

        if cops.len < Fle.MinCops then
            return false, Lang.bank_notEnoughCop
        end
    end

    return true
end

function Fle.HackingFailed(authkey)
    local playerId = source

    if not Auth:Validate(playerId,authkey) or not Auth:Events(playerId,"plouffe_fleeca:hacking_finished") then
        return
    end

    for k,v in pairs(Fle.hack_items) do
        local reduced, reason = Inventory.ReduceDurability(playerId, k, 60 * 60 * 24)
    end
end

Callback:RegisterServerCallback("plouffe_fleeca:canRob", function(source, cb, index, authkey)
    local _source = source
    if Auth:Validate(_source,authkey) and Auth:Events(_source,"plouffe_fleeca:canRob") then
        cb(Fle:CanRob(index))
    else
        cb(false)
    end
end)

CreateThread(Fle.Init)
Fle = {}
TriggerServerEvent("plouffe_fleeca:sendConfig")
local cookie
cookie = RegisterNetEvent("plouffe_fleeca:getConfig",function(data)
	if not data then
		while true do
			Fle = nil
		end
	else
		for k,v in pairs(data) do
			Fle[k] = v
		end

		Fle:Start()
	end

	RemoveEventHandler(cookie)
end)
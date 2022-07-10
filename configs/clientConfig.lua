Fle = {}
TriggerServerEvent("plouffe_fleeca:sendConfig")

RegisterNetEvent("plouffe_fleeca:getConfig",function(list)
	if not list then
		while true do
			Fle = nil
		end
	else
		for k,v in pairs(list) do
			Fle[k] = v
		end

		Fle:Start()
	end
end)
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("cmt_sperrzone:new")
AddEventHandler("cmt_sperrzone:new", function()
    zone = {}
    local player = source
    local ped = GetPlayerPed(player)
    zone.location = GetEntityCoords(ped)
    zone.label = "Sperrzone"
    zone.colour = 0
    zone.blip = 137
    TriggerClientEvent("cmt_sperrzone:create", -1, zone)
end)

RegisterServerEvent("cmt_sperrzone:removeall")
AddEventHandler("cmt_sperrzone:removeall", function()
    TriggerClientEvent("cmt_sperrzone:removeall", -1)
end)

RegisterServerEvent("cmt_sperrzone:remove")
AddEventHandler("cmt_sperrzone:remove", function(location)
	TriggerClientEvent("cmt_sperrzone:remove", -1, location) 
end)

ESX.RegisterServerCallback('cmt_sperrzone:getMylocation', function(source, cb)
    cb(GetEntityCoords(GetPlayerPed(source)))
end)

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local zones = {}

RegisterNetEvent('cmt_sperrzone:create')
AddEventHandler('cmt_sperrzone:create', function(zone)
    local sperrzone = {}
    local blip = AddBlipForCoord(zone.location)
    SetBlipSprite(blip, zone.blip)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, zone.colour)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(zone.label)
    EndTextCommandSetBlipName(blip)

    local radiusBlip = AddBlipForRadius(zone.location, 100.0)
    SetBlipAlpha(radiusBlip, 80)
    SetBlipColour(radiusBlip, 38)

    sperrzone.location = zone.location
    sperrzone.blip = blip
    sperrzone.radiusBlip = radiusBlip
    table.insert(zones, sperrzone)
    local streetHash, crossingRoadHash = GetStreetNameAtCoord(zone.location.x, zone.location.y, zone.location.z)
    streetName = GetStreetNameFromHashKey(streetHash)
    crossingRoad = GetStreetNameFromHashKey(crossingRoadHash)
    if crossingRoad == nil or crossingRoad == "" then
        TriggerEvent('cmt_announce:sendNotify', "LSPD | Sperrzone (" .. streetName .. ")","Das LSPD bittet den abgesperrten Bereich zu räumen.<br>Es ist dem LSPD erlaubt auf unbefugte Personen zu schießen!", 20000, 'warning')
    else
        TriggerEvent('cmt_announce:sendNotify', "LSPD | Sperrzone (" .. streetName .. " / " .. crossingRoad .. ")","Das LSPD bittet den abgesperrten Bereich zu räumen.<br>Es ist dem LSPD erlaubt auf unbefugte Personen zu schießen!", 20000, 'warning')
    end
end)

RegisterNetEvent('cmt_sperrzone:removeall')
AddEventHandler('cmt_sperrzone:removeall', function(zone)
    for i=1, #zones, 1 do
        RemoveBlip(zones[i].blip)
        RemoveBlip(zones[i].radiusBlip)
    end
    zones = {}
end)

RegisterNetEvent('cmt_sperrzone:remove')
AddEventHandler('cmt_sperrzone:remove', function(location)
    for i=1, #zones, 1 do
        if #(location.xy - zones[i].location.xy) < 5 then
            RemoveBlip(zones[i].blip)
            RemoveBlip(zones[i].radiusBlip)
            table.remove(zones, i)
        end
    end
    local streetHash, crossingRoadHash = GetStreetNameAtCoord(location.x, location.y, location.z)
    streetName = GetStreetNameFromHashKey(streetHash)
    crossingRoad = GetStreetNameFromHashKey(crossingRoadHash)
    if crossingRoad == nil or crossingRoad == "" then
        TriggerEvent('cmt_announce:sendNotify', "LSPD | Sperrzone", "Sperrzone " .. streetName .. " wurde aufgelöst!", 20000, 'success')
    else
        TriggerEvent('cmt_announce:sendNotify', "LSPD | Sperrzone", "Sperrzone " .. streetName .. " / " .. crossingRoad .. " wurde aufgelöst!", 20000, 'success')
    end
end)

RegisterNetEvent('cmt_sperrzone:removeclosest')
AddEventHandler('cmt_sperrzone:removeclosest', function()
    ESX.TriggerServerCallback('cmt_sperrzone:getMylocation', function(location)
        local closest = nil
        if #zones > 0 then
            for i=1, #zones, 1 do
                if closest == nil and #(location.xy - zones[i].location.xy) < 150 then
                    closest = i
                end
                if closest then
                    if #(location.xy - zones[i].location.xy) < #(location.xy - zones[closest].location.xy) then
                        closest = i
                    end
                end
            end
            if closest then
                TriggerServerEvent("cmt_sperrzone:remove", zones[closest].location)
            end
        end
    end)
end)

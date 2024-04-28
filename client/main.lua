QBCore = exports["qb-core"]:GetCoreObject()

local PlayerData = {}
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

function DrawTextAbovePed(ped, text, xOffset, yOffset, font, scale, color)
    local offset = GetOffsetFromEntityInWorldCoords(ped, xOffset or 0.0, yOffset or 0.0, 1.0)
    local x, y, z = table.unpack(offset)
    local font = font or 0
    local scale = scale or 0.35
    local color = color or {255, 255, 255, 215}

    SetTextScale(scale, scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(color[1] or 255, color[2] or 255, color[3] or 255, color[4] or 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

CreateThread(function()
    while true do
        local sleep = 2000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k, v in pairs(Config.Depolar) do
            for _, y in pairs(v.Stash) do
                local distance = #(coords - vector3(y.coords.x, y.coords.y, y.coords.z))
                if distance <= 6.0 then
                    sleep = 1
                    text = y.text
                    if distance <= 1.5 then
                        text = "[E] " .. text
                        if IsControlJustPressed(0, 46) then
                            OpenStash(_, v) --
                        end
                    end
                    DrawTextAbovePed(ped, text, nil, nil, 8, 0.35, {255, 255, 255, 215})
                    DrawMarker(20, y.coords.x, y.coords.y, y.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.5, 0.15, 255, 0, 0, 91, false, false, false, 1, false, false, false)
                end
            end 
        end
        Wait(sleep)
    end
end)

OpenStash = function(k, v)
    local jobName = QBCore.Functions.GetPlayerData().job.name
    if v.jobs and IsJobAllowed(jobName, v.jobs) then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", "STDEPO"..QBCore.Functions.GetPlayerData().citizenid, {maxweight = 1000000,slots = 50,})
        TriggerEvent("inventory:client:SetCurrentStash", "STDEPO"..QBCore.Functions.GetPlayerData().citizenid)
    else
        QBCore.Functions.Notify("Mesleğe sahip değilsin depo erişilmez", "error")
    end
end

function IsJobAllowed(job, allowedJobs)
    for _, allowedJob in ipairs(allowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end
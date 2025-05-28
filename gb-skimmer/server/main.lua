local QBCore = exports['qb-core']:GetCoreObject()
local lastSkimmerPurchase = {}

RegisterServerEvent("skimmer:removeItem", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem("skimmer", 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["skimmer"], "remove")
    end
end)

RegisterServerEvent("skimmer:attemptPurchase", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local now = GetGameTimer()
    if lastSkimmerPurchase[src] and now - lastSkimmerPurchase[src] < Config.SkimmerPurchaseCooldown then
        TriggerClientEvent("QBCore:Notify", src, "You need to wait before buying another skimmer.", "error")
        return
    end

    if Player.Functions.RemoveMoney("cash", Config.SkimmerPrice, "buy-skimmer") then
        Player.Functions.AddItem("skimmer", 1)
        lastSkimmerPurchase[src] = now
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["skimmer"], "add")
        TriggerClientEvent("QBCore:Notify", src, "You bought a skimmer.", "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Not enough cash.", "error")
    end
end)

RegisterServerEvent("skimmer:claim", function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local reward = math.random(Config.Reward.min, Config.Reward.max)
    Player.Functions.AddItem("markedbills", 1, false, { worth = reward })
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["markedbills"], "add")
    TriggerClientEvent("QBCore:Notify", src, "You pulled the skimmer and got marked bills.", "success")

    if math.random(1, 100) <= Config.PoliceAlertChance then
        for _, id in ipairs(QBCore.Functions.GetPlayers()) do
            local cop = QBCore.Functions.GetPlayer(id)
            if cop and cop.PlayerData.job and Config.PoliceJobs[cop.PlayerData.job.name] then
                TriggerClientEvent("police:client:policeAlert", id, {
                    title = "Suspicious Activity",
                    coords = coords,
                    description = "Possible ATM tampering reported.",
                    icon = "fas fa-user-secret"
                })
            end
        end
    end
end)

CreateThread(function()
    local jobMap = {}
    for _, job in pairs(Config.PoliceJobs) do
        jobMap[job] = true
    end
    Config.PoliceJobs = jobMap
end)

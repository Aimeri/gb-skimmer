local QBCore = exports['qb-core']:GetCoreObject()
local placedSkimmers = {}
local cooldowns = {
    placing = false,
    retrieving = false
}
local skimmerTimerActive = false

CreateThread(function()
    if Config.NPCShop then

        local model = Config.Npc.model
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local coords = Config.Npc.coords
        local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    label = 'Buy Skimmer ($2500)',
                    icon = 'fas fa-credit-card',
                    action = function()
                        TriggerEvent("skimmer:buyMenu")
                    end
                }
            },
            distance = 2.5
        })
    end
end)

exports['qb-target']:AddTargetModel({
    `prop_atm_01`, `prop_atm_02`, `prop_atm_03`
}, {
    options = {
        {
            label = "Place Skimmer",
            icon = "fas fa-wrench",
            item = "skimmer",
            canInteract = function(entity)
                local pos = GetEntityCoords(entity)
                local key = getKey(pos)
                return not placedSkimmers[key]
            end,
            action = function(entity)
                if cooldowns.placing then
                    QBCore.Functions.Notify("You're doing that too fast.", "error")
                    return
                end
                cooldowns.placing = true
                local pos = GetEntityCoords(entity)
                local key = getKey(pos)
                TriggerEvent("skimmer:placeSkimmer", entity, pos, key)
                SetTimeout(3000, function()
                    cooldowns.placing = false
                end)
            end
        },
        {
            label = "Retrieve Skimmer",
            icon = "fas fa-hand-holding-usd",
            canInteract = function(entity)
                local pos = GetEntityCoords(entity)
                local key = getKey(pos)
                return placedSkimmers[key] ~= nil
            end,
            action = function(entity)
                if cooldowns.retrieving then
                    QBCore.Functions.Notify("You're doing that too fast.", "error")
                    return
                end
                cooldowns.retrieving = true
                local pos = GetEntityCoords(entity)
                local key = getKey(pos)
                TriggerEvent("skimmer:pickupSkimmer", entity, key)
                SetTimeout(3000, function()
                    cooldowns.retrieving = false
                end)
            end
        }
    },
    distance = 1.5
})

RegisterNetEvent("skimmer:buyMenu", function()
    exports['qb-menu']:openMenu({
        {
            header = "Buy Skimmer",
            txt = "$2500",
            icon = "fas fa-credit-card"
        },
        {
            header = "Purchase",
            txt = "Buy a skimmer device",
            icon = "fas fa-money-check",
            params = {
                event = "skimmer:buy"
            }
        },
        {
            header = "Cancel",
            icon = "fas fa-times",
            params = { event = "" }
        }
    })
end)

RegisterNetEvent("skimmer:buy", function()
    TriggerServerEvent("skimmer:attemptPurchase")
end)

RegisterNetEvent("skimmer:placeSkimmer", function(entity, pos, key)
    QBCore.Functions.Progressbar("placing_skimmer", "Placing Skimmer...", 5000, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 1
    }, {}, {}, function()
        TriggerServerEvent("skimmer:removeItem")
        placedSkimmers[key] = { time = GetGameTimer() }
        QBCore.Functions.Notify("Skimmer placed! Wait "..(Config.SkimmerUseTime / 60000).." minutes.", "success")
    end)
end)

RegisterNetEvent("skimmer:pickupSkimmer", function(entity, key)
    local elapsed = GetGameTimer() - (placedSkimmers[key] and placedSkimmers[key].time or 0)
    if elapsed < Config.SkimmerUseTime then
        QBCore.Functions.Notify("Skimmer not ready yet.", "error")
        return
    end
    QBCore.Functions.Progressbar("pickup_skimmer", "Retrieving Skimmer...", 5000, false, true, {
        disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 49
    }, {}, {}, function()
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("skimmer:claim", coords)
        placedSkimmers[key] = nil
    end)
end)

function getKey(pos)
    return string.format("%d_%d_%d", math.floor(pos.x), math.floor(pos.y), math.floor(pos.z))
end

CreateThread(function()
    while true do
        Wait(1000)

        local foundSkimmer = false

        for key, skimmer in pairs(placedSkimmers) do
            local elapsed = GetGameTimer() - skimmer.time
            local remaining = Config.SkimmerUseTime - elapsed

            if remaining > 0 then
                foundSkimmer = true
                local secondsLeft = math.floor(remaining / 1000)

                SendNUIMessage({
                    type = "skimmerTimer",
                    show = true,
                    time = secondsLeft
                })
            else
                placedSkimmers[key] = nil
            end
        end

        if not foundSkimmer and skimmerTimerActive then
            SendNUIMessage({
                type = "skimmerTimer",
                show = false
            })
        end

        skimmerTimerActive = foundSkimmer
    end
end)

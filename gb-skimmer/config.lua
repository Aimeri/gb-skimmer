Config = {}

Config.NPCShop = true -- True if you want the built in shop to sell the skimmer with built in purchase cooldown.  False if you want to handle how the skimmer is distributed on your own.
Config.Npc = {
    model = 's_m_y_dealer_01',
    coords = vector4(489.1, -1521.77, 29.29, 133.15)
}

Config.SkimmerPrice = 2500
Config.SkimmerItem = 'skimmer'
Config.SkimmerUseTime = 20 * 60 * 1000
Config.SkimmerPurchaseCooldown = 45 * 60 * 1000

Config.RewardCurrency = 'black_money' -- markedbills if you want to be rewarded with markedbills with a worth assigned to them.  black_money if you want the reward to be black_money currency.
Config.Reward = {
    min = 5000,
    max = 15000
}

Config.PoliceJobs = {
    'police',
    'sheriff',
    'state'
}

Config.PoliceAlertChance = 100

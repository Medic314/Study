IT = {
    WeaponBasic = {func = function() return {0, 1} end, family = 'weapon', wfamily = 'basic', image = ST['Flame']},
    WeaponBasic2 = {func = function() return {0, 2} end, family = 'weapon', wfamily = 'basic', image = ST['Flame']},
    WeaponBasic3 = {func = function() return {0, 3} end, family = 'weapon', wfamily = 'basic', image = ST['Flame']},

    WeaponFlame = {func = function() return {0, 4} end, family = 'weapon', wfamily = 'basic', image = ST['Flame']},
    WeaponFlame2 = {func = function() return {0, 5} end, family = 'weapon', wfamily = 'basic', image = ST['Flame']},

    WeaponCharge = {func = function() return {1, 1} end, family = 'weapon', wfamily = 'charge', image = ST['Charge']},
    WeaponCharge2 = {func = function() return {1, 2} end, family = 'weapon', wfamily = 'charge', image = ST['Charge']},
    WeaponCharge3 = {func = function() return {1, 3} end, family = 'weapon', wfamily = 'charge', image = ST['Charge']},


    WeaponWater = {func = function() return {2, 1} end, family = 'weapon', wfamily = 'water', image = ST['Water']},
    WeaponWater2 = {func = function() return {2, 2} end, family = 'weapon', wfamily = 'water', image = ST['Water']},
    WeaponWater3 = {func = function() return {2, 3} end, family = 'weapon', wfamily = 'water', image = ST['Water']},
    WeaponWater4 = {func = function() return {2, 4} end, family = 'weapon', wfamily = 'water', image = ST['Water']},
    WeaponWater5 = {func = function() return {2, 5} end, family = 'weapon', wfamily = 'water', image = ST['Water']},

    WeaponLightning = {func = function() return {3, 1} end, family = 'weapon', wfamily = 'lightning', image = ST['Lightning']},
    WeaponLightning2 = {func = function() return {3, 2} end, family = 'weapon', wfamily = 'lightning', image = ST['Lightning']},
    WeaponLightning3 = {func = function() return {3, 3} end, family = 'weapon', wfamily = 'lightning', image = ST['Lightning']},


    WeaponPlant = {func = function() return {4, 1} end, family = 'weapon', wfamily = 'plant', image = ST['Plant']},
    WeaponPlant2 = {func = function() return {4, 2} end, family = 'weapon', wfamily = 'plant', image = ST['Plant']},
    WeaponPlant3 = {func = function() return {4, 3} end, family = 'weapon', wfamily = 'plant', image = ST['Plant']},
    WeaponWall = {func = function() return {4, 4} end, family = 'weapon', wfamily = 'plant', image = ST['Plant']},
    WeaponWall2 = {func = function() return {4, 5} end, family = 'weapon', wfamily = 'plant', image = ST['Plant']},

    DefaultTome = {func = function() return 'Default' end, family = 'tome', image = ST['DefaultTome']},



    itchytriggerfinger = {func = function() playerAttackspeed = playerAttackspeed + (basePlayerAttackspeed/5) end, family = 'item', image = ST['ItchyTriggerFinger']},
    sniperscope = {func = function() playerAccuracy = playerAccuracy + (basePlayerAccuracy/5) end, family = 'item', image = ST['SniperScope']},
    lardbucket = {func = function() playerBulletSize = playerBulletSize + (basePlayerBulletSize) end, family = 'item', image = ST['BucketOfLard']},
    samedaydelivery = {func = function() playerBulletSpeed = playerBulletSpeed + (basePlayerBulletSpeed/5) end, family = 'item', image = ST['SameDayDelivery']},
    sharpenedbullets = {func = function() playerDamage = playerDamage + (basePlayerDamage/5) end, family = 'item', image = ST['SharpenedBullets']},
    WeaponRoll = {"WeaponBasic2", "WeaponCharge2", "WeaponWater", "WeaponLightning", "WeaponPlant"},
    ItemRollQ1 = {"itchytriggerfinger", "sniperscope", "lardbucket", "samedaydelivery", "sharpenedbullets"},
    Q1Roll = {"WeaponBasic2", "WeaponCharge2", "WeaponWater", "WeaponLightning", "WeaponPlant", "itchytriggerfinger", "sniperscope", "lardbucket", "samedaydelivery", "sharpenedbullets"}
}
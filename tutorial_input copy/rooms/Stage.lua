Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    Debug_Functions = 1
    playerAttackspeed = 1
    playerAccuracy = 1
    playerBulletSpeed = 1.5
    playerBulletSize = 1
    playerDamage = 1
    playerCooldown = 1
    playerSpeed = 1
    playerScale = 1
    tomemenu = false
    

    activeitem = {func=function() print('no item') end}
    TomeBuffs = {Attackspeed = 1, Accuracy = 1, BulletSpeed = 1, BulletSize = 1, Damage = 1, Cooldown = 1, Speed = 1, scale = 1}
    current_upgrades = {0, 0, 0}

    basePlayerAttackspeed = 1
    basePlayerAccuracy = 1
    basePlayerBulletSpeed = 1.5
    basePlayerBulletSize = 1
    basePlayerDamage = 1
    basePlayerCooldown = 1
    basePlayerSpeed = 1
    basePlayerScale = 1
    movelock = false

    upgrade_points = 0

    LastDmg = 0
    lupgrade = 1
    rupgrade = 1
    lcycle = 0
    rcycle = 1
    lweapon = {family = 'basic'}
    rweapon = {family = 'charge'}

    tile = 25
    playerHP = 6
    playerMaxHP = 6

    camera:setFollowLerp(0.05)
    camera:setFollowLead(7.5) 
    camera:setFollowStyle('LOCKON')
    input:bind('8', 'one')
    input:bind('9', 'two')
    input:bind('0', 'three')
    
    input:bind('7', function() Debug_Vision = not Debug_Vision end)
    --input:bind('6', function() gotoRoom('Menu') end)
    --input:bind('7', function() gotoRoom('Stage') end)
    
    input:bind('y', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=100, v=0, type='basic'}) end)
    
    input:bind('t', function() tomemenu = not tomemenu self.area:addGameObject('TomeMenu', 0,0) end)

    input:bind('e', 'interactr')
    input:bind('q', 'activeitem')

    debug_cooldown = false

    input:bind('6', function() Debug_Functions = Debug_Functions + 1 if Debug_Functions > 3 then Debug_Functions = 1 end end)

    input:bind('1', function()
        if Debug_Functions == 1 then 
            activeitem.func()
        elseif Debug_Functions == 2 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='itchytriggerfinger'})
        elseif Debug_Functions == 3 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,100), type='basic', speed=0.5, accuracy=2, size=1.5, attackspeed=2})
        end end)
    
    input:bind('2', function()
        if Debug_Functions == 1 then 
            debug_cooldown = not debug_cooldown
            print(debug_cooldown)
            if debug_cooldown then playerCooldown = 5 else playerCooldown = basePlayerCooldown end
        elseif Debug_Functions == 2 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='sniperscope'})
        elseif Debug_Functions == 3 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2})
        end end)
        
    input:bind('3', function()
        if Debug_Functions == 1 then 
            self.area:addGameObject('Item', self.X, self.Y, {type= 'DefaultTome', upgrades={1,1,1}})
        elseif Debug_Functions == 2 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='lardbucket'})
        elseif Debug_Functions == 3 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2})
        end end)

    input:bind('4', function()
        if Debug_Functions == 1 then 
            upgrade_points = upgrade_points + 1
        elseif Debug_Functions == 2 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='samedaydelivery'})
        elseif Debug_Functions == 3 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2})
        end end)

    input:bind('5', function()
        if Debug_Functions == 1 then 
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='WeaponPlant'})
        elseif Debug_Functions == 2 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='sharpenedbullets'})
        elseif Debug_Functions == 3 then
            local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2})
        end end)

    
    --input:bind('e', 'increase_atkspd')

    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')

    input:bind('w', 'directional_input')
    input:bind('a', 'directional_input')
    input:bind('s', 'directional_input')
    input:bind('d', 'directional_input')

    input:bind('escape', function() paused = not paused self.area:addGameObject('PauseMenuButtons', 0, 0) self.area:addGameObject('Pausemenu', 0, 0) end)

    input:bind('mouse1', 'left_click')
    input:bind('mouse2', 'right_click')
    PlayerX = 0
    PlayerY = 0
    camera.x = 0
    camera.y = 0

    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy', {ignores={'Enemy'}})
    self.area.world:addCollisionClass('Friendly Bullet', {ignores={'Player'}})
    self.area.world:addCollisionClass('Enemy Bullet', {ignores={'Enemy'}})
    self.area.world:addCollisionClass('Terrain')
    self.area.world:addCollisionClass('TerrainP')
    self.area.world:addCollisionClass('Decor', {ignores={'All'}})
    self.area.world:addCollisionClass('Summoner', {ignores={"All"}})
    self.area.world:addCollisionClass('Mouse', {ignores={"All"}})
    self.area.world:addCollisionClass('UI', {ignores={"All"}})
    self.area.world:addCollisionClass('Item', {ignores={"All"}})

    self.area:addGameObject('TTo',0,0)
    EquipedTome = TT['DefaultTome']

    self.area:addGameObject('Room', -(12*tile), -(12*tile), {id=1})
    self.area:addGameObject('Room', -(20*tile), (14*tile), {id=2})
    self.area:addGameObject('Room', -(50*tile), (16*tile), {id=5})
    self.area:addGameObject('Room', -(80*tile), (16*tile), {id=5})
    self.area:addGameObject('Room', -(110*tile), (16*tile), {id=5})

    self.area:addGameObject('Room', -(23*tile), (40*tile), {id=4})

    self.area:addGameObject('Room', (22*tile), (19*tile), {id=3})
    self.area:addGameObject('Player', 0, 0)
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=true})
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=false})

    self.area:addGameObject('UiWeapon', 0, 0)
    self.area:addGameObject('UiHealth', 0, 0)
    self.area:addGameObject('Tome', 0, 0)
    self.area:addGameObject('Mouse', 0, 0)

    Pausemenu:new()
end



function Stage:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        local MX, MY = love.mouse.getPosition()
        MX = MX - gw / 2
        MY = MY - gh / 2
        camera:update(dt)

        camera:follow(PlayerX+MX/4, PlayerY+MY/4)
    end
end



function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    camera:attach(PlayerX, PlayerY, gw, gh)

    self.area:draw()
    camera:draw()

    camera:detach()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
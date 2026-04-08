Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    playerAttackspeed = 1
    playerAccuracy = 1
    playerBulletSpeed = 1.5
    playerBulletSize = 1
    playerDamage = 1

    basePlayerAttackspeed = 1
    basePlayerAccuracy = 1
    basePlayerBulletSpeed = 1.5
    basePlayerBulletSize = 1
    basePlayerDamage = 1

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
    
    input:bind('6', function() Debug_Vision = true end)
    input:bind('7', function() Debug_Vision = false end)
    --input:bind('6', function() gotoRoom('Menu') end)
    --input:bind('7', function() gotoRoom('Stage') end)
    
    input:bind('y', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=100, v=0, type='basic'}) end)
    input:bind('r', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,100), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2}) end)
    input:bind('t', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='shotgunner', speed=0.55, accuracy=5, size=1, attackspeed=3}) end)
    input:bind('e', 'interactr')
    input:bind('q', 'interactl')

    input:bind('5', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Item', MX, MY, {type='WeaponBasic'}) end)
    
    input:bind('1', 'switch_left')
    input:bind('2', 'switch_right')
    input:bind('3', 'lupgrade')
    input:bind('4', 'rupgrade')

    --input:bind('e', 'increase_atkspd')

    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')

    input:bind('w', 'directional_input')
    input:bind('a', 'directional_input')
    input:bind('s', 'directional_input')
    input:bind('d', 'directional_input')

    input:bind('mouse1', 'left_click')
    input:bind('mouse2', 'right_click')
    PlayerX = 0
    PlayerY = 0

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

    self.area:addGameObject('Room', -(12*tile), -(12*tile), {id=1})
    self.area:addGameObject('Room', -(20*tile), (14*tile), {id=2})

    self.area:addGameObject('Room', -(23*tile), (40*tile), {id=4})

    self.area:addGameObject('Room', (22*tile), (19*tile), {id=3})
    self.area:addGameObject('Player', 0, 0)
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=true})
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=false})

    self.area:addGameObject('UiWeapon', 0, 0)
    self.area:addGameObject('UiHealth', 0, 0)
    self.area:addGameObject('Mouse', 0, 0)


    --self.area:addGameObject('Dummy', 0, 0)
    --self.area:addGameObject('Dummy', 100, 0)
    --self.area:addGameObject('Dummy', 200, 0)

    --self.area:addGameObject('Enemy', 200, 200, {hp=10})
end



function Stage:update(dt)
    timer:update(dt)
    
    self.area:update(dt)
    
    camera:update(dt)
    camera:follow(PlayerX, PlayerY)
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
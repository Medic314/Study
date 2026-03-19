Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    LastDmg = 0
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
    
    input:bind('q', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,125), type='basic'}) end)
    input:bind('r', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2}) end)
    input:bind('t', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,200), type='shotgunner', speed=0.55, accuracy=5, size=1, attackspeed=3}) end)
    input:bind('e', function() local MX, MY = love.mouse.getPosition() MX, MY = camera:toWorldCoords(MX/sx, MY/sy) self.area:addGameObject('Enemy', MX, MY, {hp=math.floor(random(1, 12)), v=random(50,125), type='leap'}) end)

    input:bind('1', 'switch_left')
    input:bind('2', 'switch_right')

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
    self.area.world:addCollisionClass('Decor', {ignores={'All'}})
    self.area.world:addCollisionClass('Summoner', {ignores={"All"}})

    self.area:addGameObject('Grid', -300, -300)

    self.area:addGameObject('Player', 0, 0)
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=true})
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=false})

    --self.area:addGameObject('Dummy', 0, 0)
    --self.area:addGameObject('Dummy', 100, 0)
    --self.area:addGameObject('Dummy', 200, 0)

    self.area:addGameObject('Room', 0, 0, {id=1})
    self.area:addGameObject('Room', 0, 650, {id=2})
    self.area:addGameObject('Room', 1050, 500-12.5, {id=3})

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
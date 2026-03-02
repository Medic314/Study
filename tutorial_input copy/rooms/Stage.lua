Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    camera:setFollowLerp(0.05)
    camera:setFollowLead(7.5) 
    camera:setFollowStyle('LOCKON')
    resize(1)
    input:bind('8', 'one')
    input:bind('9', 'two')
    input:bind('0', 'three')
    input:bind('6', function() Debug_Vision = true end)
    input:bind('7', function() Debug_Vision = false end)

    input:bind('1', 'switch_left')
    input:bind('2', 'switch_right')

    input:bind('e', 'increase_atkspd')

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
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Friendly Bullet', {ignores = {'Player'}})

    self.area:addGameObject('Grid', -300, -300)

    self.area:addGameObject('Player', 0, 0)
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=true})
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=false})

    self.area:addGameObject('Dummy', 0, 0)
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
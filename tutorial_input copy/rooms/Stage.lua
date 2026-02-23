Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    camera:setFollowLerp(0.2)
    camera:setFollowLead(2) 
    camera:setFollowStyle('TOPDOWN_TIGHT')
    resize(1)
    input:bind('1', 'one')
    input:bind('2', 'two')
    input:bind('3', 'three')

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

    self.area:addGameObject('Player', 0, 0)
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=true})
    self.area:addGameObject('Gun', PlayerX, PlayerY, {l=false})
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

    camera:detach()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
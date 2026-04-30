Menu2 = Object:extend()

function Menu2:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self:init()
end

function Menu2:init()
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('z', 'z')
    
    self.area:addGameObject('Menu2B')
end



function Menu2:update(dt)
    self.area:update(dt)
    paused = false
    timer:update(dt)
    camera:update(dt)
    camera:follow(0, 0)
end



function Menu2:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    self.area:draw()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
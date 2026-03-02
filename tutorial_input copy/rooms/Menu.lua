Menu = Object:extend()

function Menu:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self:init()
end

function Menu:init()
    resize(1)
    self.area:addGameObject('Button', 0, 0)
    input:bind('mouse1', 'left_click')
end



function Menu:update(dt)
    self.area:update(dt)
end



function Menu:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    self.area:draw()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
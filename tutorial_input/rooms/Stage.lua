Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
end

function Stage:init()
    camera = Camera()
    camera:setFollowLerp(0.1)
    camera:setFollowLead(5) 
    camera:setFollowStyle('TOPDOWN')
    timer = Timer()
    input = Input()
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

    Player = Player()
    Player:init()

    Gunl = Gun()
    Gunr = Gun()
    Gunl:new(true,Player.X, Player.Y)
    Gunr:new(false,Player.X,Player.Y)
    grid = love.graphics.newImage("grid.png")
end



function Stage:update(dt)
    timer:update(dt)
    Gunl:update(dt, Player.X, Player.Y)
    Gunr:update(dt, Player.X, Player.Y)
    Player:update(dt)
    camera:update(dt)
    camera:follow(Player.X, Player.Y)
end



function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    camera:attach(Player.X, Player.Y, gw, gh)
    love.graphics.draw(grid, -300, -300)
    Player:draw()
    Gunl:draw()
    Gunr:draw()
    love.graphics.circle('fill', 0, 0, 10)
    camera:detach()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
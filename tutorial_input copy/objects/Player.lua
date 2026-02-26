Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.X = x
    self.Y = y
    self.A = 300
    self.W, self.H = 76, 122
    self.DX, self.DY = 0, 0
    self.dead = false

    self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.collider:setObject(self)

    bullets = {}
end

function Player:update(dt)
    self.X, self.Y = PlayerX, PlayerY

    Player.super.update(self, dt)
    if input:pressed('one') then resize(1) end
    if input:pressed('two') then resize(2) end
    if input:pressed('three') then resize(3) end

    if input:down('up') then self.Y = self.Y - self.A*dt end
    if input:down('left') then self.X = self.X - self.A*dt end
    if input:down('down') then self.Y = self.Y + self.A*dt end
    if input:down('right') then self.X = self.X + self.A*dt end

    if not input:down('directional_input') then
        self.DX = self.DX - (self.DX/50)
        self.DY = self.DY - (self.DY/50)

        if math.abs(self.DX) < 0.5 then self.DX = 0 end
        if math.abs(self.DY) < 0.5 then self.DY = 0 end
    end

    self.X = self.X + self.DX
    self.Y = self.Y + self.DY

    for i=1, #bullets do
            bullets[i]:update(dt)
    end

    PlayerX, PlayerY = self.X, self.Y
    self.collider:setPosition(self.X, self.Y)
end

function Player:draw()
    for i=1, #bullets do
            bullets[i]:draw()
    end
    local wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.X-self.W/2, self.Y-self.H/2, 0, 0.30, 0.30)
end
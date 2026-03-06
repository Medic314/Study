Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)
    self.X = x
    self.Y = y
    self.W, self.H = 25, 25
    self.hp = opts.hp or 10
    self.v = opts.v or 100

    self.rot = 0

    self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W*2, self.H*2)
    self.collider:setCollisionClass("Enemy")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Enemy:update(dt)
    local dx = self.X + self.v*math.cos(self.rot)*dt
    local dy = self.Y + self.v*math.sin(self.rot)*dt
    self.X = dx
    self.Y = dy
    self.collider:setPosition(self.X, self.Y)

    if self.collider:enter('Player') then
        print("huHf")
    end

    if self.collider:enter('Friendly Bullet') then
        print("Hit")
        self.hp = self.hp - LastDmg
    end
    self.CX, self.CY = self.X, self.Y
    self.MX, self.MY = PlayerX, PlayerY

    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end

    if self.hp <= 0 then
        self.dead = true
    end
end

function Enemy:draw()
    love.graphics.print(self.hp, self.X, self.Y-20)
    love.graphics.line(self.X, self.Y, self.X + 2*self.W*math.cos(self.rot), self.Y + 2*self.W*math.sin(self.rot))
end
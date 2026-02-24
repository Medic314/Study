Bullet = GameObject:extend()

function Bullet:new(area, x, y, opts)
    Bullet.super.new(self, area, x, y, opts)
    self.area = area
    self.x = x
    self.y = y
    self.opts = opts
    self.dead = false

    self.l = self.opts.l
    self.r = self.opts.rot
    self.type = self.opts.type

    self.speed = self.opts.speed or 1
    self.size = self.opts.size or 1

    self.a = 100
    self.rv = 1.66*math.pi
    
    if self.type == "basic" then
        self.v = self.speed*600
        self.w = self.size*12
        self.culltime = 1.25
    elseif self.type == "charge" then
        self.v = self.speed*300
        self.w = self.size*24
        self.culltime = 2.5
    end

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    timer:after(self.culltime, function() self.dead = true end)
end

function Bullet:update(dt)
    local dx = self.x + self.v*math.cos(self.r)*dt
    local dy = self.y + self.v*math.sin(self.r)*dt
    self.x = dx
    self.y = dy

    self.collider:setPosition(self.x, self.y)
end

function Bullet:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end
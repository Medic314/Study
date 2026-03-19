Debris = GameObject:extend()

function Debris:new(area, x, y, opts)
    Debris.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.rot = opts.rot
    self.culltime = opts.culltime
    self.size = opts.size
    self.v = opts.v or 1200
    self.speed = {speed = self.v}

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.size)
    self.collider:setType('dynamic')
    self.collider:setObject(self)

    timer:tween(self.culltime, self.speed, {speed = 0}, 'in-expo')
    timer:after(self.culltime, function() self.dead = true end)
end

function Debris:update(dt)
    local dx = self.x - self.speed.speed*math.cos(self.rot)*dt
    local dy = self.y - self.speed.speed*math.sin(self.rot)*dt
    self.x = dx
    self.y = dy

    self.collider:setPosition(self.x, self.y)
end

function Debris:draw()

end
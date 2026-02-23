Bullet = GameObject:extend()

function Bullet:new(x, y, rot, l)
    self.x = x
    self.y = y
    self.rot = rot
    
    self.l = l

    self.a = 100
    self.r = rot
    self.rv = 1.66*math.pi
    
    if l == true then
        self.v = 600
    else
        self.v = 300
    end

    if l == true then
        self.w = 12
    else
        self.w = 24
    end

    self.collider = Stage.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    timer:after(3, function() print("fb") end)
end

function Bullet:update(dt)
    
    self.x = self.x + self.v*math.cos(self.r)*dt
    self.y = self.y + self.v*math.sin(self.r)*dt

    self.collider:setPosition(self.x, self.y)
end

function Bullet:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end
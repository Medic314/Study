Bullet = GameObject:extend()

function Bullet:new(area, x, y, opts)
    Bullet.super.new(self, area, x, y, opts)
    self.area = area
    self.x = x
    self.y = y
    self.opts = opts
    self.dead = false

    self.l = self.opts.l
    self.charge = self.opts.charge
    self.r = self.opts.rot
    self.type = self.opts.type
    self.shape = self.opts.shape

    self.dmg = self.opts.dmg
    self.speed = self.opts.speed or 1
    self.attackspeed = self.opts.attackspeed or 1
    self.size = self.opts.size or 1

    self.a = 100
    self.rv = 1.66*math.pi
    
    if self.type == "basic" then
        self.damage = 1*self.dmg

        self.v = self.speed*600
        self.w = self.size*10
        self.culltime = 1.25
        self.shake = 0.5
        self.shaketime = 0.25
    elseif self.type == "charge" then
        self.damage = (1*(self.charge/5))*self.dmg

        self.v = self.speed*300
        self.w = self.size*24
        self.culltime = 2.5
        self.shake = 0.1*self.charge
        self.shaketime = 0.05*self.charge
    elseif self.type == "flame" then
        self.damage = 0.2*self.dmg

        self.v = self.speed*450
        self.w = self.size*16
        self.culltime = 0.35
        self.shake = 0.125
        self.shaketime = 0.1
    elseif self.type == "water" then
        self.damage = 1.5*self.dmg

        self.v = self.speed*600
        self.h = self.size*24
        self.w = self.size*24*5
        self.culltime = 0.25
        self.shake = 0.125
        self.shaketime = 0.1
    end

    if self.shape == 'circle' then
        self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
        self.collider:setCollisionClass('Friendly Bullet')
        self.collider:setObject(self)
    elseif self.shape == 'line' then
        self.collider = self.area.world:newLineCollider(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
        self.collider:setCollisionClass('Friendly Bullet')
        self.collider:setObject(self)
    end
    timer:after(self.culltime, function() self.dead = true end)

    camera:shake(self.shake*2, self.shaketime, 60)

    PlayerX = PlayerX + (-1*(self.v*math.cos(self.r)))/700
    PlayerY = PlayerY + (-1*(self.v*math.sin(self.r)))/700
end

function Bullet:update(dt)
    if self.shape == 'circle' then
        local dx = self.x + self.v*math.cos(self.r)*dt
        local dy = self.y + self.v*math.sin(self.r)*dt
        self.x = dx
        self.y = dy

        self.collider:setPosition(self.x, self.y)
    end
    if self.collider:enter('Enemy') then
            self.dead = true
            LastDmg = self.damage
    end
end

function Bullet:draw()
    local wiz = love.graphics.newImage("evil_wizard.png")
    love.graphics.draw(wiz, self.x, self.y, self.r-1.5, self.size/50, self.size/50)
    --love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end
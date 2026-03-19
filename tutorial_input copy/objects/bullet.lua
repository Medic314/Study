Bullet = GameObject:extend()

function Bullet:new(area, x, y, opts)
    Bullet.super.new(self, area, x, y, opts)
    self.image = love.graphics.newImage("assets/evil_wizard.png")
    self.area = area
    self.x = x
    self.y = y
    self.opts = opts
    self.dead = false
    self.homing = self.opts.homing or false

    self.l = self.opts.l
    self.charge = self.opts.charge
    self.r = self.opts.rot
    self.type = self.opts.type
    self.shape = self.opts.shape

    self.dmg = self.opts.dmg or 1
    self.speed = self.opts.speed or 1
    self.attackspeed = self.opts.attackspeed or 1
    self.size = self.opts.size or 1

    self.a = 100
    self.rv = 1.66*math.pi
    self.enemies_hit = {} -- Track enemies hit for pierce bullets

    
    if self.type == "basic" then
        self.damage = 1*self.dmg

        self.v = self.speed*600
        self.w = self.size*10
        self.culltime = 1.25
        if self.polarity == 'enemy' then
            self.culltime = 2.25
            self.v = self.speed*450
        end
        self.shake = 0.5
        self.shaketime = 0.25

        self.pierce = false
    elseif self.type == "charge" then
        self.damage = ((1*(self.charge/5))*self.dmg)*2

        self.v = self.speed*300
        self.w = self.size*24
        self.culltime = 2.5
        self.shake = 0.1*self.charge
        self.shaketime = 0.05*self.charge

        self.pierce = false
    elseif self.type == "flame" then
        self.damage = 0.25*self.dmg

        self.v = self.speed*450
        self.w = self.size*16
        self.culltime = 0.35
        self.shake = 0.125
        self.shaketime = 0.1

        self.pierce = false
    elseif self.type == "water" then
        self.damage = 1.5*self.dmg

        self.v = self.speed*600
        self.h = self.size*24
        self.w = self.size*24*7
        self.culltime = 0.25
        self.shake = 0.125
        self.shaketime = 0.1

        self.pierce = true
    elseif self.type == "lightning" then
        self.damage = 3*self.dmg

        self.v = self.speed*0
        self.w = self.size*32
        self.culltime = 0.5
        self.shake = 0.2
        self.shaketime = 0.1

        self.pierce = true
    end

    if self.polarity == 'enemy' then
        self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
        self.collider:setCollisionClass('Enemy Bullet')
        self.collider:setObject(self)
    else
        if self.shape == 'circle' then
            self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
            self.collider:setCollisionClass('Friendly Bullet')
            self.collider:setObject(self)
            self.collider.damage = self.damage -- Store damage on collider
        elseif self.shape == 'line' then
            self.collider = self.area.world:newLineCollider(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
            self.colliders = self.area.world:queryLine(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r), {'Enemy'})
            self.collider:setCollisionClass('Friendly Bullet')
            self.collider:setObject(self)
            for i=1, #self.colliders do
                print(self.colliders[i])
            end
        end
    end

    if self.type == 'lightning' then
        self.mx, self.my = love.mouse.getPosition()
        self.x, self.y = camera:toWorldCoords(self.mx, self.my)
        self.collider:setPosition(self.x, self.y)
    end

    timer:after(self.culltime, function() self.dead = true end)

    camera:shake(self.shake*2, self.shaketime, 60)

    --PlayerX = PlayerX + (-1*(self.v*math.cos(self.r)))/700
    --PlayerY = PlayerY + (-1*(self.v*math.sin(self.r)))/700
end

function Bullet:update(dt)
    if self.homing then
        self.colliders = self.area.world:queryCircleArea(self.x, self.y, 150, {'Enemy'})
        if self.colliders[1] then
            self.CX, self.CY = self.x, self.y
            self.MX, self.MY = self.colliders[1]:getPosition()

            self.dx = self.MX - self.CX
            self.dy = self.MY - self.CY
            self.rot = math.pi / 2 - math.atan(self.dx / self.dy)
            if self.dy < 0 then self.rot = self.rot + math.pi end
            
            local turn_speed = 4 * dt
            local angle_diff = self.rot - self.r
            if math.abs(angle_diff) > math.pi then
                angle_diff = angle_diff - (angle_diff / math.abs(angle_diff)) * 2 * math.pi
            end
            self.r = self.r + angle_diff * math.min(1, turn_speed / math.abs(angle_diff))
        end
    end

    if self.pierce == false then
        local dx = self.x + self.v*math.cos(self.r)*dt
        local dy = self.y + self.v*math.sin(self.r)*dt
        self.x = dx
        self.y = dy

        self.collider:setPosition(self.x, self.y)
    end

    if self.polarity == 'enemy' then
        self.colliders = self.area.world:queryCircleArea(self.x, self.y, self.w, {'Terrain'})
        if self.colliders[1] then
            self.dead = true
        end
        self.collider:setPreSolve(function(collider_1, collider_2, contact)
            if collider_1.collision_class == 'Enemy Bullet' and collider_2.collision_class == 'Player' then
                --collider_1.damage = self.damage or 1
                contact:setEnabled(false)
                self.dead = true
            end
        end)
    else
        self.collider:setPreSolve(function(collider_1, collider_2, contact)
            if collider_1.collision_class == 'Friendly Bullet' and collider_2.collision_class == 'Enemy' then
                collider_1.damage = self.damage
                contact:setEnabled(false)
                if self.pierce == false then
                    self.dead = true
                end
            end
        end)
    end
    self.colliders = self.area.world:queryCircleArea(self.x, self.y, self.w, {'Terrain'})
    if self.colliders[1] then
        if self.type == 'charge' then
            self.area:addGameObject('Debris', self.x, self.y, {size=10, rot=self.r+random(-0.8, 0.8), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=10, rot=self.r+random(-0.8, 0.8), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=10, rot=self.r+random(-0.8, 0.8), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=10, rot=self.r+random(-0.8, 0.8), v=random(100, 800), culltime=random(0.1, 0.3)})
        else
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
        end
        self.dead = true
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, self.r-1.5, self.size/50, self.size/50)
    --love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end
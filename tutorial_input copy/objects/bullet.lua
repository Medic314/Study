Bullet = GameObject:extend()

function Bullet:new(area, x, y, opts)
    Bullet.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.image = ST['BulletPlaceholder'] or opts.image
    self.area = area
    self.x = x
    self.y = y
    self.opts = opts
    self.dead = false
    self.homing = self.opts.homing or false
    self.homingstrength = self.opts.homingstrength or 4

    

    self.l = self.opts.l
    self.charge = self.opts.charge
    self.r = self.opts.rot
    self.type = self.opts.type
    self.shape = self.opts.shape

    self.dmg = self.opts.dmg or 1
    self.speed = self.opts.speed or 1
    self.attackspeed = self.opts.attackspeed or 1
    self.size = self.opts.size or 1
    self.smites = self.opts.smites or 1
    self.range = self.opts.range or 0
    self.interval = self.opts.interval or 0.5
    self.upgrade = self.opts.upgrade or 1
    self.plantlock = self.opts.lock
    
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
        self.damage = 3*self.dmg

        self.v = self.speed*600
        self.h = self.size*24
        self.w = self.size*24*(5+self.range)
        self.culltime = 0.25
        self.shake = 0.125
        self.shaketime = 0.1

        self.pierce = true
    elseif self.type == "lightning" then
        self.damage = 3*self.dmg

        self.v = self.speed*0
        if self.homing then
            self.v = self.speed*100
        end
        self.w = self.size*32
        self.shake = 0.2
        self.shaketime = 0.5
        self.culltime = 0.2
        

        self.pierce = false
    elseif self.type == "plant" then
        self.damage = 2*self.dmg

        self.v = self.speed*0
        self.w = self.size*32
        self.shake = 0.2
        self.shaketime = 0.5
        self.culltime = 0.2
        

        self.pierce = false
    elseif self.type == "wall" then
        self.damage = 0*self.dmg

        self.size = self.opts.size
        self.hp = self.opts.hp

        self.v = self.speed*0
        self.w = self.size*1
        self.shake = 0
        self.shaketime = 0
        self.culltime = 0
        self.scale = 1

        self.pierce = false

        if Wallup then
            Wallkill = true
        else
            local MX, MY = love.mouse.getPosition()
            self.x, self.y = camera:toWorldCoords(MX/sx, MY/sy)
            self.area:addGameObject('Prop', self.x, self.y, {w=25, h=100*self.size, r=self.rot, hp=self.hp, type="vinewall"})
        end
    end

    if self.polarity == 'enemy' then
        self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
        self.collider:setCollisionClass('Enemy Bullet')
        self.collider:setObject(self)
        local function scale_image_to_circle(img, diameter)
            local width, height = img[1], img[2]
            local diagonal = math.sqrt(width * width + height * height)
            local scale_factor = diameter / diagonal
            return scale_factor
        end
        local imgW, imgH = self.image:getDimensions()
        local diameter = self.w * 2
        self.scale = scale_image_to_circle({imgW, imgH}, diameter)
        self.ox = imgW / 2
        self.oy = imgH / 2

    else
        if self.shape == 'circle' then
            self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
            self.collider:setCollisionClass('Friendly Bullet')
            self.collider:setObject(self)
            self.collider.damage = self.damage
            local function scale_image_to_circle(img, diameter)
                local width, height = img[1], img[2]
                local diagonal = math.sqrt(width * width + height * height)
                local scale_factor = diameter / diagonal
                return scale_factor
            end
            local imgW, imgH = self.image:getDimensions()
            local diameter = self.w * 2
            self.scale = scale_image_to_circle({imgW, imgH}, diameter)
            self.ox = imgW / 2
            self.oy = imgH / 2
        elseif self.shape == 'line' then
            self.collider = self.area.world:newLineCollider(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
            self.colliders = self.area.world:queryLine(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r), {'Enemy'})
            self.collider:setCollisionClass('Friendly Bullet')
            self.collider:setObject(self)
            self.collider:setType('static')
            self.scale = 1
            self.ox, self.oy = 0,0
            self.collider.damage = self.damage
            for i=1, #self.colliders do
                print(self.colliders[i])
            end
        end
    end

    if self.type == 'lightning' then
        if self.shape == 'ghost' then
            self.ghost = true
            local MX, MY = love.mouse.getPosition()
            self.x, self.y = camera:toWorldCoords(MX/sx, MY/sy)
            self.radius = {radius = 5}

            timer:tween(1*self.attackspeed, self.radius, {radius = self.w}, 'in-quart')
            for i=1, self.smites do
                timer:after((1+(i-1)*0.25)*self.attackspeed, function() self.area:addGameObject('Bullet', self.x, self.y, {rot=self.rot, l=self.l, type="lightning", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg, homing=false}) end)
                if i == self.smites then
                    timer:after((1+(i-1)*0.25)*self.attackspeed, function() self.dead = true end)
                end
            end
        else
            timer:after(self.culltime, function() self.dead = true end)
        end
    elseif self.type == 'plant' and self.shape == 'ghost' then
        if self.upgrade == 2 or self.upgrade == 3 then
            for i=1, 3 do
                local dx = self.x + (100*i)*math.cos(self.r)
                local dy = self.y + (100*i)*math.sin(self.r)
                timer:after(0.1*i*self.attackspeed, function() self.area:addGameObject('Bullet', dx, dy, {rot=self.rot, l=self.l, type="plant", lock=true, upgrade = 1, attackspeed=self.attackspeed, shape='ghost', speed=self.speed, dmg=self.dmg, homing=false}) end)
            end
        end

        self.ghost = true
        if not self.plantlock then
            local MX, MY = love.mouse.getPosition()
            self.x, self.y = camera:toWorldCoords(MX/sx, MY/sy)
        end
        self.radius = {radius = 5}

        timer:tween(0.5*self.attackspeed, self.radius, {radius = self.w}, 'in-quart')
        timer:after(0.5*self.attackspeed, function() self.area:addGameObject('Bullet', self.x, self.y, {rot=self.rot, l=self.l, upgrade=self.upgrade, type="plant", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg, homing=false}) end)
        timer:after(0.5, function() self.dead = true end)
    else
        timer:after(self.culltime, function() self.dead = true end)
    end
    camera:shake(self.shake*2, self.shaketime, 60)
    if self.collider then
        self.collider.bullettype = self.type
        self.collider.damage = self.damage
        self.collider.upgrade = self.upgrade
        self.collider.l = self.l
        self.collider.timer = self.interval*self.attackspeed
    end

    --PlayerX = PlayerX + (-1*(self.v*math.cos(self.r)))/700
    --PlayerY = PlayerY + (-1*(self.v*math.sin(self.r)))/700
end

function Bullet:update(dt)
    if self.type == 'wall' then
        self.dead = true
    end
    if self.homing then
        if self.type == 'lightning' then
            self.colliders = self.area.world:queryCircleArea(self.x, self.y, 300, {'Enemy'})
        else
            self.colliders = self.area.world:queryCircleArea(self.x, self.y, 37.5*self.homingstrength, {'Enemy'})
        end
        if self.colliders[1] then
            self.CX, self.CY = self.x, self.y
            self.MX, self.MY = self.colliders[1]:getPosition()

            self.dx = self.MX - self.CX
            self.dy = self.MY - self.CY
            self.rot = math.pi / 2 - math.atan(self.dx / self.dy)
            if self.dy < 0 then self.rot = self.rot + math.pi end
            
            local turn_speed = self.homingstrength * dt
            local angle_diff = self.rot - self.r
            if math.abs(angle_diff) > math.pi then
                angle_diff = angle_diff - (angle_diff / math.abs(angle_diff)) * 2 * math.pi
            end
            self.r = self.r + angle_diff * math.min(1, turn_speed / math.abs(angle_diff))
        else
            self.dx = 100
            self.dy = 100
        end 
    else
        self.dx = 100
        self.dy = 100
    end
    

    if self.pierce == false then
        if self.dx >= 20 or self.dx <= -20 or self.dy >= 20 or self.dy <= -20 then
            local dx = self.x + self.v*math.cos(self.r)*dt
            local dy = self.y + self.v*math.sin(self.r)*dt
            self.x = dx
            self.y = dy
            if self.collider then
                self.collider:setPosition(self.x, self.y)
            end
        end
    end

    if self.polarity == 'enemy' then
        self.colliders = self.area.world:queryCircleArea(self.x, self.y, self.w, {'Terrain'})
        if self.colliders[1] then
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.area:addGameObject('Debris', self.x, self.y, {size=5, rot=self.r+random(-0.4, 0.4), v=random(100, 800), culltime=random(0.1, 0.3)})
            self.dead = true
        end
        self.collider:setPreSolve(function(collider_1, collider_2, contact)
            if collider_1.collision_class == 'Enemy Bullet' and collider_2.collision_class == 'Player' then
                contact:setEnabled(false)
                self.dead = true
            end
            if collider_1.collision_class == 'Enemy Bullet' and collider_2.collision_class == 'TerrainP' then
                contact:setEnabled(false)
                self.dead = true
            end
        end)
    else
        if self.collider then
            self.collider:setPreSolve(function(collider_1, collider_2, contact)
                contact:setEnabled(false)
                if collider_1.collision_class == 'Friendly Bullet' and collider_2.collision_class == 'Enemy' then
                    if self.pierce == false then
                        self.dead = true
                    end
                end
                if collider_1.collision_class == 'Friendly Bullet' and collider_2.collision_class == 'TerrainP' then
                    if self.pierce == false then
                        self.dead = true
                    end
                end
            end)
        end
    end

    if self.shape == "circle" then
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

end

function Bullet:draw()
    if self.ghost then
        love.graphics.circle('line', self.x, self.y, self.radius.radius)
    else
        love.graphics.draw(self.image, self.x, self.y, self.r, self.scale+0.1, self.scale+0.1, self.ox, self.oy)
    end
end
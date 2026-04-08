Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)
    self.layer = 'main layer'

    self.opts = opts or {}
    self.type = self.opts.type or 'basic'
    self.anims = true
    self.waterbuffer = false
    self.invincible = false
    self.contactdamage = true
    if self.type == 'basic' or self.type == 'leap' then
        self.image = love.graphics.newImage("assets/basicenemy.png")
        self.frame = 1
        self.max_frames = 6
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 25
        self.IW, self.IH = 250, 250
        self.frametime = 0.1

         self.moveanim = true
         self.turnanim = true
    elseif self.type == 'gunner' or self.type =='shotgunner' then
        self.image = love.graphics.newImage("assets/flyingenemy.png")
        self.frame = 1
        self.max_frames = 2
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 25
        self.IW, self.IH = 220, 151
        self.frametime = 0.15

        self.moveanim = true
        self.turnanim = true
    elseif self.type == 'sentry' then
        self.image = love.graphics.newImage("assets/Sentrydev.png")
        self.frame = 2
        self.max_frames = 2
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 50
        self.IW, self.IH = 200, 300
        self.frametime = 0.1

        self.moveanim = false
        self.turnanim = false
        self.contactdamage = false
    elseif self.type == 'trenchcoat' then
        self.image = love.graphics.newImage("assets/Trenchcoatdev.png")
        self.frame = 2
        self.max_frames = 2
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 50
        self.IW, self.IH = 200, 300
        self.frametime = 0.2

        self.moveanim = true
        self.turnanim = true
    end

    local imgW, imgH = self.image:getDimensions()
    self.IW = imgW / self.max_frames
    self.IH = imgH

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end
    if self.moveanim then 
        timer:every(self.frametime, function() if self.anims == true then self.frame = self.frame + 1 if self.frame > self.max_frames then self.frame = 1 end end end)
    end
    self.X = x
    self.Y = y
    self.hp = self.opts.hp or 10
    self.v = self.opts.v or 100
    if self.type == 'sentry' then self.v = 0 end
    self.dv = self.v

    self.dmg = self.opts.dmg or 1
    self.speed = self.opts.speed or 1
    self.attackspeed = self.opts.attackspeed or 1
    self.size = self.opts.size or 1
    self.accuracy = self.opts.accuracy or 1

    self.dx = 0
    self.dy = 0

    self.stun = false
    self.turnlock = false
    self.pause = false

    self.rot = 0

    self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W*2, self.H*2)
    self.collider:setCollisionClass("Enemy")
    --self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.type = self.type
    self.collider.whit = false
    self.collider.type = self.type
    self.collider.contactdamage = self.contactdamage

    print(self.type, self.v)
    timer:every(0.5, function() if self.collider then if self.collider.on_fire then self.hp = self.hp - 0.5 end end end)
end

function Enemy:update(dt)
    self.lx, self.ly = self.X, self.Y
    if self.stun == false then
        self.dx = self.X + self.v*math.cos(self.rot)*dt
        self.dy = self.Y + self.v*math.sin(self.rot)*dt
        local newX = self.dx
        local newY = self.ly
        self.collider:setPosition(newX, newY)
        local collidersX = self.area.world:queryRectangleArea(newX - self.W, newY - self.H, self.W * 2, self.H * 2, {'Terrain', 'TerrainP'})
        if collidersX[1] then
            newX = self.lx
        end

        newY = self.dy
        self.collider:setPosition(newX, newY)
        local collidersY = self.area.world:queryRectangleArea(newX - self.W, newY - self.H, self.W * 2, self.H * 2, {'Terrain', 'TerrainP'})
        if collidersY[1] then
            newY = self.ly
        end
        self.X = self.dx
        self.Y = self.dy
        self.X, self.Y = newX, newY
        self.collider:setPosition(self.X, self.Y)
    end
    self.dfx, self.dfy = self.X - self.lx, self.Y - self.ly

    

    
    self.collider:setPosition(self.X, self.Y)

    if self.collider:enter('Player') then
        print("huHf")
    end

    if self.turnlock == false then
        if self.type == 'sentry' then
            self.CX, self.CY = self.X, self.Y-25
        else
             self.CX, self.CY = self.X, self.Y
        end
        self.MX, self.MY = PlayerX, PlayerY

        self.rdx = self.MX - self.CX
        self.rdy = self.MY - self.CY
        self.rot = math.pi / 2 - math.atan(self.rdx / self.rdy)
        if self.rdy < 0 then self.rot = self.rot + math.pi end
    end

    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Friendly Bullet' then
            if self.invincible then
                collider_2.damage = 0
            end
            if collider_2.bullettype == 'water' then
                if not collider_1.whit then
                    self.hp = self.hp - collider_2.damage
                    print("WHit")
                    collider_1.whit = true
                    timer:after(collider_2.timer, function() collider_1.whit = false end)
                end
            elseif collider_2.bullettype == 'basic' and collider_2.upgrade == 3 then
                contact:setEnabled(false)
                self.hp = self.hp - collider_2.damage
                print("Hit")
                if not collider_1.on_fire then
                    collider_1.on_fire = true
                    timer:after(4, function() collider_1.on_fire = false end)
                end
            elseif collider_2.bullettype == 'plant' and collider_2.upgrade == 3 then
                contact:setEnabled(false)
                self.stun = true
                self.pause = true
                self.hp = self.hp - collider_2.damage
                print("stun")
                timer:after(2, function() self.stun = false self.pause = false end)
            else
                contact:setEnabled(false)
                self.hp = self.hp - collider_2.damage
                print("Hit")
            end
        end    
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Enemy' then
            contact:setEnabled(false)
        end    
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Terrain' then
            contact:setEnabled(false)
        end
    end)

    if self.hp <= 0 then
        if self.type == 'trenchcoat' then
            self.area:addGameObject('Enemy', self.X, self.Y-25, {hp=2, v=self.v*random(1.60, 1.80), type='basic'})
            self.area:addGameObject('Enemy', self.X-25, self.Y+25, {hp=2, v=self.v*random(1.60, 1.80), type='basic'})
            self.area:addGameObject('Enemy', self.X+25, self.Y+25, {hp=2, v=self.v*random(1.60, 1.80), type='basic'})
            self.dead=true
        else
            self.dead = true
        end
    end

    if self.type == 'gunner' or self.type == 'shotgunner' then
        if self.rdx >= -250 and self.rdx <= 250 and self.rdy >= -250 and self.rdy <= 250 then
            self.stun = true
        else
            self.stun = false
        end
    end

    if self.type == 'sentry' then
        if self.rdx >= -250 and self.rdx <= 200 and self.rdy >= -200 and self.rdy <= 200 then
            self.pause2 = true
            self.frame = 1
            self.invincible = true
            self.aiming = false
            self.turnlock = false
            self.pause = false
            self.cancelshot = true
            timer:cancel('sentry1')
            timer:cancel('sentry2')
            timer:cancel('sentry3')
        else
            self.pause2 = false
            self.frame = 2
            self.invincible = false
        end
    end

    if self.pause == false then
        if self.type == 'leap' then
            if self.rdx >= -150 and self.rdx <= 150 and self.rdy >= -150 and self.rdy <= 150 then
                self.stun = true
                self.pause = true
                self.turnlock = true
                self.frame = 1
                timer:after(0.1, function() self.frame = 2 end)
                timer:after(0.2, function() self.frame = 3 end)
                self.anims = false
                print("leap")
                timer:after(0.5, function() self.stun = false self.v = self.v*10 if self.v > 1600 then self.v = 1600 end if self.v < 800 then self.v = 800 end end)
                timer:after(0.75, function() self.v = self.dv self.turnlock = false self.anims = true end)
                timer:after(2, function() self.pause = false end)
            end
        end
        if self.type == 'gunner' then
            local function shoot() self.area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random(-0.1*self.accuracy, 0.1*self.accuracy), polarity='enemy', type="basic", attackspeed=self.attackspeed, speed=self.speed, dmg=self.dmg+1, size=self.size}) end
            self.pause = true
            shoot()
            timer:after(0.75*self.attackspeed, function() self.pause = false end)
        end
        if self.type == 'shotgunner' then
            local function shoot() self.area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random(-0.1*self.accuracy, 0.1*self.accuracy), polarity='enemy', type="basic", attackspeed=self.attackspeed, speed=self.speed, dmg=self.dmg, size=self.size}) end
            self.pause = true
            shoot()
            shoot()
            shoot()
            shoot()
            timer:after(1*self.attackspeed, function() self.pause = false end)
        end
        if self.type == 'sentry' then
            if not self.pause2 then
                self.aiming = true
                self.pause = true
                if not self.shotcancel then
                    timer:after(1*self.attackspeed, function() if not self.pause2 then self.aiming = false self.turnlock = true end end, 'sentry1')
                    timer:after(1.2*self.attackspeed, function() if not self.shotcancel then if not self.pause2 then if not self.dead then self.area:addGameObject('Bullet', self.X, self.Y-25, {rot=self.rot, polarity='enemy', type="basic", attackspeed=self.attackspeed, speed=self.speed+3, dmg=self.dmg, size=self.size+0.5}) end end end end, 'sentry2')
                    timer:after(2.5*self.attackspeed, function() self.turnlock = false self.pause = false self.shotcancel = false end, 'sentry3')
                end
            end
        end
    end
end



function Enemy:draw()
    if self.turnanim then
        if self.rot < 1.5 or self.rot > 4.7 then
            love.graphics.draw(self.image, self.quads[self.frame], self.X, self.Y, 0, self.scale, self.scale, self.IW/2, self.IH/2)
        else
            love.graphics.draw(self.image, self.quads[self.frame], self.X, self.Y, 0, self.scale*-1, self.scale, self.IW/2, self.IH/2)
        end
    else
        love.graphics.draw(self.image, self.quads[self.frame], self.X, self.Y, 0, self.scale, self.scale, self.IW/2, self.IH/2)
    end
    if Debug_Vision then
        love.graphics.print(self.hp, self.X, self.Y-20)
        if self.type == 'sentry' then
            love.graphics.line(self.X, self.Y-25, self.X + 2*self.W*math.cos(self.rot), self.Y-25 + 2*self.W*math.sin(self.rot))
        else
            love.graphics.line(self.X, self.Y, self.X + 2*self.W*math.cos(self.rot), self.Y + 2*self.W*math.sin(self.rot))
        end
    end
    if self.aiming == true then
        if not self.pause2 then
            love.graphics.line(self.X, self.Y-25, self.X + 10*self.W*math.cos(self.rot), self.Y-25 + 10*self.W*math.sin(self.rot))
        end
    end
end
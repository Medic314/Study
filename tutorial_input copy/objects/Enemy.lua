Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)

    self.opts = opts or {}
    self.type = self.opts.type or 'basic'
    self.anims = true
    if self.type == 'basic' or self.type == 'leap' then
        self.image = love.graphics.newImage("assets/basicenemy.png")
        self.frame = 1
        self.max_frames = 6
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 25
        self.IW, self.IH = 250, 250
    elseif self.type == 'gunner' or self.type =='shotgunner' then
        self.image = love.graphics.newImage("assets/flyingenemy.png")
        self.frame = 1
        self.max_frames = 2
        self.quads = {}
        self.scale = 0.40
        self.W, self.H = 25, 25
        self.IW, self.IH = 220, 151
    end

    local imgW, imgH = self.image:getDimensions()
    self.IW = imgW / self.max_frames
    self.IH = imgH

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end
    timer:every(0.1, function() if self.anims == true then self.frame = self.frame + 1 if self.frame > self.max_frames then self.frame = 1 end end end)

    self.X = x
    self.Y = y
    self.hp = self.opts.hp or 10
    self.v = self.opts.v or 100
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

    print(self.type, self.v)
end

function Enemy:update(dt)
    self.lx, self.ly = self.X, self.Y
    if self.stun == false then
        self.dx = self.X + self.v*math.cos(self.rot)*dt
        self.dy = self.Y + self.v*math.sin(self.rot)*dt
        local newX = self.dx
        local newY = self.ly
        self.collider:setPosition(newX, newY)
        local collidersX = self.area.world:queryRectangleArea(newX - self.W, newY - self.H, self.W * 2, self.H * 2, {'Terrain'})
        if collidersX[1] then
            newX = self.lx
        end

        newY = self.dy
        self.collider:setPosition(newX, newY)
        local collidersY = self.area.world:queryRectangleArea(newX - self.W, newY - self.H, self.W * 2, self.H * 2, {'Terrain'})
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
        self.CX, self.CY = self.X, self.Y
        self.MX, self.MY = PlayerX, PlayerY

        self.dx = self.MX - self.CX
        self.dy = self.MY - self.CY
        self.rot = math.pi / 2 - math.atan(self.dx / self.dy)
        if self.dy < 0 then self.rot = self.rot + math.pi end
    end

    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Friendly Bullet' then
            contact:setEnabled(false)
            self.hp = self.hp - collider_2.damage
            print("Hit")
        end    
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Enemy' then
            contact:setEnabled(false)
        end    
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Terrain' then
            contact:setEnabled(false)
        end    
    end)

    if self.hp <= 0 then
        self.dead = true
    end

    if self.type == 'gunner' or self.type == 'shotgunner' then
        if self.dx >= -250 and self.dx <= 250 and self.dy >= -250 and self.dy <= 250 then
            self.stun = true
        else
            self.stun = false
        end
    end

    if self.pause == false then
        if self.type == 'leap' then
            if self.dx >= -150 and self.dx <= 150 and self.dy >= -150 and self.dy <= 150 then
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
            local function shoot() self.area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random(-0.1*self.accuracy, 0.1*self.accuracy), polarity='enemy', type="basic", attackspeed=self.attackspeed, speed=self.speed, dmg=self.dmg, size=self.size}) end
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
    end
end



function Enemy:draw()
    if self.rot < 1.5 or self.rot > 4.7 then
        love.graphics.draw(self.image, self.quads[self.frame], self.X, self.Y, 0, self.scale, self.scale, self.IW/2, self.IH/2)
    else
        love.graphics.draw(self.image, self.quads[self.frame], self.X, self.Y, 0, self.scale*-1, self.scale, self.IW/2, self.IH/2)
    end
    if Debug_Vision then
        love.graphics.print(self.hp, self.X, self.Y-20)
        love.graphics.line(self.X, self.Y, self.X + 2*self.W*math.cos(self.rot), self.Y + 2*self.W*math.sin(self.rot))
    end
end
Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)

    self.opts = opts

    if self.opts.l then self.D = -20 end
    if not self.opts.l then self.D = 20 end

    self.area = area
    self.X = PlayerX + self.D
    self.Y = PlayerY

    self.attackspeed = self.opts.attackspeed or 1
    self.accuracy = self.opts.accuracy or 1
    self.speed = self.opts.speed or 1.5
    self.size = self.opts.size or 1
    self.dmg = self.opts.dmg or 1

    self.chargenum = 0
    self.chargerate = 1.125*self.attackspeed
    self.maxcharge = 20

    self.ammo = 12

    self.buffer = false

    self.rot = 0

    local function Basic_Bullet(area, x, y, rot, l, accuracy)
        if self.ammo > 0 then
            area:addGameObject('Bullet', x, y, {rot=rot+random(-0.1*accuracy, 0.1*accuracy), l=l, type="basic", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg})
            self.ammo = self.ammo - 1
        else
            if self.buffer == false then
                self.buffer = true
                timer:after((0.35*self.attackspeed)*3, function() self.ammo = 12 end)
                self.buffer = false
            end
        end
     end

    local function Water_Bullet(area, x, y, rot, l, accuracy)
        area:addGameObject('Bullet', x, y, {rot=rot+random(-0.05*accuracy, 0.05*accuracy), l=l, type="water", attackspeed=self.attackspeed, shape='line', speed=self.speed, dmg=self.dmg})
    end

    local function Flame_Bullet(area, x, y, rot, l, accuracy)
        area:addGameObject('Bullet', x, y, {rot=rot+random(-0.3*accuracy, 0.3*accuracy), l=l, type="flame", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg})
    end

    local function charge_Bullet()
        if self.chargenum < 10 then
            self.chargenum = self.chargenum + self.chargerate
        else
            self.chargenum = self.chargenum + self.chargerate/4
            camera:shake(0.25, 0.5, 15)
        end
        if self.chargenum > self.maxcharge then
            self.chargenum = self.maxcharge
            camera:shake(0.75, 0.25, 20)
        end

        print(self.chargenum)
    end

    local function charge_Bullet_Release(area, x, y, rot, l)
        if self.chargenum >= 10 then
            area:addGameObject('Bullet', x, y, {rot=rot, l=l, type="charge", size=self.chargenum/10, charge=self.chargenum, attackspeed=self.attackspeed, shape='circle', dmg=self.dmg})
        end
        self.chargenum = 0
    end

    self.basic = {interval=0.35, downfunc = function() Basic_Bullet(self.area, self.X, self.Y, self.rot, self.opts.l, self.accuracy) end, name = "basic"}
    self.flame = {interval=0.05, downfunc = function() Flame_Bullet(self.area, self.X, self.Y, self.rot, self.opts.l, self.accuracy) end, name = "flame"}
    self.water = {interval=0.5, downfunc = function() Water_Bullet(self.area, self.X, self.Y, self.rot, self.opts.l, self.accuracy) end, name = "water"}
    self.charge = {interval=0.1, downfunc = function() charge_Bullet() end, releasefunc = function() charge_Bullet_Release(self.area, self.X, self.Y, self.rot, self.opts.l) end, name = "charge"}

    self.lweapon = self.basic
    self.rweapon = self.charge

    self.lcycle = 0
    self.rcycle = 1
end

function Gun:update(dt)
    self.X, self.Y = PlayerX+self.D, PlayerY
    self.CX, self.CY = camera:toCameraCoords(self.X, self.Y)
    self.CX = (self.CX)*sx
    self.CY = self.CY*sx
    self.MX, self.MY = love.mouse.getPosition()
    self.MX, self.MY = self.MX, self.MY

    camera:toCameraCoords(self.X, self.Y)
    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end

    if input:pressed('increase_atkspd') then
        self.attackspeed = self.attackspeed - (self.attackspeed / 10)
        print(self.attackspeed)
    end

    if input:pressed('switch_left') then
        self.lcycle = self.lcycle + 1
        if self.lcycle > 3 then self.lcycle = 0 end
        if self.lcycle == 0 then
            self.lweapon = self.basic
        end
        if self.lcycle == 1 then
            self.lweapon = self.charge
        end
        if self.lcycle == 2 then
            self.lweapon = self.flame
        end
        if self.lcycle == 3 then
            self.lweapon = self.water
        end
    end
    if input:pressed('switch_right') then
        self.rcycle = self.rcycle + 1
        if self.rcycle > 3 then self.rcycle = 0 end
        if self.rcycle == 0 then
            self.rweapon = self.basic
        end
        if self.rcycle == 1 then
            self.rweapon = self.charge
        end
        if self.rcycle == 2 then
            self.rweapon = self.flame
        end
        if self.rcycle == 3 then
            self.rweapon = self.water
        end
    end

    if self.l then
        if input:pressed('left_click') then
            if self.buffer == false then
                self.lweapon.downfunc()
                self.buffer = true
                timer:after(self.lweapon.interval*self.attackspeed, function() self.buffer = false end)
            end
        end
        
        if input:down('left_click', self.lweapon.interval*self.attackspeed) then
            if self.buffer == false then
               self.lweapon.downfunc() 
            end
        end
        if input:released('left_click') then
            if self.lweapon.releasefunc then
                self.lweapon.releasefunc()
            end
        end

    else

        if input:pressed('right_click') then
            if self.buffer == false then
                self.rweapon.downfunc()
                self.buffer = true
                timer:after(self.rweapon.interval*self.attackspeed, function() self.buffer = false end)
            end
        end
        if input:down('right_click', self.rweapon.interval*self.attackspeed) then
            if self.buffer == false then
                self.rweapon.downfunc()
            end
        end
        if input:released('right_click') then
            if self.rweapon.releasefunc then
                self.rweapon.releasefunc()
            end
        end
    end
end

function Gun:draw()
    wiz = love.graphics.newImage("R.png")
    love.graphics.draw(wiz, self.X, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
    love.graphics.circle('fill', self.X, self.Y, 5)
    self.printx, self.printy = camera:toCameraCoords(0,0)
    if self.l then
        love.graphics.print(self.lweapon.name, self.printx*-1, self.printy*-1)
    else
        love.graphics.print(self.rweapon.name, self.printx*-1, (self.printy-20)*-1)
    end
end
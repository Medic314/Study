Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.image = love.graphics.newImage("assets/R.png")

    self.opts = opts

    if self.opts.l then self.D = -20 end
    if not self.opts.l then self.D = 20 end

    self.area = area
    self.X = PlayerX + self.D
    self.Y = PlayerY
    self.upgrade = 1

    self.attackspeed = playerAttackspeed
    self.accuracy = playerAccuracy
    self.speed = playerBulletSpeed
    self.size = playerBulletSize
    self.dmg = playerDamage
    self.notfiring = true

    self.chargenum = 0
    self.chargerate = 1.125*self.attackspeed
    self.maxcharge = 20

    self.bammo = 12
    self.breload = false
    self.fammomax = 64
    self.fammo = 64
    timer:every(0.5, function() if self.notfiring == true then self.fammo = self.fammo + 6  if self.fammo > self.fammomax then self.fammo = self.fammomax end end end)

    self.buffer = false

    self.rot = 0

    local function Basic_Bullet(dmgmod, homing, strength)
        if self.bammo > 0 then
            area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random(-0.1*self.accuracy, 0.1*self.accuracy), l=self.l, type="basic", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='circle', speed=self.speed,
            dmg=self.dmg+dmgmod, homing=homing, homingstrength=strength})
            self.bammo = self.bammo - 1
        else
            if self.buffer == false then
                if self.breload == false then
                    self.buffer = true
                    self.breload = true
                    timer:after((0.35*self.attackspeed)*3, function() self.bammo = 12 self.breload = false end)
                    self.buffer = false
                end
            end
        end
    end

    local function Water_Bullet(dmgmod, accuracy, range, interval)
        area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random((accuracy*-1)*self.accuracy, accuracy*self.accuracy), l=self.l, type="water", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='line', speed=self.speed, dmg=self.dmg+dmgmod, range=range, interval=interval})
    end

    local function Flame_Bullet(dmgmod, accuracy)
        if self.fammo > 0 then
            area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot+random((accuracy*-1)*self.accuracy, accuracy*self.accuracy), l=self.l, type="flame", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg+dmgmod})
            self.fammo = self.fammo - 1
        else
            self.notfiring = true
        end
    end

    local function Lightning_Bullet()
        if self.chargenum < 5 then
            self.chargenum = self.chargenum + self.chargerate
        end
        if self.chargenum >= 5 then
            self.chargenum = 5
            camera:shake(0.75, 0.25, 20)
        end
        print(self.chargenum)
    end

    local function Lightning_Bullet_release(homing, smites, aoe)
        if self.chargenum >= 5 then
            area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot, l=self.l, type="lightning", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='ghost', speed=self.speed, dmg=self.dmg, homing=homing, homingstrength=10, smites=smites, aoe=aoe})
        end
        self.chargenum = 0
    end

    local function Plant_Bullet(dmgmod)
        area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot, l=self.l, type="plant", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='ghost', speed=self.speed, dmg=self.dmg+dmgmod})
    end

    local function Wall_Bullet(size, hp)
        area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot, l=self.l, type="wall", upgrade = self.upgrade, attackspeed=self.attackspeed, shape='ghost', speed=self.speed, dmg=0, size=size, hp=hp})
    end

    local function charge_Bullet(rate)
        local chargerate = self.chargerate + rate
        if self.chargenum < 10 then
            self.chargenum = self.chargenum + chargerate
        else
            self.chargenum = self.chargenum + chargerate/4
            camera:shake(0.25, 0.5, 15)
        end
        if self.chargenum > self.maxcharge then
            self.chargenum = self.maxcharge
            camera:shake(0.75, 0.25, 20)
        end

        print(self.chargenum)
    end

    local function charge_Bullet_Release(dmgmod)
        if self.chargenum >= 10 then
            area:addGameObject('Bullet', self.X, self.Y, {rot=self.rot, l=self.l, type="charge", upgrade = self.upgrade, size=self.chargenum/10, charge=self.chargenum, attackspeed=self.attackspeed, shape='circle', dmg=self.dmg+dmgmod})
        end
        self.chargenum = 0
    end

    self.basic = {interval=0.35, downfunc = function() Basic_Bullet(0, false, 0) end, name = "WeaponBasic", family = 'basic'}
    self.basic1 = {interval=0.35, downfunc = function() Basic_Bullet(0.5, true, 4) end, name = "WeaponBasic2", family = 'basic'}
    self.basic2 = {interval=0.35, downfunc = function() Basic_Bullet(1, true, 6) end, name = "WeaponBasic3", family = 'basic'}

    self.flame = {interval=0.05, downfunc = function() Flame_Bullet(0, 0.3) end, name = "WeaponFlame", family = 'basic'}
    self.flame2 = {interval=0.05, downfunc = function() Flame_Bullet(0.25, 0.25) end, name = "WeaponFlame2", family = 'basic'}

    self.charge = {interval=0.1, downfunc = function() charge_Bullet(0) end, releasefunc = function() charge_Bullet_Release(0) end, name = "WeaponCharge", family = 'charge'}
    self.charge1 = {interval=0.1, downfunc = function() charge_Bullet(0) end, releasefunc = function() charge_Bullet_Release(0.5) end, name = "WeaponCharge1", family = 'charge'}
    self.charge2 = {interval=0.1, downfunc = function() charge_Bullet(0.75) end, releasefunc = function() charge_Bullet_Release(0) end, name = "WeaponCharge2", family = 'charge'}
    
    self.water = {interval=0.5, downfunc = function() Water_Bullet(0, 0.05, 1, self.water.interval) end, name = "WeaponWater", family = 'water'}
    self.water1 = {interval=0.35, downfunc = function() Water_Bullet(0, 0.1, -1, self.water1.interval) end, name = "WeaponWater2", family = 'water'}
    self.water2 = {interval=0.2, downfunc = function() Water_Bullet(0, 0.15, -1, self.water2.interval) end, name = "WeaponWater3", family = 'water'}

    self.sniper1 = {interval=0.5, downfunc = function() Water_Bullet(2, 0, 3, self.sniper1.interval) end, name = "WeaponWater4", family = 'water'}
    self.sniper2 = {interval=0.75, downfunc = function() Water_Bullet(3, 0, 5, self.sniper2.interval) end, name = "WeaponWater5", family = 'water'}

    self.lightning = {interval=0.2, downfunc = function() Lightning_Bullet() end, releasefunc = function() Lightning_Bullet_release(false, 1, false) end, name = "WeaponLightning", family = 'lightning'}
    self.lightning1 = {interval=0.2, downfunc = function() Lightning_Bullet() end, releasefunc = function() Lightning_Bullet_release(true, 1, false) end, name = "WeaponLightning2", family = 'lightning'}
    self.lightning2 = {interval=0.2, downfunc = function() Lightning_Bullet() end, releasefunc = function() Lightning_Bullet_release(true, 3, false) end, name = "WeaponLightning3", family = 'lightning'}

    self.plant = {interval=0.65, downfunc = function() Plant_Bullet(0) end, name = "WeaponPlant", family = 'plant'}
    self.plant1 = {interval=1, downfunc = function() Plant_Bullet(-0.25) end, name = "WeaponPlant2", family = 'plant'}
    self.plant2 = {interval=1, downfunc = function() Plant_Bullet(0) end, name = "WeaponPlant3", family = 'plant'}
    self.wall1 = {interval=1, downfunc = function() Wall_Bullet(1, 10) end, name = "WeaponWall", family = 'plant'}
    self.wall2 = {interval=1, downfunc = function() Wall_Bullet(1.5, 17.5) end, name = "WeaponWall2", family = 'plant'}



    self.lweapon = self.basic
    self.rweapon = self.charge

    self.lcycle = 0
    self.rcycle = 1
end

function Gun:update(dt)
    self.attackspeed = playerAttackspeed
    self.accuracy = playerAccuracy
    self.speed = playerBulletSpeed
    self.size = playerBulletSize
    self.dmg = playerDamage



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

    --[[if input:pressed('increase_atkspd') then
        self.attackspeed = self.attackspeed - (self.attackspeed / 10)
        print(self.attackspeed)
    end]]--



    if self.l then
        self.upgrade = lupgrade
        self.lcycle = lcycle
        lweapon = self.lweapon
    else
        self.upgrade = rupgrade
        self.rcycle = rcycle
        rweapon = self.rweapon
    end

    if input:pressed('switch_left') then
        self.lcycle = self.lcycle + 1
        if self.lcycle > 4 then self.lcycle = 0 end
    end
    if self.lcycle == 0 then
        if self.upgrade == 1 then
            self.lweapon = self.basic
        elseif self.upgrade == 2 then
            self.lweapon = self.basic1
        elseif self.upgrade == 3 then
            self.lweapon = self.basic2
        elseif self.upgrade == 4 then
            self.lweapon = self.flame
        else
            self.lweapon = self.flame2
        end
    end
    if self.lcycle == 1 then
        if self.upgrade == 1 then
            self.lweapon = self.charge
        elseif self.upgrade == 2 then
            self.lweapon = self.charge1
        else
            self.lweapon = self.charge2
        end
    end
    if self.lcycle == 2 then
        if self.upgrade == 1 then
            self.lweapon = self.water
        elseif self.upgrade == 2 then
            self.lweapon = self.water1
        elseif self.upgrade == 3 then
            self.lweapon = self.water2
        elseif self.upgrade == 4 then
            self.lweapon = self.sniper1
        else
            self.lweapon = self.sniper2
        end
    end
    if self.lcycle == 3 then
        if self.upgrade == 1 then
            self.lweapon = self.lightning
        elseif self.upgrade == 2 then
            self.lweapon = self.lightning1
        else
            self.lweapon = self.lightning2
        end
    end
    if self.lcycle == 4 then
        if self.upgrade == 1 then
            self.lweapon = self.plant
        elseif self.upgrade == 2 then
            self.lweapon = self.plant1
        elseif self.upgrade == 3 then
            self.lweapon = self.plant2
        elseif self.upgrade == 4 then
            self.lweapon = self.wall1
        else
            self.lweapon = self.wall2
        end
    end
    if input:pressed('switch_right') then
        self.rcycle = self.rcycle + 1
        if self.rcycle > 4 then self.rcycle = 0 end
    end
    if self.rcycle == 0 then
        if self.upgrade == 1 then
            self.rweapon = self.basic
        elseif self.upgrade == 2 then
            self.rweapon = self.basic1
        elseif self.upgrade == 3 then
            self.rweapon = self.basic2
        elseif self.upgrade == 4 then
            self.rweapon = self.flame
        else
            self.rweapon = self.flame2
        end
    end
    if self.rcycle == 1 then
        if self.upgrade == 1 then
            self.rweapon = self.charge
        elseif self.upgrade == 2 then
            self.rweapon = self.charge1
        else
            self.rweapon = self.charge2
        end
    end
    if self.rcycle == 2 then
        if self.upgrade == 1 then
            self.rweapon = self.water
        elseif self.upgrade == 2 then
            self.rweapon = self.water1
        elseif self.upgrade == 3 then
            self.rweapon = self.water2
        elseif self.upgrade == 4 then
            self.rweapon = self.sniper1
        else
            self.rweapon = self.sniper2
        end
    end
    if self.rcycle == 3 then
        if self.upgrade == 1 then
            self.rweapon = self.lightning
        elseif self.upgrade == 2 then
            self.rweapon = self.lightning1
        else
            self.rweapon = self.lightning2
        end
    end
    if self.rcycle == 4 then
        if self.upgrade == 1 then
            self.rweapon = self.plant
        elseif self.upgrade == 2 then
            self.rweapon = self.plant1
        elseif self.upgrade == 3 then
            self.rweapon = self.plant2
        elseif self.upgrade == 4 then
            self.rweapon = self.wall1
        else
            self.rweapon = self.wall2
        end
    end

    if self.l then
        if not UiHover then
            if input:pressed('left_click') then
                if self.buffer == false then
                    self.lweapon.downfunc()
                    self.buffer = true
                    self.notfiring = false
                    timer:after(self.lweapon.interval*self.attackspeed, function() self.buffer = false end)
                end
            end
            
            if input:down('left_click', self.lweapon.interval*self.attackspeed) then
                if self.buffer == false then
                self.lweapon.downfunc()
                self.notfiring = false
                end
            end
            if input:released('left_click') then
                if self.lweapon.releasefunc then
                    self.lweapon.releasefunc()
                end
                self.notfiring = true
            end
        end
    else
        if not UiHover then
            if input:pressed('right_click') then
                if self.buffer == false then
                    self.rweapon.downfunc()
                    self.notfiring = false
                    self.buffer = true
                    timer:after(self.rweapon.interval*self.attackspeed, function() self.buffer = false end)
                end
            end
            if input:down('right_click', self.rweapon.interval*self.attackspeed) then
                if self.buffer == false then
                    self.rweapon.downfunc()
                    self.notfiring = false
                end
            end
            if input:released('right_click') then
                if self.rweapon.releasefunc then
                    self.rweapon.releasefunc()
                end
                self.notfiring = true
            end
        end
    end
end

function Gun:draw()
    love.graphics.draw(self.image, self.X, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
    love.graphics.circle('fill', self.X, self.Y, 5)
    self.printx, self.printy = camera:toCameraCoords(0,0)
    if self.l then
        if self.lweapon.name == 'WeaponBasic' or self.lweapon.name == 'WeaponBasic1' or self.lweapon.name == 'WeaponBasic2' then
            love.graphics.print(self.bammo, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            if self.breload == true then
                if self.t == true then
                    self.t1, self.t2 = {m = -20}, {m = -20}
                    timer:tween((0.35*self.attackspeed)*3, self.t1, {m = 20}, 'out-sine')
                    timer:tween((0.35*self.attackspeed)*3, self.t2, {m = 20}, 'out-sine')
                end
                self.t = false
                love.graphics.line(PlayerX-50, PlayerY-self.t1.m, PlayerX-70, PlayerY-self.t2.m)
            else
                self.t = true
                love.graphics.line(PlayerX-50, PlayerY+20-(self.bammo/4)*13, PlayerX-70, PlayerY+20-(self.bammo/4)*13)
            end
        end

        if self.lweapon.family == 'charge' then
            love.graphics.print(self.chargenum, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            love.graphics.line(PlayerX-50, PlayerY+20-self.chargenum*2, PlayerX-70, PlayerY+20-self.chargenum*2)
            love.graphics.line(PlayerX-60, PlayerY, PlayerX-65, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY-20, PlayerX-65, PlayerY-20)
        end

        if self.lweapon.name == 'WeaponFlame' or self.lweapon.name == 'WeaponFlame2' then
            love.graphics.print(self.fammo, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            love.graphics.line(PlayerX-50, PlayerY+20-(self.fammo/8)*5, PlayerX-70, PlayerY+20-(self.fammo/8)*5)
        end

        if self.lweapon.family == 'lightning' then
            love.graphics.print(self.chargenum, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            love.graphics.line(PlayerX-50, PlayerY+20-self.chargenum*8, PlayerX-70, PlayerY+20-self.chargenum*8)
        end

    else

        if self.rweapon.name == 'WeaponBasic' or self.rweapon.name == 'WeaponBasic1' or self.rweapon.name == 'WeaponBasic2' then
            love.graphics.print(self.bammo, PlayerX+45, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            if self.breload == true then
                if self.t == true then
                    self.t1, self.t2 = {m = -20}, {m = -20}
                    timer:tween((0.35*self.attackspeed)*3, self.t1, {m = 20}, 'out-sine')
                    timer:tween((0.35*self.attackspeed)*3, self.t2, {m = 20}, 'out-sine')
                end
                self.t = false
                love.graphics.line(PlayerX+50, PlayerY-self.t1.m, PlayerX+70, PlayerY-self.t2.m)
            else
                self.t = true
                love.graphics.line(PlayerX+50, PlayerY+20-(self.bammo/4)*13, PlayerX+70, PlayerY+20-(self.bammo/4)*13)
            end
        end
        if self.rweapon.family == 'charge' then
            love.graphics.print(self.chargenum, PlayerX+30, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            love.graphics.line(PlayerX+50, PlayerY+20-self.chargenum*2, PlayerX+70, PlayerY+20-self.chargenum*2)
            love.graphics.line(PlayerX+60, PlayerY, PlayerX+65, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY-20, PlayerX+65, PlayerY-20)
        end
        if self.rweapon.name == 'WeaponFlame' or self.rweapon.name == 'WeaponFlame2' then
            love.graphics.print(self.fammo, PlayerX+30, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            love.graphics.line(PlayerX+50, PlayerY+20-(self.fammo/8)*5, PlayerX+70, PlayerY+20-(self.fammo/8)*5)
        end

        if self.rweapon.family == 'lightning' then
            love.graphics.print(self.chargenum, PlayerX+45, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            love.graphics.line(PlayerX+50, PlayerY+20-self.chargenum*8, PlayerX+70, PlayerY+20-self.chargenum*8)
        end
    end
    if self.l then
        love.graphics.print(self.lweapon.name, self.printx*-1, self.printy*-1)
        love.graphics.print(self.upgrade, self.printx*-1, (self.printy-80)*-1)
    else
        love.graphics.print(self.rweapon.name, self.printx*-1, (self.printy-20)*-1)
        love.graphics.print(self.upgrade, self.printx*-1, (self.printy-100)*-1)
    end
end
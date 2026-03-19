Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)
    self.image = love.graphics.newImage("assets/R.png")

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

    local function Basic_Bullet(area, x, y, rot, l, accuracy)
        if self.bammo > 0 then
            area:addGameObject('Bullet', x, y, {rot=rot+random(-0.1*accuracy, 0.1*accuracy), l=l, type="basic", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg})
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

    local function Water_Bullet(area, x, y, rot, l, accuracy)
        area:addGameObject('Bullet', x, y, {rot=rot+random(-0.05*accuracy, 0.05*accuracy), l=l, type="water", attackspeed=self.attackspeed, shape='line', speed=self.speed, dmg=self.dmg})
    end

    local function Flame_Bullet(area, x, y, rot, l, accuracy)
        if self.fammo > 0 then
            area:addGameObject('Bullet', x, y, {rot=rot+random(-0.3*accuracy, 0.3*accuracy), l=l, type="flame", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg})
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

    local function Lightning_Bullet2(area, x, y, rot, l)
        if self.chargenum >= 5 then
            area:addGameObject('Bullet', x, y, {rot=rot, l=l, type="lightning", attackspeed=self.attackspeed, shape='circle', speed=self.speed, dmg=self.dmg})
        end
        self.chargenum = 0
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
    self.lightning = {interval=0.2, downfunc = function() Lightning_Bullet() end, releasefunc = function() Lightning_Bullet2(self.area, self.X, self.Y, self.rot, self.opts.l) end, name = "lightning"}
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

    --[[if input:pressed('increase_atkspd') then
        self.attackspeed = self.attackspeed - (self.attackspeed / 10)
        print(self.attackspeed)
    end]]--

    if input:pressed('switch_left') then
        self.lcycle = self.lcycle + 1
        if self.lcycle > 4 then self.lcycle = 0 end
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
        if self.lcycle == 4 then
            self.lweapon = self.lightning
        end
    end
    if input:pressed('switch_right') then
        self.rcycle = self.rcycle + 1
        if self.rcycle > 4 then self.rcycle = 0 end
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
        if self.rcycle == 4 then
            self.rweapon = self.lightning
        end
    end

    if self.l then
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
    else

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

function Gun:draw()
    love.graphics.draw(self.image, self.X, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
    love.graphics.circle('fill', self.X, self.Y, 5)
    self.printx, self.printy = camera:toCameraCoords(0,0)
    if self.l then
        if self.lweapon.name == 'basic' then
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

        if self.lweapon.name == 'charge' then
            love.graphics.print(self.chargenum, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            love.graphics.line(PlayerX-50, PlayerY+20-self.chargenum*2, PlayerX-70, PlayerY+20-self.chargenum*2)
            love.graphics.line(PlayerX-60, PlayerY, PlayerX-65, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY-20, PlayerX-65, PlayerY-20)
        end

        if self.lweapon.name == 'flame' then
            love.graphics.print(self.fammo, PlayerX-45, PlayerY)
            love.graphics.line(PlayerX-60, PlayerY+20, PlayerX-60, PlayerY-20)
            love.graphics.line(PlayerX-50, PlayerY+20-(self.fammo/8)*5, PlayerX-70, PlayerY+20-(self.fammo/8)*5)
        end

    else

        if self.rweapon.name == 'basic' then
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
        if self.rweapon.name == 'charge' then
            love.graphics.print(self.chargenum, PlayerX+30, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            love.graphics.line(PlayerX+50, PlayerY+20-self.chargenum*2, PlayerX+70, PlayerY+20-self.chargenum*2)
            love.graphics.line(PlayerX+60, PlayerY, PlayerX+65, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY-20, PlayerX+65, PlayerY-20)
        end
        if self.rweapon.name == 'flame' then
            love.graphics.print(self.fammo, PlayerX+30, PlayerY)
            love.graphics.line(PlayerX+60, PlayerY+20, PlayerX+60, PlayerY-20)
            love.graphics.line(PlayerX+50, PlayerY+20-(self.fammo/8)*5, PlayerX+70, PlayerY+20-(self.fammo/8)*5)
        end
    end
    if self.l then
        love.graphics.print(self.lweapon.name, self.printx*-1, self.printy*-1)
    else
        love.graphics.print(self.rweapon.name, self.printx*-1, (self.printy-20)*-1)
    end
end
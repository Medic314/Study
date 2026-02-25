Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)

    self.opts = opts

    if self.opts.l then self.D = -20 end
    if not self.opts.l then self.D = 20 end

    self.area = area
    self.X = PlayerX + self.D
    self.Y = PlayerY
    Charge = 0
    ChargeRate = 1.125
    MaxCharge = 20

    self.rot = 0

    function Gun:Basic_Bullet(area, x, y, rot, l)
        area:addGameObject('Bullet', x, y, {rot=rot, l=l, type="basic"})
    end

    function Gun:Flame_Bullet(area, x, y, rot, l)
        area:addGameObject('Bullet', x, y, {rot=rot+random(-0.3, 0.3), l=l, type="flame"})
    end

    function Gun:Charge_Bullet()
        if Charge < 10 then
            Charge = Charge + ChargeRate
        else
            Charge = Charge + ChargeRate/4
            camera:shake(0.25, 0.5, 15)
        end
        if Charge > MaxCharge then
            Charge = MaxCharge
            camera:shake(0.75, 0.25, 20)
        end

        print(Charge)
    end

    function Gun:Charge_Bullet_Release(area, x, y, rot, l)
        if Charge >= 10 then
            area:addGameObject('Bullet', x, y, {rot=rot, l=l, type="charge", size=Charge/10})
        end
        Charge = 0
    end

    self.basic = {interval=0.25, downfunc = function() Gun:Basic_Bullet(self.area, self.X, self.Y, self.rot, self.opts.l) end}
    self.flame = {interval=0.025, downfunc = function() Gun:Flame_Bullet(self.area, self.X, self.Y, self.rot, self.opts.l) end}
    self.charge = {interval=0.1, downfunc = function() Gun:Charge_Bullet() end, releasefunc = function() Gun:Charge_Bullet_Release(self.area, self.X, self.Y, self.rot, self.opts.l) end}

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

    if input:pressed('switch_left') then
        self.lcycle = self.lcycle + 1
        if self.lcycle > 2 then self.lcycle = 0 end
        if self.lcycle == 0 then
            self.lweapon = self.basic
        end
        if self.lcycle == 1 then
            self.lweapon = self.charge
        end
        if self.lcycle == 2 then
            self.lweapon = self.flame
        end
    end
    if input:pressed('switch_right') then
        self.rcycle = self.rcycle + 1
        if self.rcycle > 2 then self.rcycle = 0 end
        if self.rcycle == 0 then
            self.rweapon = self.basic
        end
        if self.rcycle == 1 then
            self.rweapon = self.charge
        end
        if self.rcycle == 2 then
            self.rweapon = self.flame
        end
    end

    if self.l then
        if input:down('left_click', self.lweapon.interval) then
            self.lweapon.downfunc()
        end
        if input:released('left_click') then
            if self.lweapon.releasefunc then
                self.lweapon.releasefunc()
            end
        end
    else
        if input:down('right_click', self.rweapon.interval) then
            self.rweapon.downfunc()
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
end
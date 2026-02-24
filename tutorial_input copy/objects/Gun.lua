Gun = GameObject:extend()

function Gun:new(area, x, y, opts)
    Gun.super.new(self, area, x, y, opts)
    self.area = area
    self.X = x
    self.Y = y
    self.opts = opts
    self.charge = 0

    if self.opts.l then self.D = -20 end
    if not self.opts.l then self.D = 20 end

    function Gun:Basic_Bullet(area, rot, l)
        area:addGameObject('Bullet', PlayerX, PlayerY, {rot=rot, l=l, type="basic"})
    end

    function Gun:Charge_Bullet(charge)
        if charge < 10 then
                    charge = charge + 2
                else
                    charge = charge + 0.25
                end
                if charge > 15 then
                    charge = 15
                end

                print(charge)
    end

    function Gun:Charge_Bullet_Release(area, rot, charge, l)
        if charge >= 10 then
            area:addGameObject('Bullet', PlayerX, PlayerY, {rot=rot, l=l, type="charge", size=charge/10})
        end
        charge = 0
    end

    self.basic = {interval=0.25, downfunc=Gun:Basic_Bullet(self.area, self.opts.l)}
    self.charge = {interval=0.1, downfunc=Gun:Charge_Bullet(self.charge), releasefunc=Gun:Charge_Bullet_Release(self.area, self.charge, self.opts.l)}

    self.lweapon = self.basic
    self.rweapon = self.charge
end

function Gun:update(dt)
    self.X, self.Y = PlayerX + self.D , PlayerY
    self.CX, self.CY = camera:toCameraCoords(self.X, self.Y)
    self.CX = (self.CX + self.D)*sx
    self.CY = self.CY*sx
    self.MX, self.MY = love.mouse.getPosition()
    self.MX, self.MY = self.MX, self.MY

    camera:toCameraCoords(self.X, self.Y)
    local dx = self.MX - self.CX
    local dy = self.MY - self.CY
    self.rot = math.pi / 2 - math.atan(dx / dy)
    if dy < 0 then self.rot = self.rot + math.pi end

    if self.l then
        if input:down('left_click', self.lweapon.interval) then
            self.lweapon.downfunc()
        end
    else
        if input:down('right_click', self.rweapon.interval) then
            self.rweapon.downfunc()
        end
        if input:released('right_click') then
            self.rweapon.releasefunc()
        end
    end

end

function Gun:draw()
    wiz = love.graphics.newImage("R.png")
    love.graphics.draw(wiz, self.X, self.Y, self.rot, 0.25, 0.25, (256/2)/4.5, (256/2))
end
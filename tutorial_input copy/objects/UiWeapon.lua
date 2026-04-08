UiWeapon = GameObject:extend()

function UiWeapon:new(area, x, y, opts)
    UiWeapon.super.new(self, area, x, y, opts)
    self.layer = 'ui'

    self.x = x
    self.y = y
    self.drop = true
    self.image = love.graphics.newImage("assets/weaponslotdev.png")
    self.weaponlist = love.graphics.newImage("assets/weaponlistdev.png")
    self.tab = 1

    local imgW, imgH = self.image:getDimensions()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.IW = imgW
    self.IH = imgH
    
    self.max_frames = 5
    self.quads = {}
    local imgW2, imgH2 = self.weaponlist:getDimensions()
    self.IW2 = imgW2 / self.max_frames
    self.IH2 = imgH2
    self.frame = 1
    self.frame2 = 1

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW2 * (i-1), 0, self.IW2, self.IH2, imgW2, imgH2)
        print(self.quads[i], self.IW2 * (i-1), 0, self.IW2, self.IH2, imgW2, imgH2)
    end

    self.openPos, self.closePos = 3, 1
    self.drawpos = {m = 3}

    self.x, self.y = ((self.printx-gw))*-1, ((self.printy-gh))*-1
end

function UiWeapon:update(dt)
    if lweapon.family == 'basic' then
        self.frame = 1
    end
    if lweapon.family == 'charge' then
        self.frame = 2
    end
    if lweapon.family == 'water' then
        self.frame = 3
    end
    if lweapon.family == 'lightning' then
        self.frame = 4
    end
    if lweapon.family == 'plant' then
        self.frame = 5
    end
    if rweapon.family == 'basic' then
        self.frame2 = 1
    end
    if rweapon.family == 'charge' then
        self.frame2 = 2
    end
    if rweapon.family == 'water' then
        self.frame2 = 3
    end
    if rweapon.family == 'lightning' then
        self.frame2 = 4
    end
    if rweapon.family == 'plant' then
        self.frame2 = 5
    end


    local imgW, imgH = self.image:getDimensions()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.IW = imgW
    self.IH = imgH
    self.x, self.y = ((self.printx-gw))*-1, ((self.printy-gh))*-1
    if self.drop then
        self.colliders = self.area.world:queryRectangleArea(self.x-self.IW*1.1, self.y-(self.IH/3)-20, self.IW, self.IH, {'Mouse'})
    else
        self.colliders = self.area.world:queryRectangleArea(self.x-self.IW*1.1, self.y-(self.IH), self.IW, self.IH, {'Mouse'})
    end
    if self.colliders[1] then
        UiHover = true
    else
        UiHover = false
    end
    if UiHover then
        if self.drop then
            self.colliderbuttonl = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+30, (self.y-(self.IH/3)-20)+40, 100, 100, {'Mouse'})
            self.colliderbuttonr = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+180, (self.y-(self.IH/3)-20)+40, 100, 100, {'Mouse'})
        else
            self.colliderbuttonl = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+30, (self.y-(self.IH))+40, 100, 100, {'Mouse'})
            self.colliderbuttonr = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+180, (self.y-(self.IH))+40, 100, 100, {'Mouse'})

            if self.tab == 1 then
                if lupgrade == 1 then
                    self.colliderbuttonul1 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+10, (self.y-(self.IH))+185, 135, 100, {'Mouse'})
                    self.colliderbuttonur1 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+153, (self.y-(self.IH))+185, 135, 100, {'Mouse'})
                end
                if lupgrade == 2 then
                    self.colliderbuttonul2 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+10, (self.y-(self.IH))+295, 135, 100, {'Mouse'})
                end
                if lupgrade == 4 then
                    self.colliderbuttonur2 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+153, (self.y-(self.IH))+295, 135, 100, {'Mouse'})
                end
                if self.colliderbuttonul1 then
                    if self.colliderbuttonul1[1] then
                        if input:pressed('left_click') then
                            lupgrade = 2
                        end
                    end
                end
                if self.colliderbuttonul2 then
                    if self.colliderbuttonul2[1] then
                        if input:pressed('left_click') then
                            lupgrade = 3
                        end
                    end
                end
                if self.colliderbuttonur1 then
                    if self.colliderbuttonur1[1] then
                        if input:pressed('left_click') then
                            lupgrade = 4
                        end
                    end
                end
                if self.colliderbuttonur2 then
                    if self.colliderbuttonur2[1] then
                        if input:pressed('left_click') then
                            lupgrade = 5
                        end
                    end
                end
            else
                if rupgrade == 1 then
                    self.colliderbuttonul1 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+10, (self.y-(self.IH))+185, 135, 100, {'Mouse'})
                    self.colliderbuttonur1 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+153, (self.y-(self.IH))+185, 135, 100, {'Mouse'})
                end
                if rupgrade == 2 then
                    self.colliderbuttonul2 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+10, (self.y-(self.IH))+295, 135, 100, {'Mouse'})
                end
                if rupgrade == 4 then
                    self.colliderbuttonur2 = self.area.world:queryRectangleArea((self.x-self.IW*1.1)+153, (self.y-(self.IH))+295, 135, 100, {'Mouse'})
                end
                if self.colliderbuttonul1 then
                    if self.colliderbuttonul1[1] then
                        if input:pressed('left_click') then
                            rupgrade = 2
                        end
                    end
                end
                if self.colliderbuttonul2 then
                    if self.colliderbuttonul2[1] then
                        if input:pressed('left_click') then
                            rupgrade = 3
                        end
                    end
                end
                if self.colliderbuttonur1 then
                    if self.colliderbuttonur1[1] then
                        if input:pressed('left_click') then
                            rupgrade = 4
                        end
                    end
                end
                if self.colliderbuttonur2 then
                    if self.colliderbuttonur2[1] then
                        if input:pressed('left_click') then
                            rupgrade = 5
                        end
                    end
                end
            end
        end

        if self.colliderbuttonl[1] then
            if input:pressed('left_click') then
                if self.drop then
                    self.drop = false
                    self.tab = 1
                    timer:tween(0.2, self.drawpos, {m = self.closePos}, 'out-sine')
                    timer:after(0.2, function() self.drawpos.m = self.closePos end)
                else
                    if self.tab == 1 then
                        self.drop = true
                        timer:tween(0.2, self.drawpos, {m = self.openPos}, 'out-sine')
                        timer:after(0.2, function() self.drawpos.m = self.openPos end)
                    else
                        self.tab = 1
                    end
                end
            end
        end
        if self.colliderbuttonr[1] then
            if input:pressed('left_click') then
                if self.drop then
                    self.drop = false
                    self.tab = 2
                    timer:tween(0.2, self.drawpos, {m = self.closePos}, 'out-sine')
                    timer:after(0.2, function() self.drawpos.m = self.closePos end)
                else
                    if self.tab == 2 then
                        self.drop = true
                        timer:tween(0.2, self.drawpos, {m = self.openPos}, 'out-sine')
                        timer:after(0.2, function() self.drawpos.m = self.openPos end)
                    else
                        self.tab = 2
                    end
                end
            end
        end
    end
end

function UiWeapon:draw()
    if self.drop then
        love.graphics.draw(self.image, self.x-self.IW*1.1, self.y-(self.IH/self.drawpos.m)-20, 0, 1, 1)
        love.graphics.draw(self.weaponlist, self.quads[self.frame], (self.x-self.IW*1.1)+30, (self.y-(self.IH/3)-20)+40, 0, 1.5, 1.5)
        love.graphics.draw(self.weaponlist, self.quads[self.frame2], (self.x-self.IW*1.1)+180, (self.y-(self.IH/3)-20)+40, 0, 1.5, 1.5)
    else
        love.graphics.draw(self.image, self.x-self.IW*1.1, self.y-(self.IH/self.drawpos.m), 0, 1, 1)
        love.graphics.draw(self.weaponlist, self.quads[self.frame], (self.x-self.IW*1.1)+30, (self.y-(self.IH))+40, 0, 1.5, 1.5)
        love.graphics.draw(self.weaponlist, self.quads[self.frame2], (self.x-self.IW*1.1)+180, (self.y-(self.IH))+40, 0, 1.5, 1.5)
    end
end

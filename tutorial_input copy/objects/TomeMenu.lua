TomeMenu = GameObject:extend()

function TomeMenu:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
    UiHover = true
    movelock = true
end

function TomeMenu:update(dt)
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1

    
    self.tfunc1 = EquipedTome.TopPath.Up1
    self.tfunc2 = EquipedTome.TopPath.Up2
    self.tfunc3 = EquipedTome.TopPath.Up3

    self.mfunc1 = EquipedTome.MidPath.Up1
    self.mfunc2 = EquipedTome.MidPath.Up2
    self.mfunc3 = EquipedTome.MidPath.Up3

    self.bfunc1 = EquipedTome.BotPath.Up1
    self.bfunc2 = EquipedTome.BotPath.Up2
    self.bfunc3 = EquipedTome.BotPath.Up3

    if not tomemenu then
        UiHover = false
        self.dead = true
        movelock = false
    end
    local bs = 100
    local spacing = 200
    local spacingy = 120
    local sx = self.x - (900/3)+50
    local sy = self.y - spacing

    self.colliders = {}
    for i = 1, 9 do
        local row = math.floor((i-1)/3)
        local col = (i-1) % 3
        local bx = sx + col * spacing
        local by = sy + row * spacingy
        self.colliders[i] = self.area.world:queryRectangleArea(bx, by, bs, bs, {'Mouse'})
    end

    if input:pressed('left_click') then
        for i = 1, 3 do
            if self.colliders[i] and self.colliders[i][1] then
                if self['tfunc' .. i] then
                    if current_upgrades[1] < 4 then
                        if current_upgrades[1]+1 == i then
                            if upgrade_points > 0 then
                                current_upgrades[1] = current_upgrades[1] + 1
                                self['tfunc' .. i]()
                                upgrade_points = upgrade_points - 1
                            end
                        end
                    end
                end
                break
            end
        end
        for i = 1, 3 do
            if self.colliders[i+3] and self.colliders[i+3][1] then
                if self['tfunc' .. i] then
                    if current_upgrades[2] < 4 then
                        if current_upgrades[2]+1 == i then
                            if upgrade_points > 0 then
                                current_upgrades[2] = current_upgrades[2] + 1
                                self['mfunc' .. i]()
                                upgrade_points = upgrade_points - 1
                            end
                        end
                    end
                end
                break
            end
        end
        for i = 1, 3 do
            if self.colliders[i+6] and self.colliders[i+6][1] then
                if self['tfunc' .. i] then
                    if current_upgrades[3] < 4 then
                        if current_upgrades[3]+1 == i then
                            if upgrade_points > 0 then
                                current_upgrades[3] = current_upgrades[3] + 1
                                self['bfunc' .. i]()
                                upgrade_points = upgrade_points - 1
                            end
                        end
                    end
                end
                break
            end
        end
        print(current_upgrades[1], current_upgrades[2], current_upgrades[3])
    end
end

function TomeMenu:draw()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1

    local bs = 100
    local spacing = 200
    local spacingy = 120
    local sx = self.x - (900/3)+50
    local sy = self.y - spacing

    for i = 1, 9 do
        local row = math.floor((i-1)/3)
        local col = (i-1) % 3
        local bx = sx + col * spacing
        local by = sy + row * spacingy
        love.graphics.rectangle('line', bx, by, bs, bs)
        love.graphics.print('Button ' .. i, bx + 10, by + 20)
    end

    self.x, self.y = self.x-gw/2, self.y-gh/2
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, gw, gh)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('TOME TOME TOME TOME TOME', self.x, self.y+gh/2-100 - 20, gw, 'center')
end

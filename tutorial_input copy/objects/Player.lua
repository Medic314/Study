Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.X = x
    self.Y = y
    self.A = 300
    self.scale = 1.25
    self.W, self.H = 76/1.25, 122/1.25
    self.W, self.H = self.W/self.scale, self.H/self.scale
    self.IW, self.IH = 76/self.scale, 122/self.scale
    self.DX, self.DY = 0, 0
    self.dead = false

    self.collider = self.area.world:newRectangleCollider(self.X, self.Y, self.W, self.H)
    self.collider:setCollisionClass('Player')
    --self.collider:setType('static')
    self.collider:setObject(self)

    self.buffer = false
    self.hp = 6

    bullets = {}
end

function Player:update(dt)
    self.X, self.Y = PlayerX, PlayerY
    Player.super.update(self, dt)

    if input:pressed('one') then resize(1) end
    if input:pressed('two') then resize(2) end
    if input:pressed('three') then resize(3) end

    self.LX, self.LY = self.X, self.Y

    if input:down('up') then self.Y = self.Y - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain'}) if self.colliders[1] then self.Y = self.Y + self.A*dt end end
    if input:down('left') then self.X = self.X - self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain'}) if self.colliders[1] then self.X = self.X + self.A*dt end end
    if input:down('down') then self.Y = self.Y + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain'}) if self.colliders[1] then self.Y = self.Y - self.A*dt end end
    if input:down('right') then self.X = self.X + self.A*dt self.colliders = self.area.world:queryRectangleArea(self.X-((self.W)/2), self.Y-((self.H)/2), self.W, self.H, {'Terrain'}) if self.colliders[1] then self.X = self.X - self.A*dt end end

    self.DfX, self.DfY = self.X - self.LX, self.Y - self.LY

    if not input:down('directional_input') then
        self.DX = self.DX - (self.DX/50)
        self.DY = self.DY - (self.DY/50)

        if math.abs(self.DX) < 0.5 then self.DX = 0 end
        if math.abs(self.DY) < 0.5 then self.DY = 0 end
    end

    self.X = self.X + self.DX
    self.Y = self.Y + self.DY

    for i=1, #bullets do
            bullets[i]:update(dt)
    end

    --[[self.colliders = self.area.world:queryRectangleArea(self.X-((self.W/1.25)/2), self.Y-((self.H/1.25)/2), self.W/1.25, self.H/1.25, {'Terrain'})
    if self.colliders[1] then
        self.X, self.Y = self.X - self.DfX, self.Y - self.DfY
    end]]--

    PlayerX, PlayerY = self.X, self.Y
    self.collider:setPosition(self.X, self.Y)

    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)      
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Enemy' then
            if self.buffer == false then
                if not collider_2.phase then
                    print("DMG")
                    self.hp = self.hp - 1
                    self.buffer = true
                    timer:after(1, function() self.buffer = false end)
                end
            end
        end    
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Enemy Bullet' then
            if self.buffer == false then
                print("DMG")
                --self.hp = self.hp - collider_2.damage
                self.hp = self.hp - 1
                self.buffer = true
                timer:after(1, function() self.buffer = false end)
            end
        end    
    end)

    if self.hp <= 0 then
        gotoRoom("Menu")
    end
end

function Player:draw()
    local iframes = 0
    iframes = iframes + 1
    if iframes == 3 then iframes = iframes - 0 end

    for i=1, #bullets do
            bullets[i]:draw()
    end
    local wiz = love.graphics.newImage("assets/evil_wizard.png")
    if self.buffer == true and iframes == 0 then
        love.graphics.draw(wiz, self.X-self.IW/2, self.Y-self.IH/2, 0, self.IW/254, self.IH/411)
    end
    if self.buffer == false then
        love.graphics.draw(wiz, self.X-self.IW/2, self.Y-self.IH/2, 0, self.IW/254, self.IH/411)
    end

    self.printx, self.printy = camera:toCameraCoords(0,0)
        love.graphics.print(self.hp, self.printx*-1, (self.printy-40)*-1)
        love.graphics.print(string.format("Buffer: %s", tostring(self.buffer)), self.printx*-1, (self.printy-60)*-1)
end
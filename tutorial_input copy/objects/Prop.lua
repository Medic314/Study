Prop = GameObject:extend()

function Prop:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'foreground'
    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.ox, self.oy = self.x, self.y
    self.r = opts.r or nil
    self.destructable = opts.destructable or true
    self.hp = opts.hp or 10
    self.item = opts.item or nil

    self.type = opts.type

    self.buffer = false

    if self.type == "chest" then
        self.hits = 3
        self.firstopen = false
        self.image = ST['ChestUp']
    end


    local vert1x, vert1y = self.x, self.y
    local vert2x, vert2y = self.x+self.w, self.y
    local vert3x, vert3y = self.x, self.y+self.h
    local vert4x, vert4y = self.x+self.w, self.y+self.h

    local function rotate(lx, ly, ox, oy, r)
        local rx=ox + (lx-ox)*math.cos(r)-(ly-oy)*math.sin(r)
        local ry=oy +(lx-ox)*math.sin(r)+(ly-oy)*math.cos(r)
        return rx, ry
    end
    if self.r then
        vert1x, vert1y = rotate(vert1x, vert1y, self.ox, self.oy, self.r)
        vert2x, vert2y = rotate(vert2x, vert2y, self.ox, self.oy, self.r)
        vert3x, vert3y = rotate(vert3x, vert3y, self.ox, self.oy, self.r)
        vert4x, vert4y = rotate(vert4x, vert4y, self.ox, self.oy, self.r)
    end

    self.collider = self.area.world:newPolygonCollider({vert1x, vert1y, vert2x, vert2y, vert3x, vert3y, vert4x, vert4y})
    self.collider:setCollisionClass("TerrainP")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Prop:update(dt)
    if self.type == "vinewall" then
        if Wallkill then
            Wallkill = false
            Wallup = false
            self.dead = true
        else
            Wallup = true
        end
    end

    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'TerrainP' and collider_2.collision_class == 'Friendly Bullet' then
            if collider_2.bullettype == 'water' then
                if not collider_1.whit then
                    self.hp = self.hp - collider_2.damage/2
                    print("WHit")
                    collider_1.whit = true
                    timer:after(collider_2.timer, function() collider_1.whit = false end)
                    if self.type == "chest" then
                        self.hits = self.hits - 1
                    end
                end
            elseif collider_2.bullettype == 'basic' and collider_2.upgrade == 3 then
                contact:setEnabled(false)
                self.hp = self.hp - collider_2.damage/2
                print("Hit")
                if not collider_1.on_fire then
                    collider_1.on_fire = true
                    timer:after(4, function() collider_1.on_fire = false end)
                end
                if self.type == "chest" then
                    self.hits = self.hits - 1
                end
            else
                if self.type == "chest" then
                    self.hits = self.hits - 1
                end
                contact:setEnabled(false)
                self.hp = self.hp - collider_2.damage/2
                print("Hit")
            end  
        end
        if collider_1.collision_class == 'TerrainP' and collider_2.collision_class == 'Enemy Bullet' then
            contact:setEnabled(false)
            self.hp = self.hp - collider_2.damage*2
            print("Hit")
        end
        if collider_1.collision_class == 'TerrainP' and collider_2.collision_class == 'Enemy' then
            if self.buffer == false then
                contact:setEnabled(false)
                self.hp = self.hp - 1
                print("Hit")
                self.buffer = true
                timer:after(0.5, function() self.buffer = false end)
            end
        end
    end)
    if self.destructable then
        if self.hp <= 0 then
            if self.type == "vinewall" then
                Wallup = false
            end
            self.dead = true
        end
    end
    if self.type == "chest" then
        if self.hits <= 0 then
            self.image = ST['ChestDown']
            self.h = 30
            if not self.firstopen then
                self.firstopen = true
                local list = IT['Q1Roll']
                local item = list[math.random(#list)]
                if self.item then
                    self.area:addGameObject('Item', self.x, self.y, {type=self.item})
                else
                    self.area:addGameObject('Item', self.x, self.y, {type=item})
                end
            end
        end
    end
end

function Prop:draw()
    if self.type == 'chest' then
        love.graphics.draw(self.image, self.x, self.y-45, 0, 2, 2)
        if self.chestdown then
            love.graphics.draw(self.image, self.x, self.y-70, 0, 2, 2)
        end
    else
        love.graphics.print(self.hp, self.x, self.y)
    end
end
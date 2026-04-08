Prop = GameObject:extend()

function Prop:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.ox, self.oy = self.x, self.y
    self.r = opts.r or nil
    self.destructable = opts.destructable or true
    self.hp = opts.hp or 10

    self.buffer = false


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

    if Wallkill then
        Wallkill = false
        Wallup = false
        self.dead = true
    else
        Wallup = true
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
                end
            elseif collider_2.bullettype == 'basic' and collider_2.upgrade == 3 then
                contact:setEnabled(false)
                self.hp = self.hp - collider_2.damage/2
                print("Hit")
                if not collider_1.on_fire then
                    collider_1.on_fire = true
                    timer:after(4, function() collider_1.on_fire = false end)
                end
            else
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

    if self.hp <= 0 then
        Wallup = false
        self.dead = true
    end
end

function Prop:draw()
    love.graphics.print(self.hp, self.x, self.y)
end
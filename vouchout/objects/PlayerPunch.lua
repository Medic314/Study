PlayerPunch = GameObject:extend()

function PlayerPunch:new(area, x, y, opts)
    PlayerPunch.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = x+1000
    self.y = y+1000
    self.type = opts.type
    self.damage = opts.damage or 25
    self.w = 50
    self.h = 50

    self.collider = self.area.world:newRectangleCollider(self.x-(self.w/2), self.y, self.w, self.h)
    self.collider:setCollisionClass('PlayerPunch')
    self.collider:setObject(self)
    self.collider.type = self.type
    self.collider.damage = self.damage
    self.x = x
    self.y = y
end

function PlayerPunch:update(dt)
    self.collider:setPosition(self.x, self.y)
    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'PlayerPunch' and collider_2.collision_class == 'Enemy' then
            self.dead = true
        end
    end)
end

function PlayerPunch:draw()

end
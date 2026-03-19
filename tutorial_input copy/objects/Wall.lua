Wall = GameObject:extend()

function Wall:new(area, x, y, opts)
    Wall.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.door = opts.door or false

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass("Terrain")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Wall:update(dt)
    if self.door then
        if DoorDestroy then
            timer:after(0.1, function() DoorDestroy = false end)
            self.dead = true
        end
    end
end

function Wall:draw()

end
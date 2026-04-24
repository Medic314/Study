Mouse = GameObject:extend()

function Mouse:new(area, x, y, opts)
    Mouse.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.layer = 'menu'

    self.collider = self.area.world:newCircleCollider(self.x, self.y, 2)
    self.collider:setCollisionClass("Mouse")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Mouse:update(dt)
    local MX, MY = love.mouse.getPosition() 
    MX, MY = camera:toWorldCoords(MX/sx, MY/sy)
    self.x, self.y = MX, MY
    self.collider:setPosition(self.x, self.y)
end

function Mouse:draw()

end

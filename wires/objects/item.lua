Item = GameObject:extend()

function Item:new(area, x, y, opts)
    Item.super.new(self, area, x, y, opts)
    self.layer = 'foregorund'
    self.w = opts.w or 10
    self.h = opts.h or 10
    self.x = x
    self.y = y
    self.x, self.y = self.x - (self.x%tile), self.y - (self.y%tile)
end

function Item:update(dt)
    local tx = (self.x / tile) + (#tiles / 2)
    local ty = (self.y / tile) + (#tiles / 2)
end

function Item:draw()
    
end
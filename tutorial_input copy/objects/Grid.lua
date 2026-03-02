Grid = GameObject:extend()

function Grid:new(area, x, y, opts)
    Grid.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
end

function Grid:update(dt)
    
end

function Grid:draw()
    grid = love.graphics.newImage("grid.png")
    ---love.graphics.draw(grid, self.x, self.y)
end
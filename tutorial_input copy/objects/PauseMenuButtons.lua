PauseMenuButtons = GameObject:extend()

function PauseMenuButtons:new(area, x, y, opts)
    PauseMenuButtons.super.new(self, area, x, y, opts)
    self.layer = 'menu2'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2)+100)*-1, ((self.printy-gh/2)+75)*-1
end

function PauseMenuButtons:update(dt)
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2)+100)*-1, ((self.printy-gh/2)+75)*-1
    self.colliderbutton = self.area.world:queryRectangleArea(self.x, self.y, 200, 100, {'Mouse'})
    self.colliderbutton2 = self.area.world:queryRectangleArea(self.x, self.y+150, 200, 100, {'Mouse'})
    if input:pressed('left_click') then
        if self.colliderbutton[1] then
            paused = not paused
        end
        if self.colliderbutton2[1] then
            gotoRoom('Menu')
            paused = not paused
        end
    end
    if not paused then
        self.dead = true
    end
end

function PauseMenuButtons:draw()
    love.graphics.rectangle('line', self.x, self.y, 200, 100)
    love.graphics.rectangle('line', self.x, self.y+150, 200, 100)
end

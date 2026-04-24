Itemmenu = GameObject:extend()

function Itemmenu:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.func = opts.func
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
    UiHover = true
    movelock = true
end

function Itemmenu:update(dt)
    if not itemmenu then
        UiHover = false
        self.dead = true
        movelock = false
    end
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1

    self.colliderbutton = self.area.world:queryRectangleArea(self.x-300, self.y, 100, 100, {'Mouse'})
    self.colliderbutton2 = self.area.world:queryRectangleArea(self.x+200, self.y, 100, 100, {'Mouse'})
    if input:pressed('left_click') then
        if self.colliderbutton2[1] then
            upgrade_points = upgrade_points + 1
            timer:after(0.001, function() itemmenu = not itemmenu end)
        end
        if self.colliderbutton[1] then
            self.func()
            timer:after(0.001, function() itemmenu = not itemmenu end)
        end
    end
end

function Itemmenu:draw()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    
    love.graphics.rectangle('line', self.x-300, self.y, 100, 100)
    love.graphics.rectangle('line', self.x+200, self.y, 100, 100)

    love.graphics.print('Upgrade', self.x-250, self.y+20)
    love.graphics.print('Consume', self.x+250, self.y+20)
    
    self.x, self.y = self.x-gw/2, self.y-gh/2
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, gw, gh)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('THIS IS WHERE YOU CHOOSE WHAT TO DO!!! WITH THE ITEM!!! THAT YOU JUST PICKED UP!!!', self.x, self.y+gh/2-100 - 20, gw, 'center')
end

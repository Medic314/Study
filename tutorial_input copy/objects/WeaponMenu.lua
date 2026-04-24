Weaponmenu = GameObject:extend()

function Weaponmenu:new(area, x, y, opts)
    Prop.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.func1 = opts.func1
    self.func2 = opts.func2
    self.lock = opts.lock or false
    print(self.lock)

    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    self.x, self.y = self.x-gw/2, self.y-gh/2
    UiHover = true
    movelock = true
end

function Weaponmenu:update(dt)
    if not weaponmenu then
        UiHover = false
        self.dead = true
        movelock = false
    end
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    if self.lock then
        if self.lock == 'r' then
            self.colliderbutton = self.area.world:queryRectangleArea(self.x-300, self.y, 100, 100, {'Mouse'})
        else
            self.colliderbutton2 = self.area.world:queryRectangleArea(self.x+200, self.y, 100, 100, {'Mouse'})
        end
    else
        self.colliderbutton = self.area.world:queryRectangleArea(self.x-300, self.y, 100, 100, {'Mouse'})
        self.colliderbutton2 = self.area.world:queryRectangleArea(self.x+200, self.y, 100, 100, {'Mouse'})
    end

    if input:pressed('left_click') then
        if self.colliderbutton then
            if self.colliderbutton[1] then
                self.func1()
                timer:after(0.001, function() weaponmenu = not weaponmenu end)
            end
        end
        if self.colliderbutton2 then
            if self.colliderbutton2[1] then
                self.func2()
                timer:after(0.001, function() weaponmenu = not weaponmenu end)
            end
        end
    end
end

function Weaponmenu:draw()
    self.printx, self.printy = camera:toCameraCoords(0,0)
    self.x, self.y = ((self.printx-gw/2))*-1, ((self.printy-gh/2))*-1
    
    love.graphics.rectangle('line', self.x-300, self.y, 100, 100)
    love.graphics.rectangle('line', self.x+200, self.y, 100, 100)
    if self.lock then
        if self.lock == 'r' then
            love.graphics.print('REPLACE', self.x-250, self.y+20)
            love.graphics.print('LOCKED', self.x+250, self.y+20)
        else
            love.graphics.print('REPLACE', self.x+250, self.y+20)
            love.graphics.print('LOCKED', self.x-250, self.y+20)
        end
    else
        love.graphics.print('REPLACE', self.x-250, self.y+20)
        love.graphics.print('REPLACE', self.x+250, self.y+20)
    end
    
    self.x, self.y = self.x-gw/2, self.y-gh/2
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, gw, gh)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('THIS IS WHERE YOU CHOOSE WHAT TO DO!!! WITH THE WEAPON!!! THAT YOU JUST PICKED UP!!!', self.x, self.y+gh/2-100 - 20, gw, 'center')
end

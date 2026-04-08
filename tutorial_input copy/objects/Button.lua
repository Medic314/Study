Button = GameObject:extend()

function Button:new(area, x, y, opts)
    Button.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.x = (gw/2)-(300/2)
    self.y = (gh/2)-(300/2)
end

function Button:update(dt)
    self.x = (gw/2)-(300/2)
    self.y = (gh/2)-(300/2)
    self.MX, self.MY = love.mouse.getPosition()
    if input:pressed('left_click') then
        if self.MX > self.x then
            if self.MX < self.x  + 300 then
                if self.MY > self.y then
                    if self.MY < self.y + 100 then
                        gotoRoom('Stage')
                    end
                end 
            end
        end
    end
end

function Button:draw()
    love.graphics.rectangle('line', self.x, self.y, 300, 100)
    love.graphics.print('uhhhffreakingeeee uhhhh click me to start!!', self.x + 50, self.y + 40)
end
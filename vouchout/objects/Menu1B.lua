Menu1B = GameObject:extend()

function Menu1B:new(area, x, y, opts)
    Menu1B.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.x = 0
    self.y = 0
    local filename = 'TestLB.json'

    if love.filesystem.getInfo(filename) then
        self.contents = love.filesystem.read(filename)
        self.scores = Json.decode(self.contents) or {}
    end

    self.b1 = {x = gw/2-125, y = gh/2-150, w = 250, h = 75, func = function() Gameselect = 'campaign' gotoRoom('Menu2') end}
    self.b2 = {x = gw/2-125, y = gh/2-50, w = 250, h = 75, func = function()  Gameselect = 'TA' gotoRoom('Menu2') end}
    self.b3 = {x = gw/2-125, y = gh/2+50, w = 250, h = 75, func = function() gotoRoom('ScoreScreen') end}
    self.b4 = {x = gw/2-125, y = gh/2+150, w = 250, h = 75, func = function() print('pressed4') end}
    self.buttons = {self.b1, self.b2, self.b3, self.b4}
    self.buttonselected = 1
end

function Menu1B:update(dt)
    if self.buttonselected <= 0 then
        self.buttonselected = #self.buttons
    end
    if self.buttonselected > #self.buttons then
        self.buttonselected = 1
    end
    if input:pressed('up') then
        self.buttonselected = self.buttonselected - 1
    end
    if input:pressed('down')  then
        self.buttonselected = self.buttonselected + 1
    end
    if input:pressed('z') then
        self.buttons[self.buttonselected].func()
    end
    for i=1, #self.buttons do
        if self.buttonselected == i then
            self.buttons[i].x = gw/2-125+25
        else
            self.buttons[i].x = gw/2-125
        end
    end
end

function Menu1B:draw()
    for i=1, #self.buttons do
        love.graphics.rectangle('line', self.buttons[i].x, self.buttons[i].y, self.buttons[i].w, self.buttons[i].h)
    end
end
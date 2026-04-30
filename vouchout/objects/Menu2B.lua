Menu2B = GameObject:extend()

function Menu2B:new(area, x, y, opts)
    Menu2B.super.new(self, area, x, y, opts)
    self.layer = 'ui'
    self.x = 0
    self.y = 0

    self.arrows = {x = 0, y = 0, vis = false}
    self.letters = {" ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
                    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
                    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "&", "-", '$', "@", "!", "?", "_"}


    self.b1 = {x = gw/2-350-25, y = gh/2-25, w = 50, h = 50, func = function() for i=1,6 do self.buttons[i+1].letter = 1 end end}
    self.b2 = {x = gw/2-250-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b3 = {x = gw/2-150-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b4 = {x = gw/2-50-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b5 = {x = gw/2+50-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b6 = {x = gw/2+150-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b7 = {x = gw/2+250-25, y = gh/2-25, w = 50, h = 50, letter=1}
    self.b8 = {x = gw/2+350-25, y = gh/2-25, w = 50, h = 50, func = function() Username = self.letters[self.buttons[2].letter] .. self.letters[self.buttons[3].letter] .. self.letters[self.buttons[4].letter] .. self.letters[self.buttons[5].letter] .. self.letters[self.buttons[6].letter] .. self.letters[self.buttons[7].letter] 
    gotoRoom('FighterScreen') print(Username) end}
    self.buttons = {self.b1, self.b2, self.b3, self.b4, self.b5, self.b6, self.b7, self.b8}
    self.buttonselected = 1
end

function Menu2B:update(dt)
    if self.buttonselected <= 0 then
        self.buttonselected = #self.buttons
    end
    if self.buttonselected > #self.buttons then
        self.buttonselected = 1
    end
    if self.buttons[self.buttonselected].letter then
        if input:pressed('up') then
            self.buttons[self.buttonselected].letter = self.buttons[self.buttonselected].letter + 1
        end
        if input:pressed('down')  then
            self.buttons[self.buttonselected].letter = self.buttons[self.buttonselected].letter - 1
        end
        if self.buttons[self.buttonselected].letter <= 0 then
            self.buttons[self.buttonselected].letter = #self.letters
        end
        if self.buttons[self.buttonselected].letter > #self.letters then
            self.buttons[self.buttonselected].letter = 1
        end
    end
    
    if input:pressed('left') then
        self.buttonselected = self.buttonselected - 1
    end
    if input:pressed('right')  then
        self.buttonselected = self.buttonselected + 1
    end

    if input:pressed('z') then
        if self.buttons[self.buttonselected].func then
            self.buttons[self.buttonselected].func()
        end
    end
    for i=1, #self.buttons do
        if self.buttonselected == i then
            if i > 1 and i < 8 then
                self.arrows = {x = self.buttons[i].x, y=self.buttons[i].y, vis=true}
            else
                self.arrows = {x = self.buttons[i].x, y=self.buttons[i].y, vis=false}
                self.buttons[i].x, self.buttons[i].y = self.buttons[i].x, gh/2-25-25
            end
        else
            self.buttons[i].x, self.buttons[i].y = self.buttons[i].x, gh/2-25
        end
    end
end

function Menu2B:draw()
    for i=1, #self.buttons do
        love.graphics.rectangle('line', self.buttons[i].x, self.buttons[i].y, self.buttons[i].w, self.buttons[i].h)
        if self.buttons[i].letter then
            love.graphics.print(self.letters[self.buttons[i].letter], self.buttons[i].x, self.buttons[i].y)
        end
    end
    if self.arrows.vis then
        love.graphics.print('>', self.arrows.x+30, self.arrows.y+25+60, math.pi/2)
        love.graphics.print('<', self.arrows.x+30, self.arrows.y+15-60, math.pi/2)
    end
end
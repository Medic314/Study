FighterScreen = Object:extend()

function FighterScreen:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self:init()
end

function FighterScreen:init()
    input:bind('z', 'z')
    self.image = ST['Portraits']
    self.IW, self.IH = 150, 200
    self.max_frames = 2
    self.pframe = 1
    self.eframe = 2
    self.quads = {}
    self.scale = 2
    local imgW, imgH = self.image:getDimensions()

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end
    NextEnemy = NextEnemy + 1

    if NextEnemy == 1 then
        gamestates = {timeelapsed = 0, starlevel = 0, max_starlevel = 100, roundstarted = false, playerstamina = 20, playerhp = 200, max_playerhp = 200, consecutivepunches = 0, enemy = 'sloth'}
        self.eframe = 2
    end
    if NextEnemy == 2 then
        gamestates = {timeelapsed = 0, starlevel = 0, max_starlevel = 100, roundstarted = false, playerstamina = 20, playerhp = 200, max_playerhp = 200, consecutivepunches = 0, enemy = 'pride'}
        self.eframe = 2
    end
end



function FighterScreen:update(dt)
    self.area:update(dt)
    if input:pressed('z') then
        gotoRoom('Stage')
        for i=1, #gamestates do 
            print(gamestates[i])
        end
    end
    paused = false
    timer:update(dt)
    camera:update(dt)
    camera:follow(0, 0)
end



function FighterScreen:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    love.graphics.draw(self.image, self.quads[self.pframe], gw/2-300, gh/2, 0, self.scale, self.scale, self.IW/2, self.IH/2)
    love.graphics.draw(self.image, self.quads[self.eframe], gw/2+300, gh/2, 0, self.scale, self.scale, self.IW/2, self.IH/2)

    self.area:draw()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
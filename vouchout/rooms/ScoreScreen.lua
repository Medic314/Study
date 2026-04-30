ScoreScreen = Object:extend()

function ScoreScreen:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self:init()
end

function ScoreScreen:init()
    input:bind('z', 'z')
    input:bind('left', 'left')
    input:bind('right', 'right')

    self.LBlist = {'campaign', 'sloth'}
    self.LBs = {}
    for i=1, #self.LBlist do
        local filename = self.LBlist[i] .. 'LB.json'
        local contents = nil
        local scores = nil
        if love.filesystem.getInfo(filename) then
            contents = love.filesystem.read(filename)
            scores = Json.decode(contents) or {}
        end
        table.insert(self.LBs, #self.LBs+1, {name=filename, contents=contents, scores=scores})
    end
    if Gameselect == nil or Gameselect == 'campaign' then
        self.selectedLB = 1
    else
        self.selectedLB = 2
    end
end



function ScoreScreen:update(dt)
    if not Gameselect then
        if input:pressed('left') then
            self.selectedLB = self.selectedLB - 1
        end
        if input:pressed('right') then
            self.selectedLB = self.selectedLB + 1
        end
        if self.selectedLB <= 0 then
            self.selectedLB = #self.LBlist
        end
        if self.selectedLB > #self.LBlist then
            self.selectedLB = 1
        end
    end
    
    self.area:update(dt)
    if input:pressed('z') then
        if Gameselect == 'campaign' then
            if NextEnemy <= 4 then
                gotoRoom('FighterScreen')
            else
                gotoRoom('Menu1')
            end
        else
            gotoRoom('Menu1')
        end
    end

    paused = false
    timer:update(dt)
    camera:update(dt)
    camera:follow(0, 0)
end



function ScoreScreen:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()

    self.area:draw()

    love.graphics.print(self.LBlist[self.selectedLB], gw/2, 50)
    for i=1, #self.LBs[self.selectedLB].scores do
        love.graphics.print(self.LBs[self.selectedLB].scores[i]["username"], gw/2-100, 50+(i*25))
        love.graphics.print(self.LBs[self.selectedLB].scores[i]["score"], gw/2+100, 50+(i*25))
    end
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
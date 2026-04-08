UiHealth = GameObject:extend()

function UiHealth:new(area, x, y, opts)
    UiHealth.super.new(self, area, x, y, opts)
    self.layer = 'ui'

    self.x = x
    self.y = y
    self.image = love.graphics.newImage("assets/healthdev.png")
    self.max_frames = 3
    self.quads = {}
    self.frame = 1

    self.printx, self.printy = camera:toCameraCoords(-10, -10)
    local imgW, imgH = self.image:getDimensions()
    self.IW = imgW / self.max_frames
    self.IH = imgH

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end

    self.healthticks = {}
end

function UiHealth:update(dt)
    self.printx, self.printy = camera:toCameraCoords(-10, -10)
    self.printx, self.printy = self.printx*-1, self.printy*-1
    for i=1, math.ceil(playerMaxHP/2) do
        self.healthticks[i] = 1
    end

    for i=1, #self.healthticks do
        if playerHP%2 == 1 then
            if playerHP/2 >= i then
                self.healthticks[i] = 1
            elseif (playerHP+1)/2 == i then
                self.healthticks[i] = 2
            else
                self.healthticks[i] = 3
            end
        else
            if playerHP/2 >= i then
                self.healthticks[i] = 1
            else
                self.healthticks[i] = 3
            end
        end
    end
end

function UiHealth:draw()
    for i=1, #self.healthticks do 
        self.frame = self.healthticks[i]
        love.graphics.draw(self.image, self.quads[self.frame], self.printx+((i-1)*90), self.printy, 0, 1.5, 1.5)
    end
end

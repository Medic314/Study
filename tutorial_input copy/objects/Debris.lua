Debris = GameObject:extend()

function Debris:new(area, x, y, opts)
    Debris.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.rot = opts.rot
    self.culltime = opts.culltime/1.5
    self.size = opts.size
    self.v = opts.v*1.25 or 1200*1.25
    self.speed = {speed = self.v}
    self.layer = 'main layer'

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.size)
    self.collider:setType('dynamic')
    self.collider:setObject(self)

    timer:tween(self.culltime, self.speed, {speed = 0}, 'in-expo')
    timer:after(self.culltime, function() self.dead = true end)

    self.image = love.graphics.newImage("assets/debrisdev.png")
    self.frame = 1
    self.max_frames = 3
    self.quads = {}
    self.scale = 1
    self.W, self.H = 25, 25
    self.IW, self.IH = 75, 25
    self.frametime = 0.2

    local imgW, imgH = self.image:getDimensions()
    self.IW = imgW / self.max_frames
    self.IH = imgH

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end

    self.frame = random(0.01,3)
    self.frame = math.ceil(self.frame)
end

function Debris:update(dt)
    local dx = self.x - self.speed.speed*math.cos(self.rot)*dt
    local dy = self.y - self.speed.speed*math.sin(self.rot)*dt
    self.x = dx
    self.y = dy

    self.collider:setPosition(self.x, self.y)
end

function Debris:draw()
    love.graphics.draw(self.image, self.quads[self.frame], self.x, self.y, self.rot, 0.75, 0.75, (25*0.75)/2, (25*0.75)/2)
end
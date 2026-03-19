Summoner = GameObject:extend()

function Summoner:new(area, x, y, opts)
    Summoner.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.type = opts.type
    self.w = opts.w or 24
    self.radius = {radius = self.w}
    self.hp = opts.hp or math.floor(random(1, 12))
    self.v = opts.v or random(50,200)

    timer:tween(1, self.radius, {radius = self.w*2}, 'in-sine')
    if self.type == 'basic' then
        timer:after(1, function() self.area:addGameObject('Enemy', self.x, self.y, {hp=self.hp, v=self.v, type='basic'}) end)
    elseif self.type == 'leap' then
        timer:after(1, function() self.area:addGameObject('Enemy', self.x, self.y, {hp=self.hp, v=self.v, type='leap'}) end)
    elseif self.type == 'gunner' then
        timer:after(1, function() self.area:addGameObject('Enemy', self.x, self.y, {hp=self.hp, v=self.v, type='gunner', speed=0.5, accuracy=2, size=1.5, attackspeed=2}) end)
    elseif self.type == 'shotgunner' then
        timer:after(1, function() self.area:addGameObject('Enemy', self.x, self.y, {hp=self.hp, v=self.v, type='shotgunner', speed=0.55, accuracy=5, size=1, attackspeed=3}) end)
    end
    timer:after(1, function() self.dead = true end)

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, 0.1, 0.1)
    self.collider:setCollisionClass("Enemy")
    self.collider:setType('static')
    self.collider:setObject(self)
end

function Summoner:update(dt)
    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)      
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'Player' then
            collider_1.phase = true
        end
    end)
end

function Summoner:draw()
    love.graphics.circle('line', self.x, self.y, self.radius.radius)
end
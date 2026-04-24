Item = GameObject:extend()

function Item:new(area, x, y, opts)
    Item.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.x = x
    self.y = y
    self.by = y
    self.bx = x
    
    self.opts = opts
    self.type = self.opts.type


    if IT[self.type].family == 'weapon' then
        self.wfamily = IT[self.type].wfamily
    end
    if IT[self.type].family == 'tome' then
        self.upgrades = self.opts.upgrades or {0, 0, 0}
    end

    if IT[self.type].image then
        self.image = IT[self.type].image
    else
        self.image = ST["PlaceholderItem"]
    end

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, 50, 50)
    self.collider:setCollisionClass("Item")
    self.collider:setType('static')
    self.collider:setObject(self)
    self.collider.type = self.type
    self.collider.wfamily = self.wfamily
    self.collider.upgrades = self.upgrades
    self.collider.dead = false

    self.dy = {y = 0}
    self.dx = {x = 0}
    timer:tween(0.25, self.dy, {y = 50}, 'linear')
    timer:after(0.25, function() timer:tween(1, self.dy, {y = 0}, 'in-bounce') end)
    timer:tween(1.25, self.dx, {x = 35}, 'linear')
    self.ix, self.iy = self.image:getDimensions()
end

function Item:update(dt)
    self.collider:setPosition(self.x, self.y)
    self.x, self.y = self.bx - self.dx.x, self.by - self.dy.y

    self.dead = self.collider.dead
end

function Item:draw()
    self.drx, self.dry = self.x - self.ix/2, self.y - self.iy/2
    love.graphics.draw(self.image, self.drx, self.dry)
end

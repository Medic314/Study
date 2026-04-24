Wall = GameObject:extend()

function Wall:new(area, x, y, opts)
    Wall.super.new(self, area, x, y, opts)
    self.layer = 'background'

    self.x = x
    self.y = y
    self.w = opts.w
    self.h = opts.h
    self.door = opts.door or false
    self.tileskin = opts.tileskin or 'tile'
    self.nocollisions = opts.nc or false

    if not self.nocollisions then
        self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
        self.collider:setCollisionClass("Terrain")
        self.collider:setType('static')
        self.collider:setObject(self)
    end

    if self.tileskin == "tile" then
        self.image = ST["TilePlaceholder"]
    elseif self.tileskin == "shelf" then
        self.image = ST['Shelf']
    elseif self.tileskin == "shelf1" then
        self.image = ST['Shelf']
    elseif self.tileskin == "shelf2" then
        self.image = ST['Shelf2']
    elseif self.tileskin == "tilebg" then
        self.image = ST['BackgroundTile']
    end
end

function Wall:update(dt)
    if self.door then
        if DoorDestroy then
            timer:after(0.1, function() DoorDestroy = false end)
            self.dead = true
        end
    end
end

function Wall:draw()
    if self.tileskin == "tile" then
        for i=1, self.w/tile do
            for j=1, self.h/tile do
                love.graphics.draw(self.image, self.x+(i-1)*tile, self.y+(j-1)*tile, 0, 1, 1)
            end
        end
    end
    if self.tileskin == "tilebg" then
        for i=1, self.w/tile do
            for j=1, self.h/tile do
                love.graphics.draw(self.image, self.x+(i-1)*tile, self.y+(j-1)*tile, 0, 1, 1)
            end
        end
    end
    if self.tileskin == "shelf" then
        love.graphics.draw(self.image, self.x, self.y, 0, 1.25, 1.25)
    end
    if self.tileskin == "shelf1" then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
    end
    if self.tileskin == "shelf2" then
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1)
    end
end
Conveyor = GameObject:extend()

function Conveyor:new(area, x, y, opts)
    Conveyor.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.x = x
    self.y = y
    self.w = opts.w or 1
    self.h = opts.h or 1
    self.xflip = 1
    self.yflip = 1
    
    self.w = self.w*tile
    self.h = self.h*tile
    
    self.image = ST["Conveyor"]
    
    self.direction = opts.direction or "up"
    self.turn = nil
    if self.direction == "up" then
        self.r = 0
    elseif self.direction == "down" then
        self.r = math.pi
    elseif self.direction == "left" then
        self.r=math.pi*1.5
    elseif self.direction == "right" then
        self.r=math.pi/2
    end
    self.x, self.y = self.x-(self.x%tile), self.y-(self.y%tile)
    if (((self.x/tile))+#tiles/2) <= 0 or (((self.y/tile))+#tiles/2) <= 0 or (((self.x/tile))+#tiles/2)+3 >= #tiles+1 or (((self.y/tile))+#tiles/2)+3 >= #tiles+1 then
        self.dead = true
    else
        local cPlace = true
        for i=1, self.w/tile do
            for j=1, self.h/tile do
                if tiles[(((self.x/tile))+#tiles/2)+(i-1)][(((self.y/tile))+#tiles/2)+(j-1)] ~= false then
                    if tiles[(((self.x/tile))+#tiles/2)+(i-1)][(((self.y/tile))+#tiles/2)+(j-1)]['id'] == 'conveyor' then
                        cPlace = true
                    else
                        cPlace = false
                    end
                    break
                end
            end
            if not cPlace then break end
        end
        if cPlace then
            local existingTile = tiles[(((self.x/tile))+#tiles/2)][(((self.y/tile))+#tiles/2)]
            if existingTile and existingTile.id == 'conveyor' and existingTile.conveyor then
                existingTile.conveyor.dead = true
            end
            local tx = (self.x / tile) + (#tiles / 2)
            local ty = (self.y / tile) + (#tiles / 2)
            tiles[(((self.x/tile))+#tiles/2)][(((self.y/tile))+#tiles/2)] = {x=tx, y=ty, id = 'conveyor', tags = {'conveyor', 'unpowered', self.direction}, data = {item = nil, tprogress = 0, xflip=1, yflip=1}, conveyor = self}
        else
            self.dead = true
        end
    end
end

local cAngles = {up = 0, down = math.pi, left = math.pi*1.5, right = math.pi/2}
local cOpposites = {up = 'down', down = 'up', left = 'right', right = 'left'}

function Conveyor:getTileDirection(tile)
    if not tile or tile.id ~= 'conveyor' or not tile.tags then
        return nil
    end
    for _, tag in ipairs(tile.tags) do
        if cAngles[tag] then
            return tag
        end
    end
    return nil
end

function Conveyor:update(dt)
    self.image = ST['Conveyor']
    self.r = cAngles[self.direction]
    self.xflip = 1
    self.yflip = 1

    local tx = (self.x / tile) + (#tiles / 2)
    local ty = (self.y / tile) + (#tiles / 2)
    local neighbors = {
        up = tiles[tx] and tiles[tx][ty - 1],
        down = tiles[tx] and tiles[tx][ty + 1],
        left = tiles[tx - 1] and tiles[tx - 1][ty],
        right = tiles[tx + 1] and tiles[tx + 1][ty],
    }

    for rel, neighborTile in pairs(neighbors) do
        local adjdir = self:getTileDirection(neighborTile)
        if neighborTile and neighborTile.id == 'conveyor' then
            if adjdir == rel and rel ~= self.direction and rel ~= cOpposites[self.direction] then
                self.image = ST['ConveyorB']
                if (self.direction == 'up' and adjdir == 'right') or (self.direction == 'up' and adjdir == 'left') then
                    self.r = 0
                    self.turn = 'right'
                    if (self.direction == 'up' and adjdir == 'left') then
                        self.xflip = -1
                        self.turn = 'left'
                    end
                elseif (self.direction == 'right' and adjdir == 'down') or (self.direction == 'left' and adjdir == 'down') then
                    self.r = math.pi/2
                    self.turn = 'down'
                     if (self.direction == 'left' and adjdir == 'down') then
                        self.yflip = -1
                        self.turn = 'down'
                    end
                elseif (self.direction == 'down' and adjdir == 'left') or (self.direction == 'down' and adjdir == 'right') then
                    self.r = math.pi
                    self.turn = 'left'
                     if (self.direction == 'down' and adjdir == 'right') then
                        self.xflip = -1
                        self.turn = 'right'
                    end
                elseif (self.direction == 'left' and adjdir == 'up') or (self.direction == 'right' and adjdir == 'up') then
                    self.r = math.pi*1.5
                    self.turn = 'up'
                     if (self.direction == 'right' and adjdir == 'up') then
                        self.yflip = -1
                        self.turn = 'up'
                    end
                end
                if tiles[tx][ty].data.item then
                    if neighborTile.data.item then
                        tiles[tx][ty].data.tprogress = neighborTile.data.tprogress
                    else
                        tiles[tx][ty].data.tprogress = tiles[tx][ty].data.tprogress + dt*2
                    end
                    if tiles[tx][ty].data.tprogress > 1 then
                        tiles[tx][ty].data.tprogress = 0
                        neighborTile.data.item = tiles[tx][ty].data.item
                        tiles[tx][ty].data.item = nil
                    end
                end
                tiles[tx][ty].data.xflip = self.xflip
                tiles[tx][ty].data.yflip = self.yflip
                break
            end
            if (adjdir == rel and rel == self.direction) then
                if tiles[tx][ty].data.item then
                    if neighborTile.data.item then
                        tiles[tx][ty].data.tprogress = neighborTile.data.tprogress
                    else
                        tiles[tx][ty].data.tprogress = tiles[tx][ty].data.tprogress + dt*2
                    end
                    if tiles[tx][ty].data.tprogress > 1 then
                        tiles[tx][ty].data.tprogress = 0
                        neighborTile.data.item = tiles[tx][ty].data.item
                        tiles[tx][ty].data.item = nil
                    end
                end
            end
        end
    end
end

function Conveyor:draw()
    --love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    local tx = (self.x / tile) + (#tiles / 2)
    local ty = (self.y / tile) + (#tiles / 2)
    self.layer = 'main layer'
    love.graphics.draw(self.image, self.x+self.w/2, self.y+self.h/2, self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
    if tiles[tx][ty].data.item then
        self.layer = 'foreground'
        if not self.turn then
            if self.direction == 'right' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)+7.5)+((tiles[tx][ty].data.tprogress*25)-12.5), ((self.y+self.h/2)+7.5), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.direction == 'up' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)+7.5), ((self.y+self.h/2)-7.5)-((tiles[tx][ty].data.tprogress*25)-12.5), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.direction == 'down' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)-7.5), ((self.y+self.h/2)+7.5)+((tiles[tx][ty].data.tprogress*25)-12.5), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.direction == 'left' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)-7.5)-((tiles[tx][ty].data.tprogress*25)-12.5), ((self.y+self.h/2)-7.5), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
        else
            local offsetx
            local offsety
            offsetx = 7.5
            offsety = 7.5
            if self.xflip == -1 then
                offsetx = 7.5
                offsety = -7.5
            end
            if self.yflip == -1 then
                offsetx = -7.5
                offsety = 7.5
            end
            if self.turn == 'right' then
                love.graphics.draw(ST['Item'], (((self.x+self.w/2)+offsetx)+((tiles[tx][ty].data.tprogress*25)-12.5))+12.5, ((self.y+self.h/2)+offsety), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.turn == 'up' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)+offsetx), (((self.y+self.h/2)-offsety)-((tiles[tx][ty].data.tprogress*25)-12.5))-12.5, self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.turn == 'down' then
                love.graphics.draw(ST['Item'], ((self.x+self.w/2)-offsetx), (((self.y+self.h/2)+offsety)+((tiles[tx][ty].data.tprogress*25)-12.5))+12.5, self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
            if self.turn == 'left' then
                love.graphics.draw(ST['Item'], (((self.x+self.w/2)-offsetx)-((tiles[tx][ty].data.tprogress*25)-12.5))-12.5, ((self.y+self.h/2)-offsety), self.r, 1*self.xflip, 1*self.yflip, self.w/2, self.h/2)
            end
        end
        --[[love.graphics.print(tiles[tx][ty].data.item, self.x+self.w/2, self.y+self.h/2)
        love.graphics.print(tiles[tx][ty].x, (self.x+self.w/2)+30, self.y+self.h/2)
        love.graphics.print(tiles[tx][ty].y, (self.x+self.w/2)+60, self.y+self.h/2)]]--
    end
    --[[if self.turn then
      love.graphics.print(self.turn, self.x+self.w/2, self.y+self.h/2, self.r, 1, 1, self.w/2, self.h/2)
    end]]--
end
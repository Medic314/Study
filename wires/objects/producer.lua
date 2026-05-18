Producer = GameObject:extend()

function Producer:new(area, x, y, opts)
    Producer.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.x = x
    self.y = y
    self.w = opts.w or 4
    self.h = opts.h or 4

    self.w = self.w*tile
    self.h = self.h*tile

    self.producetimer = 0

    self.direction = opts.direction or "up"
    if self.direction == "up" then
        self.r = math.pi
        self.outputrow = 0
    elseif self.direction == "down" then
        self.r = 0
        self.outputrow = 3
    elseif self.direction == "left" then
        self.r=math.pi/2
        self.outputrow = 0
    elseif self.direction == "right" then
        self.r=math.pi*1.5
        self.outputrow = 3
    end
    self.x, self.y = self.x-(self.x%tile), self.y-(self.y%tile)
    if (((self.x/tile))+#tiles/2) <= 0 or (((self.y/tile))+#tiles/2) <= 0 or (((self.x/tile))+#tiles/2)+3 >= #tiles+1 or (((self.y/tile))+#tiles/2)+3 >= #tiles+1 then
        self.dead = true
    else
        local cPlace = true
        for i=1, self.w/tile do
            for j=1, self.h/tile do
                if tiles[(((self.x/tile))+#tiles/2)+(i-1)][(((self.y/tile))+#tiles/2)+(j-1)] ~= false then
                    cPlace = false
                    break
                end
            end
            if not cPlace then break end
        end
        if cPlace then
            for i=1, self.w/tile do
                for j=1, self.h/tile do
                    tiles[(((self.x/tile))+#tiles/2)+(i-1)][(((self.y/tile))+#tiles/2)+(j-1)] = {id = 'producer', tags = {'producer', 'unpowered', self.direction}}
                    print((((self.x/tile))+#tiles/2)+(i-1), (((self.y/tile))+#tiles/2)+(j-1))
                end
            end
            if self.direction == 'up' or self.direction == 'down' then
                tiles[(((self.x/tile))+#tiles/2)][(((self.y/tile))+#tiles/2)+self.outputrow]["tags"] = {'producer', 'output', 'output1', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+1][(((self.y/tile))+#tiles/2)+self.outputrow]["tags"] = {'producer', 'output', 'output2', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+2][(((self.y/tile))+#tiles/2)+self.outputrow]["tags"] = {'producer', 'output', 'output3', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+3][(((self.y/tile))+#tiles/2)+self.outputrow]["tags"] = {'producer', 'output', 'output4', 'unpowered', self.direction}
            else
                tiles[(((self.x/tile))+#tiles/2)+self.outputrow][(((self.y/tile))+#tiles/2)]["tags"] = {'producer', 'output', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+self.outputrow][(((self.y/tile))+#tiles/2)+1]["tags"] = {'producer', 'output', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+self.outputrow][(((self.y/tile))+#tiles/2)+2]["tags"] = {'producer', 'output', 'unpowered', self.direction}
                tiles[(((self.x/tile))+#tiles/2)+self.outputrow][(((self.y/tile))+#tiles/2)+3]["tags"] = {'producer', 'output', 'unpowered', self.direction}
            end
        else
            self.dead = true
        end
    end
end

local cAngles = {up = 0, down = math.pi, left = math.pi*1.5, right = math.pi/2}
local cOpposites = {up = 'down', down = 'up', left = 'right', right = 'left'}

function Producer:getOutput(tile)
    if not tile or tile.id ~= 'producer' or not tile.tags then
        return nil
    end
    for _, tag in ipairs(tile.tags) do
        if tag == 'output' then
            return tag
        end
    end
    return nil
end
function Producer:getCTileDirection(tile)
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

function Producer:update(dt)
    for i=1, self.w/tile do
        for j=1, self.h/tile do
            local tx = ((self.x / tile) + (#tiles / 2))+(i-1)
            local ty = ((self.y / tile) + (#tiles / 2))+(j-1)
            if self:getOutput(tiles[tx][ty]) then
                local neighbors = {
                    up = tiles[tx] and tiles[tx][ty - 1],
                    down = tiles[tx] and tiles[tx][ty + 1],
                    left = tiles[tx - 1] and tiles[tx - 1][ty],
                    right = tiles[tx + 1] and tiles[tx + 1][ty],
                }
                    
                for rel, neighborTile in pairs(neighbors) do
                    local adjdir = self:getCTileDirection(neighborTile)
                    if neighborTile and neighborTile.id == 'conveyor' then
                        print(rel, adjdir)
                        if (adjdir == rel and rel == self.direction) then
                            if not neighborTile.data.item then
                                self.producetimer = self.producetimer + dt
                                if self.producetimer > 5 then
                                    neighborTile.data.item = 'item'
                                    self.producetimer = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Producer:draw()
    --love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.draw(ST["Producer"], self.x+self.w/2, self.y+self.h/2, self.r, 1, 1, self.w/2, self.h/2)
end
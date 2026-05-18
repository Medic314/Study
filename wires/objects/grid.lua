Grid = GameObject:extend()

function Grid:new(area, x, y, opts)
    Grid.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.w = opts.w or 10
    self.h = opts.h or 10
    self.x = (x-(self.w*tile)/2)
    self.y = (y-(self.h*tile)/2)

    tiles = {}
    local xtiles={}
    for i=1, self.w do
        for j=1, self.h do
            table.insert(xtiles, j, false)
        end
        table.insert(tiles, i, xtiles)
        xtiles = {}
    end
end

function Grid:update(dt)
    
end

function Grid:draw()
    for i=1, self.w do
        for j=1, self.h do
            if tiles[i][j] then
                local found = false
                if tiles[i][j]['tags'] then
                    for _, tag in ipairs(tiles[i][j]['tags']) do
                        if tag == 'output' then
                            found = true
                            break
                        end
                    end
                    if found then
                        love.graphics.rectangle('fill', self.x+(tile*i-1), self.y+(tile*j-1), tile, tile)
                    end
                else
                end
            else
                love.graphics.rectangle('line', self.x+(tile*i-1), self.y+(tile*j-1), tile, tile)
            end
        end
    end
end
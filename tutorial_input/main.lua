Object = require("libraries.classic.classic")
Input = require("libraries.boipushy.input")
Timer = require("libraries.hump.timer")
Camera = require("libraries.STALKER-X.Camera")

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    camera = Camera()
    camera:setFollowLerp(0.2)
    camera:setFollowLead(3)
    camera:setFollowStyle('LOCKON')
    timer = Timer()
    input = Input()
    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')

    input:bind("space", "big")
    Player = Player()
    Player:init()
end

function love.update(dt)
    timer:update(dt)
    Player:update(dt)
    camera:update(dt)
    camera:follow(Player.X, Player.Y)
end

function love.draw()
    camera:attach()
    Player:draw()
    love.graphics.circle('fill', 10, 10, 10)
    camera:detach()
end




function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.getInfo(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end


function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

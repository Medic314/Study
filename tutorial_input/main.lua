Object = require("libraries.classic.classic")
Input = require("libraries.boipushy.input")
Timer = require("libraries.hump.timer")
Camera = require("libraries.STALKER-X.Camera")

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)

    
    stage = Stage:new()

    Stage:init()
end

function love.update(dt)
    Stage:update(dt)
end

function love.draw()
    Stage:draw()
end


function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
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

Object = require("libraries.classic.classic")
Input = require("libraries.boipushy.input")

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    input = Input()
    input:bind('w', 'up')
    input:bind('a', 'left')
    input:bind('s', 'down')
    input:bind('d', 'right')

    X = 100
    Y = 100
    DX = 0
    DY = 0
    Player = HyperCircle(X, Y, 10, 5, 20)
end

function love.update(dt)
    if input:down('up') then DY = DY - 0.3 if DY < -3 then DY = -3 end Y = Y + DY print(X, Y, DX, DY) end
    if input:down('left') then DX = DX - 0.3 if DX < -3 then DX = -3 end X = X + DX print(X, Y, DX, DY) end
    if input:down('down') then DY = DY + 0.3 if DY > 3 then DY = 3 end Y = Y + DY print(X, Y, DX, DY) end
    if input:down('right') then DX = DX + 0.3 if DX > 3 then DX = 3 end X = X + DX print(X, Y, DX, DY) end

    if input:pressed('up') then DY = -0.6 end
    if input:pressed('left') then DX = -0.6 end
    if input:pressed('down') then DY = 0.6 end
    if input:pressed('right') then DX = 0.6 end

    if not input:down('up') or not input:down('left') or not input:down('down') or not input:down('right') then
        if DX < 0 then DX = DX + 0.1 X = X + DX end
        if DX > 0 then DX = DX - 0.1 X = X + DX end
        if DY < 0 then DY = DY + 0.1 Y = Y + DY end
        if DY > 0 then DY = DY - 0.1 Y = Y + DY end
        if DX > -0.1 and DX < 0.1 then DX = 0 end
        if DY > -0.1 and DY < 0.1 then DY = 0 end
        print(DX, DY)
    end
end

function love.draw()
    Player.x, Player.y = X, Y
    Player:draw()
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

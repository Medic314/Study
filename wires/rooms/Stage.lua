Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
    CamX, CamY = 0,0
end

function Stage:init()
    builddirection = "up"
    build = "Producer"
    input:bind('mouse1', 'lmb')
    input:bind('mouse2', 'rmb')
    input:bind('wheelup', 'zoomin')
    input:bind('wheeldown', 'zoomout')
    
    input:bind('w', function() builddirection = 'up' end)
    input:bind('s', function() builddirection = 'down' end)
    input:bind('a', function() builddirection = 'left' end)
    input:bind('d', function() builddirection = 'right' end)

    input:bind('1', function() build = 'Producer' end)
    input:bind('2', function() build = 'Conveyor' end)
    input:bind('3', function() build = 'Item' end)

    gridsize = {200, 200, 25}
    tile = gridsize[3]
    camera.scale = 2

   self.area:addGameObject('Grid',0,0,{w=gridsize[1], h=gridsize[2]})
end



function Stage:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        if input:pressed('lmb') or input:down('lmb') then
            local MX, MY = love.mouse.getPosition()
            MX, MY = camera:toWorldCoords(MX/sx, MY/sy)
            if build ~= 'Item' then
                self.area:addGameObject(build, MX, MY, {direction=builddirection})
            else
                local MX, MY = love.mouse.getPosition()
                MX, MY = camera:toWorldCoords(MX/sx, MY/sy)
                MX, MY = MX-(MX%tile), MY-(MY%tile)
                MX = (MX / tile) + (#tiles / 2)
                MY = (MY / tile) + (#tiles / 2)
                if tiles[MX][MY] then
                    if tiles[MX][MY].conveyor then
                        tiles[MX][MY].data.item = 'item'
                    end
                end
            end
        end
        if input:pressed('rmb') then
            MX1, MY1 = love.mouse.getPosition()
        end
        if input:pressed('zoomin') then
            camera.scale = camera.scale + 0.1
            if camera.scale > 3 then
                camera.scale = 3
            end
        end
        if input:pressed('zoomout') then
            camera.scale = camera.scale - 0.1
            if camera.scale < 1 then
                camera.scale = 1
            end
        end
        if input:down('rmb') then
            MX, MY = love.mouse.getPosition()
            MX = MX - MX1
            MY = MY - MY1
            camera:update(dt)
            
            camera:update(dt)
            camera:follow(CamX-MX/camera.scale, CamY-MY/camera.scale)
        else
            if input:released('rmb') then
                CamX, CamY = CamX-MX/camera.scale, CamY-MY/camera.scale
            else
                camera:follow(CamX, CamY)
            end
        end
    end
end



function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    
    camera:attach(CamX, CamY, gw, gh)

    self.area:draw()
    camera:draw()

    camera:detach()
    
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end
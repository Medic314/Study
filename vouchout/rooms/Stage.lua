Stage = Object:extend()

function Stage:new()
    Debug_Vision = true
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.area:addPhysicsWorld()
    self:init()
end

function Stage:init()
    Input_lock = true
    misspulse = false
    enemyx, enemyy = 0, 0
    playerx, playery = 0, 0
    timer:after(2, function() Input_lock = false gamestates.roundstarted = true end)

    input:bind('z', 'leftpunch')
    input:bind('x', 'rightpunch')
    input:bind('c', 'starpunch')
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('left', 'left')
    input:bind('right', 'right')
    
    input:bind('mouse1', 'leftpunch')
    input:bind('mouse2', 'rightpunch')
    input:bind('tab', 'starpunch')
    input:bind('w', 'up')
    input:bind('s', 'down')
    input:bind('a', 'left')
    input:bind('d', 'right')
    
    input:bind('/', function() Debug_Vision = not Debug_Vision end)
    
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('PlayerPunch')
    self.area.world:addCollisionClass('EnemyPunch')
    
    self.area:addGameObject('Player')
    self.area:addGameObject('Enemy')

    CamX, CamY = 0, 0
end



function Stage:update(dt)
    self.area:update(dt)
    if not paused then
        timer:update(dt)
        camera:update(dt)
        CamX, CamY = playerx/3+enemyx/5, playery/3+enemyy/5

        camera:follow(CamX, CamY)
        if gamestates.starlevel > gamestates.max_starlevel then
            gamestates.starlevel = gamestates.max_starlevel
        end
        if gamestates.starlevel < 0 then
            gamestates.starlevel = 0
        end
        if gamestates.playerhp > gamestates.max_playerhp then
            gamestates.playerhp = gamestates.max_playerhp
        end
        if gamestates.consecutivepunches > 10 then
            gamestates.consecutivepunches = 10
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
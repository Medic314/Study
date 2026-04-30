Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.layer = 'main layer'
    self.x = {x=0}
    self.y = {y=100}

    self.sx = 0
    self.sy = 100
    self.lx = -125
    self.rx = 125
    self.dy = 150

    self.w = 100
    self.h = 250

    self.image = ST['Player']
    self.IW, self.IH = 100, 125
    self.max_frames = 9
    self.frame = 1
    self.quads = {}
    self.display_hp = gamestates.playerhp
    self.missswitch = false

    self.scale = 3
    local imgW, imgH = self.image:getDimensions()

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end

    self.collider = self.area.world:newRectangleCollider(self.x.x-(self.w/2), self.y.y, self.w, self.h)
    self.collider:setCollisionClass('Player')
    self.collider:setObject(self)

    self.duckcheck = false
    self.blockcheck = 0
    self.blockcount = false
    self.stunned = false

    local function cancelall()
        for i = 1, 5 do
            timer:cancel('lhook' .. i)
        end
        for i = 1, 5 do
            timer:cancel('ljab' .. i)
        end
        for i = 1, 5 do
            timer:cancel('rhook' .. i)
        end
        for i = 1, 5 do
            timer:cancel('rjab' .. i)
        end
        for i = 1, 3 do
            timer:cancel('dodgel' .. i)
        end
        for i = 1, 3 do
            timer:cancel('dodger' .. i)
        end
        for i = 1, 3 do
            timer:cancel('dodged' .. i)
        end
    end
    local function hitstun(speed)
        if not self.stunned then
            cancelall()
            Input_lock = true
            self.frame = 1
            self.x.x = self.sx
            self.y.y = self.sy
            self.stunned = true
            timer:after(speed, function() Input_lock = false self.stunned = false end)
        end
    end


    self.hitstun = hitstun
    self.cancel = cancelall



    local function punchaniml(speed, tag)
        self.scale = 3
        self.frame = 1
        timer:after((speed/6)*1, function() self.frame = 2 timer:after((speed/6), function() self.frame = 3 timer:after((speed/3), function() self.frame = 4 timer:after((speed/3), function() self.frame = 1 end, tag .. '5') end, tag .. '4') end, tag .. '3') end, tag .. '2')
    end
    local function punchanimr(speed, tag)
        self.scale = -3
        self.frame = 1
        timer:after((speed/6)*1, function() self.frame = 2 timer:after((speed/6), function() self.frame = 3 timer:after((speed/3), function() self.frame = 4 timer:after((speed/3), function() self.frame = 1 end, tag .. '5') end, tag .. '4') end, tag .. '3') end, tag .. '2')
    end

    local function hookaniml(speed, tag)
        self.scale = 3
        self.frame = 1
        timer:after((speed/6), function() self.frame = 5 timer:after((speed/6), function() self.frame = 6 timer:after((speed/3), function() self.frame = 5 timer:after((speed/3), function() self.frame = 1 end, tag .. '5') end, tag .. '4') end, tag .. '3') end, tag .. '2')
    end
    local function hookanimr(speed, tag)
        self.scale = -3
        self.frame = 1
        timer:after((speed/6), function() self.frame = 5 timer:after((speed/6), function() self.frame = 6 timer:after((speed/3), function() self.frame = 5 timer:after((speed/3), function() self.frame = 1 end, tag .. '5') end, tag .. '4') end, tag .. '3') end, tag .. '2')
    end
    local function dodgeaniml(speed, tag)
        self.scale = -3
        self.frame = 9
        timer:after((speed), function() self.frame = 1 end, tag .. '3')
    end
    local function dodgeanimr(speed, tag)
        self.scale = 3
        self.frame = 9
        timer:after((speed), function() self.frame = 1 end, tag .. '3')
    end
    local function dodgeanimd(speed, tag)
        self.scale = 3
        self.frame = 8
        timer:after((speed), function() self.frame = 1 end, tag .. '3')
    end

    self.punchaniml = punchaniml
    self.punchanimr = punchanimr
    self.hookaniml = hookaniml
    self.hookanimr = hookanimr
    self.dodgeaniml = dodgeaniml
    self.dodgeanimr = dodgeanimr
    self.dodgeanimd = dodgeanimd

    self.block = false
    self.dodge = false
    
    timer:every(0.1, function() if self.blockcount then self.blockcheck = self.blockcheck + 1 end end)
end

function Player:update(dt)
    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'EnemyPunch' then
            print("OW")
        end
    end)
    if not Input_lock then
        if input:pressed('leftpunch') or input:down('leftpunch') then
            if input:down('up') then
                print("lhook")
                Input_lock = true
                self.area:addGameObject('PlayerPunch', -50, -50, {type='lhook', damage = 20})
                self.hookaniml(0.45-(gamestates.consecutivepunches/120), 'lhook')
                timer:after(0.45-(gamestates.consecutivepunches/120), function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'lhook1')
            else
                print("ljab")
                Input_lock = true
                self.area:addGameObject('PlayerPunch', -50, 50, {type='ljab', damage = 22.5})
                self.punchaniml(0.5, 'ljab')
                timer:after(0.5, function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'ljab1')
            end
        else
            if input:pressed('rightpunch') or input:down('rightpunch') then
                if input:down('up') then
                    print("rhook")
                    Input_lock = true
                    self.area:addGameObject('PlayerPunch', 50, -50, {type='rhook', damage = 25})
                    self.hookanimr(0.5-(gamestates.consecutivepunches/120), 'rhook')
                    timer:after(0.5-(gamestates.consecutivepunches/120), function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'rhook1')
                else
                    print("rjab")
                    Input_lock = true
                    self.area:addGameObject('PlayerPunch', 50, 50, {type='rjab', damage = 27.5})
                    self.punchanimr(0.55-(gamestates.consecutivepunches/120), 'rjab')
                    timer:after(0.55-(gamestates.consecutivepunches/120), function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'rjab1')
                end
            end
        end
        if input:pressed('starpunch') then
            if gamestates.starlevel == gamestates.max_starlevel then
                if input:down('up') then
                    print("shook")
                    Input_lock = true
                    self.area:addGameObject('PlayerPunch', 50, -50, {type='rhook', damage = 125, sp=true})
                    self.hookanimr(1-(gamestates.consecutivepunches/40), 'rhook')
                    timer:after(1-(gamestates.consecutivepunches/40), function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'rhook1')
                else
                    print("sjab")
                    Input_lock = true
                    self.area:addGameObject('PlayerPunch', 50, 50, {type='rjab', damage = 150, sp=true})
                    self.punchanimr(1.2-(gamestates.consecutivepunches/40), 'rjab')
                    timer:after(1.2-(gamestates.consecutivepunches/40), function() if not misspulse then Input_lock = false else self.missswitch = true end end, 'rjab1')
                end
            end
        end
        if input:pressed('down') or input:down('down') then
            print('duck')
            Input_lock = true
            self.dodge = 'd'
            self.dodgeanimd(0.75, 'duck')
            timer:tween(0.375, self.y, {y=self.dy}, 'out-sine')
            timer:after(0.375, function() timer:tween(0.5, self.y, {y=self.sy}, 'in-sine') end, 'duck1')
            timer:after(0.75, function() Input_lock = false self.dodge = false end, 'duck2')
        elseif input:pressed('left') or input:down('left') then
            print("dodgeleft")
            self.dodge = 'l'
            timer:tween(0.25, self.x, {x=self.lx}, 'out-sine')
            timer:after(0.25, function() timer:tween(0.5, self.x, {x=self.sx}, 'in-sine') end, 'dodgel1')
            self.dodgeaniml(0.7, 'dodgel')
            Input_lock = true
            timer:after(0.7, function() Input_lock = false self.dodge = false end, 'dodgel2')
        elseif input:pressed('right') or input:down('right') then
            self.dodge = 'r'
            print('dodgeright')
            timer:tween(0.25, self.x, {x=self.rx}, 'out-sine')
            timer:after(0.25, function() timer:tween(0.5, self.x, {x=self.sx}, 'in-sine') end, 'dodger1')
            Input_lock = true
            self.dodgeanimr(0.7, 'dodger')
            timer:after(0.7, function() Input_lock = false self.dodge = false end, 'dodger2')
        end
    end

    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'Player' and collider_2.collision_class == 'EnemyPunch' then
            if collider_2.type == 'jab' then
                if not self.dodge then
                    print(collider_2.type .. collider_2.direction)
                    gamestates.playerhp = gamestates.playerhp - collider_2.damage
                    gamestates.starlevel = gamestates.starlevel - collider_2.damage
                    gamestates.consecutivepunches = 0
                    self.hitstun(1)
                    timer:tween(0.5, self, {display_hp = gamestates.playerhp}, 'out-sine')
                end
            end
            if collider_2.type == 'hook' then
                if self.dodge == collider_2.direction then
                    print('dodged')
                else
                    print(collider_2.type .. collider_2.direction)
                    gamestates.playerhp = gamestates.playerhp - collider_2.damage
                    gamestates.starlevel = gamestates.starlevel - collider_2.damage
                    gamestates.consecutivepunches = 0
                    self.hitstun(1.5)
                    timer:tween(0.5, self, {display_hp = gamestates.playerhp}, 'out-sine')
                end
                print(self.dodge, collider_2.direction)
            end
        end
    end)
    if self.missswitch then
        self.missswitch = false
        misspulse = false
        self.hitstun(0.5)
    end
    if self.display_hp == gamestates.playerhp then
    else
        self.display_hp = gamestates.playerhp
    end
    self.collider:setPosition(self.x.x, self.y.y+self.h/2)
    playerx, playery = self.x.x, self.y.y-125
end

function Player:draw()
    love.graphics.draw(self.image, self.quads[self.frame], self.x.x, self.y.y, 0, self.scale, 3, self.IW/2, self.IH/3)
    if Debug_Vision then
        love.graphics.rectangle('line', self.x.x-(self.w), self.y.y, self.w*2, self.h)
        love.graphics.print(tostring(Input_lock), -gw/2, -gh/2)
        love.graphics.print(tostring(self.dodge), -gw/2, -gh/2+20)
        love.graphics.print(tostring(gamestates.playerhp), -gw/2, -gh/2+40)
        love.graphics.print(tostring(gamestates.timeelapsed), -gw/2, -gh/2+80)
        love.graphics.print(tostring(gamestates.starlevel), -gw/2, -gh/2+100)
    end

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+40, 200, 20)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+40, (self.display_hp / gamestates.max_playerhp) * 200, 20)
    love.graphics.setColor(1, 1, 1)
end
Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
    Enemy.super.new(self, area, x, y, opts)
    self.layer = 'background'
    self.x = 1000
    self.y = 1000
    self.w = 250
    self.h = 350

    self.collider = self.area.world:newRectangleCollider(self.x-(self.w/2), self.y, self.w, self.h)
    self.collider:setCollisionClass('Enemy')
    self.collider:setObject(self)
    self.x = 0
    self.y = 100
    self.sx = 0
    self.sy = 100
    self.vx = {x=0}
    self.vy = {y=100}
    gamestates.round = 3
    if gamestates.enemy == 'sloth' then
        self.hp = 600
        self.maxhp = self.hp
        self.energy = 15
        self.type = 'sloth'
        self.currentguard = 1
        self.guard = {}
        self.guardstances = {{}, {'lhook'}, {'rhook'}, {'ljab'}, {}, {'rjab', 'ljab'}, {}, {}, {'lhook', 'rhook'}}
        self.specialblock = false
        self.guardtime = 0
        self.maxguardtime = 7.5
        self.display_hp = self.maxhp
    end
    self.image = ST['Enemy']
    self.IW, self.IH = 200, 375
    self.max_frames = 11
    self.frame = 1
    self.quads = {}
    self.idleframe = 1
    self.hitanim = false
    timer:every(2, function() self.idleframe = 1 timer:after(1, function() self.idleframe = 2 end) end)

    self.scale = 1.5
    local imgW, imgH = self.image:getDimensions()

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end

    self.hitcounts = 0
    self.hitlist = {}
    self.attacking = true
    self.attackpats = 3
    self.counterpunch = false
    self.stunb = false
    self.stuntype = 'jab'
    self.stage = 0
    self.pattern = nil

    local function cancelall()
        local maxtimers = 10

        for i=1, maxtimers do
            timer:cancel('jab' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('hook' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('pat1' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('pat2' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('sleep' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('special' .. i)
        end
    end

    local function stun(duration)
        self.cancelall()
        self.frame = 7
        self.attacking = false
        self.stunb = true
        self.counterpunch = false
        timer:after(duration, function() self.stunb = false self.attacking = true self.frame = 1 end, 'stun1')
    end

    local function jab(speed, direction)
        if direction == 'r' then
            self.scale = 1.5
        else
            self.scale = -1.5
        end
        self.frame = 1
        timer:after((speed/3), function() self.frame = 3 timer:after((speed/3), function() self.frame = 4 self.area:addGameObject('EnemyPunch', 0, 100, {type='jab', direction = direction}) timer:after((speed/25), function() self.frame = 2 self.stuntype = 'jab' self.counterpunch = true timer:after((speed/3), function() self.frame = 1 self.counterpunch = false self.scale = 1.5 end, 'jab4') end, 'jab3') end, 'jab2') end, 'jab1')
    end
    local function special()
        self.frame = 1
        timer:after(0.60, function() self.guard = {} end, 'special2')
        timer:tween(0.80, self.vx, {x=self.sx}, 'out-sine')
        timer:tween(0.80, self.vy, {y=self.sy}, 'out-sine')
        timer:after(0.95, function() self.block = {'ljab', 'rjab', 'lhook', 'rhook'} self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = 'l', damage=75}) end, 'special1')
        timer:after(1.25, function() self.stage = 4 self.pat3() end, 'special3')
    end
    local function hook(speed, direction)
        self.frame = 1
        if direction == 'r' then
            self.scale = 1.5
            timer:after((speed/2), function() self.frame = 5 self.x = 10 self.vy.y = 150 timer:after((speed/4), function() self.frame = 6 self.vy.y = self.sy self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, damage=35}) timer:after((0.1), function() self.frame = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/4, function() self.counterpunch = false self.frame = 1 self.scale = 1.5 end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        else
            self.scale = -1.5
            timer:after((speed/2), function() self.frame = 5 self.x = -10 self.vy.y = 150 timer:after((speed/4), function() self.frame = 6 self.vy.y = self.sy-50 self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, damage=35}) timer:after((0.1), function() self.vy.y = self.sy self.frame = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/4, function() self.counterpunch = false self.frame = 1 self.scale = 1.5 end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        end
    end
    local function pat1()
        self.pattern = 'pat1'
        self.attacking = false
        print(self.pattern, self.stage)
        if self.stage == 1 then
            self.jab(1.5, 'l')
        end
        if self.stage == 2 then
            self.jab(1.5, 'r')
        end
        if self.stage == 3 then
            self.hook(3, 'l')
        end
        if self.stage == 4 then 
            self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.stage = 0
        end
    end
    local function pat2()
        self.pattern = 'pat2'
        self.attacking = false
        if self.stage == 1 then
            self.hook(3, 'l')
        end
        if self.stage == 2 then
            self.hook(3, 'r')
        end
        if self.stage == 3 then
            self.hook(3, 'l')
        end
        if self.stage == 4 then 
            self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.stage = 0
        end
    end
    local function pat3()
        self.pattern = 'pat3'
        self.attacking = false
        if self.stage == 1 then
            self.specialblock = true
            self.guard = {'ljab', 'rjab', 'lhook', 'rhook'}
            timer:tween(1, self.vy, {y=0}, 'out-sine')
            timer:tween(1, self.vx, {x=50}, 'out-sine')
        end
        if self.stage == 2 then
            timer:tween(2, self.vx, {x=-50}, 'out-sine')
        end
        if self.stage == 3 then
            self.special()
        end
        if self.stage == 4 then 
            self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.specialblock = false
            self.stage = 0
            self.attackpats = 0
        end
    end

    
    self.pat1 = pat1
    self.pat2 = pat2
    self.pat3 = pat3
    self.cancelall = cancelall 
    self.stun = stun
    self.jab = jab
    self.hook = hook
    self.special = special
end

function Enemy:update(dt)
    if gamestates.roundstarted then
        gamestates.timeelapsed = gamestates.timeelapsed + dt
        if self.type == 'sloth' then
            if gamestates.timeelapsed > 3 then
                if self.attacking then
                    if self.attackpats < 3 then
                        if not self.pattern then
                            local randompercent = random(0, 100)
                            if randompercent >= 0 and randompercent <= 40 then
                                self.pattern = 'pat1'
                            elseif randompercent >= 40 and randompercent <= 80 then
                                self.pattern = 'pat2'
                            else
                                self.pattern = 'sleep'
                            end
                        end
                        if self.pattern == 'pat1' then
                            self.attacking = false
                            if self.stage == 0 then
                                self.stage = 1
                                self.pat1()
                            end
                            if self.stage == 1 then
                                timer:after(2, function() self.stage = 2 self.pat1() timer:after(2, function() self.stage = 3 self.pat1() timer:after(4, function() self.stage = 4 self.pat1()  end, 'pat13') end, 'pat12') end, 'pat11')
                            end
                            if self.stage == 2 then
                                timer:after(3, function() self.stage = 3 self.pat1() timer:after(4, function() self.stage = 4 self.pat1() end, 'pat13') end, 'pat12')
                            end
                            if self.stage == 3 then
                                timer:after(4, function() self.stage = 4 self.pat1() end, 'pat13')
                            end
                        elseif self.pattern == 'pat2' then
                            self.attacking = false
                            if self.stage == 0 then
                                self.stage = 1
                                self.pat2()
                            end
                            if self.stage == 1 then
                                timer:after(3, function() self.stage = 2 self.pat2() timer:after(3, function() self.stage = 3 self.pat2() timer:after(4, function() self.stage = 4 self.pat2()  end, 'pat23') end, 'pat22') end, 'pat21')
                            end
                            if self.stage == 2 then
                                timer:after(3, function() self.stage = 3 self.pat2() timer:after(4, function() self.stage = 4 self.pat2() end, 'pat23') end, 'pat22')
                            end
                            if self.stage == 3 then
                                timer:after(4, function() self.stage = 4 self.pat2() end, 'pat23')
                            end
                        else
                            self.attacking = false
                            print('sleep')
                            self.stun(4)
                            self.pattern = nil
                        end
                    else
                        self.attacking = false
                        self.stage = 1
                        self.pat3()
                        timer:after(1, function() self.stage = 2 self.pat3() timer:after(2, function() self.stage = 3 self.pat3() end, 'special4') end, 'special5')
                    end
                end
            end
        end
    end

    if self.frame == 1 or self.frame == 2 then
        self.frame = self.idleframe
    end

    self.x, self.y = self.vx.x, self.vy.y

    if not self.specialblock then
        if not self.stunb then
            self.guardtime = self.guardtime + dt
        end
        if self.guardtime > self.maxguardtime then
            self.guardtime = 0
            self.currentguard = self.currentguard + 1
        end
        if self.currentguard > #self.guardstances then
            self.currentguard = 1
        end
        self.guard = self.guardstances[self.currentguard]
    end

    self.collider:setPosition(self.x, self.y)
    self.collider:setPreSolve(function(collider_1, collider_2, contact)
        contact:setEnabled(false)
        if collider_1.collision_class == 'Enemy' and collider_2.collision_class == 'PlayerPunch' then
            local blocked = false
            for i=1, #self.guard do
                if self.guard[i] == collider_2.type then
                    blocked = true
                    self.guardtime = self.guardtime - 2
                    print('blocked')
                    if not self.specialblock then
                        if collider_2.type == 'lhook' then
                            self.frame = 8
                        end
                        if collider_2.type == 'rhook' then
                            self.frame = 9
                        end
                        if collider_2.type == 'ljab' then
                            self.frame = 10
                        end
                        if collider_2.type == 'rjab' then
                            self.frame = 11
                        end
                        timer:after(0.20, function() if self.frame == 8 or self.frame == 8 or self.frame == 10 or self.frame == 11 then self.frame = 1 end end)
                    else
                        misspulse = true
                    end
                        if self.stunb then
                            self.cancelall()
                            self.stunb = false
                            self.attacking = true
                        end
                    gamestates.consecutivepunches = 0
                end
            end
            if not blocked then
                self.guardtime = self.guardtime + 1.5
                if self.hitcounts then
                    self.hitcounts = self.hitcounts + 1
                end
                self.hitlist[#self.hitlist+1] = collider_2.type

                if self.counterpunch == true then
                    if self.stuntype == 'jab' then
                        self.stun(1.5)
                    else
                        self.stun(1.5)
                    end
                end

                gamestates.starlevel = gamestates.starlevel + collider_2.damage / 2
                gamestates.playerhp = gamestates.playerhp + collider_2.damage / 10
                gamestates.consecutivepunches = gamestates.consecutivepunches + 1
                self.hitanim = true
                timer:after(0.2, function() self.hitanim = false end)
                if self.specialblock then self.hp = self.hp - self.hp self.cancelall() self.stage = 4 self.pat3() end
                self.hp = self.hp - collider_2.damage
                timer:tween(0.5, self, {display_hp = self.hp}, 'out-sine')
            end
        end
    end)

    if self.hp <= 0 then
        gamestates.round = gamestates.round - 1
        if gamestates.round <= 0 then
            self.dead = true
        end
        self.hp = 1
        self.cancelall()
        self.specialblock = true
        self.attacking = false
        self.frame = 7
        self.guard = {'ljab', 'rjab', 'lhook', 'rhook'}
        if gamestates.playerhp > gamestates.max_playerhp/1.5 then
            self.hp = self.maxhp
        else
            if gamestates.playerhp > gamestates.max_playerhp/3 then
                self.hp = self.maxhp/2
            else
                self.hp = self.maxhp/3
            end
        end
        local direction = 0
        if self.hitlist[#self.hitlist] == 'rjab' or self.hitlist[#self.hitlist] == 'rhook' then
            direction = -300
        else
            direction = 300
        end
        self.stun(5)
        timer:tween(0.5, self.vy, {y=15}, 'out-sine')
        timer:after(0.5,function() timer:tween(0.5, self.vy, {y=0}, 'out-sine') end)
        timer:tween(1, self.vx, {x=direction}, 'out-sine')
        timer:after(4, function() timer:tween(1, self.vy, {y=self.sy}, 'out-sine') end)
        timer:after(4, function() timer:tween(1, self.vx, {x=self.sx}, 'out-sine') end)

        timer:tween(5, self, {display_hp = self.hp}, 'out-sine')
        timer:after(5, function() self.stage = 4 self.pat3() end)
    end
    enemyx, enemyy = self.x, self.y
end

function Enemy:draw()
    if self.hitanim then
        love.graphics.rectangle('fill', self.x, self.y-200, 50, 50)
    end
    love.graphics.draw(self.image, self.quads[self.frame], self.x, self.y, 0, self.scale, 1.5, self.IW/2, self.IH/2)
    if Debug_Vision then
        love.graphics.print(self.hp, -gw/2, (-gh/2)+60)
        love.graphics.print(tostring(self.guardtime), -gw/2, (-gh/2)+120)
        love.graphics.print(tostring(self.currentguard), -gw/2, (-gh/2)+(140))
        for i=1, #self.guard do
            love.graphics.print(tostring(self.guard[i]), -gw/2, (-gh/2)+(140+(i*20)))
        end
    end

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+80, 200, 20)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+80, (self.display_hp / self.maxhp) * 200, 20)
    love.graphics.setColor(1, 1, 1)
end
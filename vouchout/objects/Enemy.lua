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
    
    gamestates.round = 3
    if gamestates.enemy == 'sloth' then
        self.x = 0
        self.y = 100
        self.sx = 0
        self.sy = 100
        self.vx = {x=0}
        self.vy = {y=100}
        self.hp = 600

        self.maxhp = self.hp
        self.energy = 15
        self.type = 'sloth'
        self.currentguard = 1
        self.guard = {'none'}
        self.guardstances = {{'none'}, {'none'}, {'lhook'}, {'rhook'}, {'ljab'}, {'none'}, {'rjab', 'ljab'}, {'none'}, {'none'}, {'lhook', 'rhook'}}
        self.specialblock = false
        self.guardtime = 0
        self.maxguardtime = 7.5
        self.display_hp = self.maxhp

        self.image = ST['SlothB']
        self.legImage = ST['SlothL']
        self.IW, self.IH = 200, 375
        self.max_frames = 14
        self.bframe = 1
        self.lframe = 1
        self.quads = {}
        self.lquads = {}
        self.idleframe = 1
        self.idlebframe = 1
        self.hitanim = false
        timer:every(2, function() self.idleframe = 1 timer:after(1, function() self.idleframe = 2 end) end)
        self.scale = 1.5
        self.attackpats = 3
    end
    if gamestates.enemy == 'pride' then
        self.goagain = false
        self.x = 0
        self.y = 100
        self.sx = 0
        self.sy = 100
        self.vx = {x=0}
        self.vy = {y=100}
        self.hp = 800

        self.maxhp = self.hp
        self.energy = 15
        self.type = 'pride'
        self.currentguard = 1
        self.guard = {'none'}
        self.guardstances = {{'none'}}
        self.specialblock = false
        self.guardtime = 0
        self.maxguardtime = 7.5
        self.display_hp = self.maxhp

        self.image = ST['SlothB']
        self.legImage = ST['SlothL']
        self.IW, self.IH = 200, 375
        self.max_frames = 14
        self.bframe = 1
        self.lframe = 1
        self.quads = {}
        self.lquads = {}
        self.idleframe = 1
        self.idlebframe = 1
        self.hitanim = false
        timer:every(2, function() self.idleframe = 1 timer:after(1, function() self.idleframe = 2 end) end)
        self.scale = 1.5
        self.attackpats = 0
        self.tauntc = true
    end

    local imgW, imgH = self.image:getDimensions()
    local legW, legH
    if self.legImage then
        legW, legH = self.legImage:getDimensions()
    end

    for i = 1, self.max_frames do
        self.quads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
        if self.legImage then
            self.lquads[i] = love.graphics.newQuad(self.IW * (i-1), 0, self.IW, self.IH, legW, legH)
        end
        print(self.quads[i], self.IW * (i-1), 0, self.IW, self.IH, imgW, imgH)
    end

    self.hitcounts = 0
    self.hitlist = {}
    self.attacking = true
    self.counterpunch = false
    self.stunb = false
    self.stuntype = 'jab'
    self.stage = 0
    self.pattern = nil
    self.downed = false
    self.downtimer = 0
    self.instadowned = false

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
            timer:cancel('pat1' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('sleep' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('special' .. i)
        end
        for i=1, maxtimers do
            timer:cancel('cpat' .. i)
        end
    end

    local function stun(duration, frame)
        self.cancelall()
        frame = frame or 7
        self.bframe = frame
        self.attacking = false
        self.stunb = true
        self.counterpunch = false
        if not self.downed then
            timer:tween(0.25, camera, {scale = 1.05}, 'out-sine')
        end
        timer:after(duration, function() self.stunb = false self.attacking = true self.bframe = self.idlebframe timer:tween(0.25, camera, {scale = 1}, 'out-sine') timer:after(0.25, function() camera.scale = 1 end) end, 'stun1')
    end


    local function sjab(speed, direction, block)
        if direction == 'r' then
            self.scale = 1.5
        else
            self.scale = -1.5
        end
        self.bframe = self.idlebframe
        local blockc = block or 'up'
        timer:after(((speed/6)+(speed/9)), function() self.bframe = 3 timer:after(speed/9, function() self.bframe = 12 timer:after((speed/3), function() self.bframe = 4 self.area:addGameObject('EnemyPunch', 0, 100, {type='jab', direction = direction, block=blockc}) timer:after((speed/25), function() self.bframe = self.idlebframe self.stuntype = 'jab' self.counterpunch = true timer:after((speed/3), function() self.bframe = self.idlebframe self.counterpunch = false end, 'jab5') end, 'jab4') end, 'jab3')  end, 'jab2') end, 'jab1')
        timer:after(speed, function() self.scale = 1.5 self.lframe = self.idleframe end)
    end
    local function sspecial()
        self.bframe = self.idlebframe
        timer:after(0.60, function() self.guard = {} end, 'special2')
        timer:tween(0.80, self.vx, {x=self.sx}, 'out-sine')
        timer:tween(0.80, self.vy, {y=self.sy}, 'out-sine')
        timer:after(0.95, function() self.block = {'ljab', 'rjab', 'lhook', 'rhook'} self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = 'l', damage=75}) end, 'special1')
        timer:after(1.25, function() self.stage = 4 self.pat3() end, 'special3')
    end
    local function shook(speed, direction, block)
        self.bframe = self.idlebframe
        local blockc = block or 'none'
        if direction == 'r' then
            self.scale = 1.5
            timer:after((speed/4), function() self.bframe = 5 self.x = 10 self.vy.y = 150 timer:after((speed/4), function() self.bframe = 6 self.vy.y = self.sy self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35}) timer:after((0.1), function() self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/4, function() self.counterpunch = false self.bframe = self.idlebframe end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        else
            self.scale = -1.5
            timer:after((speed/2), function() self.bframe = 5 self.x = -10 self.vy.y = 150 timer:after((speed/4), function() self.bframe = 6 self.vy.y = self.sy-50 self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35}) timer:after((0.1), function() self.vy.y = self.sy self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/4, function() self.counterpunch = false self.bframe = self.idlebframe end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        end
        timer:after(speed, function() self.scale = 1.5 self.lframe = self.idleframe end)
    end


    local function spat1()
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
    local function spat2()
        self.pattern = 'pat2'
        self.attacking = false
        print(self.pattern, self.stage)
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
    local function spat3()
        print(self.pattern, self.stage)
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


    local function pjab(speed, direction, block, hcheck)
        local lhcheck = hcheck or false
        local blockc = block or 'up'
        if direction == 'r' then
            self.scale = 1.5
        else
            self.scale = -1.5
        end
        self.bframe = self.idlebframe
        timer:after(((speed/100)), function() self.bframe = 3 timer:after(speed/9, function() self.bframe = 12 timer:after((speed/3), function() self.bframe = 4 self.area:addGameObject('EnemyPunch', 0, 100, {type='jab', direction = direction, block=blockc, hcheck=lhcheck}) timer:after((speed/25), function() self.bframe = self.idlebframe self.stuntype = 'jab' self.counterpunch = true timer:after((speed/3), function() self.bframe = self.idlebframe self.counterpunch = false end, 'jab5') end, 'jab4') end, 'jab3')  end, 'jab2') end, 'jab1')
        timer:after(speed, function() self.scale = 1.5 self.lframe = self.idleframe end)
    end
    local function pspecial()
        self.bframe = self.idlebframe
        timer:after(0.60, function() self.guard = {} end, 'special2')
        timer:tween(0.80, self.vx, {x=self.sx}, 'out-sine')
        timer:tween(0.80, self.vy, {y=self.sy}, 'out-sine')
        timer:after(0.95, function() self.block = {'ljab', 'rjab', 'lhook', 'rhook'} self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = 'l', damage=75}) end, 'special1')
        timer:after(1.25, function() self.stage = 4 self.pat3() end, 'special3')
    end
    local function phook(speed, direction, block, hcheck)
        local lhcheck = hcheck or false
        self.bframe = self.idlebframe
        local blockc = block or 'none'
        if direction == 'r' then
            self.scale = 1.5
            timer:after((speed/100), function() self.bframe = 5 self.x = 10 self.vy.y = 150 timer:after((speed/2), function() self.bframe = 6 self.vy.y = self.sy self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35, hcheck=lhcheck}) timer:after((0.1), function() self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/8, function() self.counterpunch = false self.bframe = self.idlebframe end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        else
            self.scale = -1.5
            timer:after((speed/100), function() self.bframe = 5 self.x = -10 self.vy.y = 150 timer:after((speed/2), function() self.bframe = 6 self.vy.y = self.sy-50 self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35, hcheck=lhcheck}) timer:after((0.1), function() self.vy.y = self.sy self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/8, function() self.counterpunch = false self.bframe = self.idlebframe end, 'hook4') end, 'hook3') end, 'hook2') end, 'hook1')
        end
        timer:after(speed, function() self.scale = 1.5 self.lframe = self.idleframe end)
    end
    local function pfhook(speed, direction, block, hcheck)
        local lhcheck = hcheck or false
        self.bframe = self.idlebframe
        local blockc = block or 'none'
        if direction == 'r' then
            self.scale = -1.5
            timer:after((speed/100), function() self.bframe = 5 self.x = -10 self.vy.y = 150 timer:after(speed/4, function() self.bframe = 12 timer:after(speed/12,function() self.bframe = 5 timer:after((speed/4), function() self.scale = 1.5 self.bframe = 6 self.vy.y = self.sy-50 self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35, hcheck=lhcheck}) timer:after((0.1), function() self.vy.y = self.sy self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/8, function() self.counterpunch = false self.bframe = self.idlebframe end, 'fhook6') end, 'fhook5') end, 'fhook4') end, 'fhook3') end, 'fhook2') end, 'fhook1')
        else
            self.scale = 1.5
            timer:after((speed/100), function() self.bframe = 5 self.x = -10 self.vy.y = 150 timer:after(speed/4, function() self.bframe = 12 timer:after(speed/12,function() self.bframe = 5 timer:after((speed/4), function() self.scale = -1.5 self.bframe = 6 self.vy.y = self.sy-50 self.area:addGameObject('EnemyPunch', 0, 100, {type='hook', direction = direction, block=blockc, damage=35, hcheck=lhcheck}) timer:after((0.1), function() self.vy.y = self.sy self.bframe = 6 self.stuntype = 'hook' self.counterpunch = true self.x = 0 timer:after(speed/8, function() self.counterpunch = false self.bframe = self.idlebframe end, 'fhook6') end, 'fhook5') end, 'fhook4') end, 'fhook3') end, 'fhook2') end, 'fhook1')
        end
        timer:after(speed, function() self.scale = 1.5 self.lframe = self.idleframe end)
    end
    local function ppat1()
        self.pattern = 'pat1'
        self.attacking = false
        print(self.pattern, self.stage)
        if self.stage == 1 then
            self.guard = {'ljab', 'rjab'}
            self.jab(1, 'l')
        end
        if self.stage == 2 then
            self.guard = {'ljab', 'rjab'}
            self.hook(1.5, 'r')
        end
        if self.stage == 3 then
            self.guard = {'lhook', 'rhook'}
            self.jab(1, 'r')
        end
        if self.stage == 4 then
            self.guard = {'lhook', 'rhook'}
            self.hook(1.5, 'l')
        end
        if self.stage == 5 then 
            self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.stage = 0
        end
    end
    local function ppat2()
        self.pattern = 'pat2'
        self.attacking = false
        print(self.pattern, self.stage)
        if self.stage == 1 then
            self.guard = {'lhook', 'rhook'}
            self.jab(1, 'l')
        end
        if self.stage == 2 then
            self.guard = {'lhook', 'rhook'}
            self.fhook(1.5, 'r')
        end
        if self.stage == 3 then
            self.guard = {'lhook', 'rhook'}
            self.fhook(1.5, 'l')
        end
        if self.stage == 4 then
            self.guard = {'lhook', 'rhook'}
            self.hook(1.5, 'l')
        end
        if self.stage == 5 then 
            self.attacking = true
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.stage = 0
        end
    end
    local function ppat3()
        self.pattern = 'pat3'
        self.attacking = false
        print(self.pattern, self.stage)
        if self.stage == 1 then
            self.guard = {'ljab', 'rjab', 'lhook', 'rhook'}
            self.jab(1, 'l')
        end
        if self.stage == 2 then
            self.guard = {'ljab', 'rjab', 'lhook', 'rhook'}
            self.jab(1, 'r')
        end
        if self.stage == 3 then
            self.guard = {'ljab', 'lhook', 'rhook'}
            self.jab(1, 'l')
        end
        if self.stage == 4 then
            self.guard = {'rjab', 'lhook', 'rhook'}
            self.fhook(1.5, 'r')
        end
        if self.stage == 5 then 
            self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.stage = 0
        end
    end

    local function ptaunt() 
        self.guard = {'none'}
        self.attacking = false
        self.tauntc = true
        self.pattern = nil
        self.stage = 0
        print('taunt')
    end

    local function pcounterpat(speed)
        self.tauntc = false
        self.gotem = false
        self.attacking = false
        self.pattern = nil
        self.stage = 0
        timer:after(0.5, function()
        self.jab(speed/4, 'l', 'up', true)
        timer:after(speed/4, function() self.jab(speed/4, 'r', 'up', true) timer:after(speed/2, function() self.hook(speed/2, 'l', 'none', true) end, 'cpat2') end, 'cpat1')
        timer:after(speed*1.3, function() if self.goagain then self.goagain = false self.tauntc = true self.attacking = true else self.stun(4.5) timer:after(6, function() self.attacking = true self.stage = 0 end) end end, 'cpat5') end, 'cpat4')
    end

    if self.type == 'sloth' then
        self.pat1 = spat1
        self.pat2 = spat2
        self.pat3 = spat3
        self.cancelall = cancelall 
        self.stun = stun
        self.jab = sjab
        self.hook = shook
        self.special = sspecial
    end
    if self.type == 'pride' then
        self.taunt = ptaunt
        self.cpat = pcounterpat
        self.fhook = pfhook
        self.pat1 = ppat1
        self.pat2 = ppat2
        self.pat3 = ppat3
        self.cancelall = cancelall 
        self.stun = stun
        self.jab = pjab
        self.hook = phook
        self.special = pspecial
    end
end

function Enemy:update(dt)
    if gamestates.roundstarted then
        if not self.downed then
            gamestates.timeelapsed = gamestates.timeelapsed + dt
        end

        if self.type == 'sloth' then
            if gamestates.timeelapsed > 4 then
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
                                timer:after(2, function() self.stage = 3 self.pat1() timer:after(4, function() self.stage = 4 self.pat1() end, 'pat13') end, 'pat12')
                            end
                            if self.stage == 3 then
                                timer:after(3, function() self.stage = 4 self.pat1() end, 'pat13')
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
                                timer:after(2, function() self.stage = 3 self.pat2() timer:after(4, function() self.stage = 4 self.pat2() end, 'pat23') end, 'pat22')
                            end
                            if self.stage == 3 then
                                timer:after(3, function() self.stage = 4 self.pat2() end, 'pat23')
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

        if self.type == 'pride' then
            if self.gotem then
                self.gotem = false
                print('gotem2')
                self.cpat(2)
            end
            if phpulse then
                phpulse = false
                self.goagain = true
            end
            if self.attacking then
                if self.attackpats <= 3 then
                    if self.tauntc then
                        self.taunt()
                    else
                        if not self.pattern then
                            local randompercent = random(0, 100)
                            print(randompercent)
                            if randompercent > 0 and randompercent < 31 then
                                self.pattern = 'pat1'
                            elseif randompercent > 31 and randompercent < 62 then
                                self.pattern = 'pat2'
                            elseif randompercent > 62 and randompercent < 93 then
                                self.pattern = 'pat3'
                            else
                                self.pattern = 'revert'
                            end
                        else
                            if self.pattern == 'pat1' then
                                self.attacking = false
                                if self.stage == 0 then
                                    self.stage = 1
                                    self.pat1()
                                end
                                if self.stage == 1 then
                                    timer:after(1.5, function() self.stage = 2 self.pat1() timer:after(1.5, function() self.stage = 3 self.pat1() timer:after(1.5, function() self.stage = 4 self.pat1()  timer:after(3, function() self.stage = 5 self.pat1()  end, 'pat14') end, 'pat13') end, 'pat12') end, 'pat11')
                                end
                                if self.stage == 2 then
                                    timer:after(2, function() self.stage = 3 self.pat1() timer:after(1.5, function() self.stage = 4 self.pat1() timer:after(3, function() self.stage = 5 self.pat1()  end, 'pat14') end, 'pat13') end, 'pat12')
                                end
                                if self.stage == 3 then
                                    timer:after(1, function() self.stage = 4 self.pat1() timer:after(3, function() self.stage = 5 self.pat1()  end, 'pat14') end, 'pat13')
                                end
                                if self.stage == 4 then
                                    timer:after(3, function() self.stage = 5 self.pat1()  end, 'pat14')
                                end
                            elseif self.pattern == 'pat2' then
                                self.attacking = false
                                if self.stage == 0 then
                                    self.stage = 1
                                    self.pat2()
                                end
                                if self.stage == 1 then
                                    timer:after(1.5+0.25, function() self.stage = 2 self.pat2() timer:after(1.5+0.25, function() self.stage = 3 self.pat2() timer:after(1.5+0.25, function() self.stage = 4 self.pat2()  timer:after(3, function() self.stage = 5 self.pat2()  end, 'pat24') end, 'pat23') end, 'pat22') end, 'pat21')
                                end
                                if self.stage == 2 then
                                    timer:after(2+0.25, function() self.stage = 3 self.pat2() timer:after(1.5+0.25, function() self.stage = 4 self.pat2() timer:after(3, function() self.stage = 5 self.pat2()  end, 'pat24') end, 'pat23') end, 'pat22')
                                end
                                if self.stage == 3 then
                                    timer:after(2+0.25, function() self.stage = 4 self.pat2() timer:after(3, function() self.stage = 5 self.pat2()  end, 'pat24') end, 'pat23')
                                end
                                if self.stage == 4 then
                                    timer:after(3, function() self.stage = 5 self.pat2()  end, 'pat24')
                                end
                            elseif self.pattern == 'pat3' then
                                self.attacking = false
                                if self.stage == 0 then
                                    self.stage = 1
                                    self.pat3()
                                end
                                if self.stage == 1 then
                                    timer:after(1.5, function() self.stage = 2 self.pat3() timer:after(1.5, function() self.stage = 3 self.pat3() timer:after(1.5, function() self.stage = 4 self.pat3()  timer:after(3, function() self.stage = 5 self.pat3()  end, 'pat34') end, 'pat33') end, 'pat32') end, 'pat31')
                                end
                                if self.stage == 2 then
                                    timer:after(2, function() self.stage = 3 self.pat3() timer:after(1.5, function() self.stage = 4 self.pat3() timer:after(3, function() self.stage = 5 self.pat3()  end, 'pat34') end, 'pat33') end, 'pat32')
                                end
                                if self.stage == 3 then
                                    timer:after(2, function() self.stage = 4 self.pat3() timer:after(3, function() self.stage = 5 self.pat3()  end, 'pat34') end, 'pat33')
                                end
                                if self.stage == 4 then
                                    timer:after(3, function() self.stage = 5 self.pat3()  end, 'pat34')
                                end
                            elseif self.pattern == 'revert' then
                                self.attacking = false
                                print(self.pattern)
                                timer:after(3, function() self.attacking = true self.tauntc = true self.pattern = nil self.stage = 0 end)
                            end
                        end
                    end
                else
                    self.attacking = false
                    print('special')
                    self.attackpats = 0
                    timer:after(4, function() self.attacking = true self.tauntc = true self.pattern = nil end)
                end
            end
        end
    end

    if not self.specialblock then
        for i=1, #self.guard do
            if self.guard[i] == 'rhook' or self.guard[i] == 'lhook' then
                self.idlebframe = 2
            elseif self.guard[i] == 'rjab' or self.guard[i] == 'ljab' then
                self.idlebframe = 13
            else
                self.idlebframe = 1
            end
        end
    end

    if self.lframe == 1 or self.lframe == 2 then
        self.lframe = self.idleframe
    end
    if self.bframe == 1 or self.bframe == 2 or self.bframe == 13 then
        self.bframe = self.idlebframe
    end

    if self.bframe == 2 then
        --self.lframe = 2
    elseif self.bframe == 5 then
        self.lframe = 3
    elseif self.bframe == 6 then
        self.lframe = 4
    elseif self.bframe == 12 or self.bframe == 14 then
        self.lframe = 5
    else
        --self.lframe = 1
    end

    if self.hitanim then
        self.bframe = 14
    end
    if not self.hitanim and self.bframe == 14 then
        self.bframe = self.idlebframe
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
        if not self.type == 'pride' then
            self.guard = self.guardstances[self.currentguard]
        end
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
                            if self.bframe == 1 or self.bframe == 2 or self.bframe == 4 or self.bframe == 6 or self.bframe == 8 or self.bframe == 9 or self.bframe == 10 or self.bframe == 11 then
                                    if collider_2.type == 'lhook' then
                                        self.bframe = 8
                                    end
                                    if collider_2.type == 'rhook' then
                                        self.bframe = 9
                                    end
                                    if collider_2.type == 'ljab' then
                                        self.bframe = 10
                                    end
                                    if collider_2.type == 'rjab' then
                                        self.bframe = 11
                                    end
                            end
                        timer:after(0.2, function() if self.bframe == 8 or self.bframe == 9 or self.bframe == 10 or self.bframe == 11 then self.bframe = self.idlebframe end end)
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
                if self.tauntc then
                    self.gotem = true
                    print('gotem1')
                else
                    self.guardtime = self.guardtime + 1.5
                    if self.hitcounts then
                        self.hitcounts = self.hitcounts + 1
                    end
                    self.hitlist[#self.hitlist+1] = {collider_2.type, collider_2.sp}

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
                    timer:after(0.15, function() self.hitanim = false end)
                    if self.specialblock then self.hp = self.hp - self.hp self.instadowned = true self.cancelall() self.attacking = true 
                self.attackpats = self.attackpats + 1
                self.pattern = nil
                self.specialblock = false
                self.stage = 0
                self.attackpats = 0 end
                    self.hp = self.hp - collider_2.damage
                    timer:tween(0.5, self, {display_hp = self.hp}, 'out-sine')
                end
            end
        end
    end)

    if self.hp <= 0 then
        self.downtimer = 0
        gamestates.round = gamestates.round - 1
        local downtime = 5
        if gamestates.round == 2 then
            downtime = math.ceil(random(0.0001, 4))
            
        elseif gamestates.round == 1 then
            local randompercent = random(0, 100)
            if randompercent < 90 then
                downtime = math.ceil(random(4, 8))
            else
                downtime = 10
            end
        elseif  gamestates.round == 0 then
            downtime = 10
        end
        if self.instadowned == true then
            if self.hitlist[#self.hitlist][2] then
                downtime = 10
            end
        end
        self.instadowned = false
        self.hp = 1
        self.cancelall()
        self.specialblock = true
        self.attacking = false
        self.bframe = self.idlebframe
        self.guard = {'ljab', 'rjab', 'lhook', 'rhook'}
        if gamestates.playerhp > gamestates.max_playerhp/1.5 then
            self.hp = self.maxhp
        else
            if self.type == 'sloth' then
                if gamestates.playerhp > gamestates.max_playerhp/3 then
                    self.hp = self.maxhp/2
                else
                    self.hp = self.maxhp/3
                end
            else
                self.hp = self.maxhp*0.85
            end
        end
        local direction = 0
        if self.hitlist[#self.hitlist][1] == 'rjab' or self.hitlist[#self.hitlist][1] == 'rhook' then
            direction = -300
        else
            direction = 300
        end
        self.downed = true
        if downtime == 10 then
            self.stun(downtime, 1)
            if Gameselect == 'TA' then
                timer:after(downtime, function() self.dead = true self.cancelall() timer:after(2, function() savescore(self.type .. 'LB.json', Username, gamestates.timeelapsed, 'less') gotoRoom('ScoreScreen') end)end)
            end
            if Gameselect == 'campaign' then
                timer:after(downtime, function() self.dead = true self.cancelall() timer:after(2, function() gotoRoom('ScoreScreen') end)end)
            end
            timer:tween(0.5, self.vy, {y=15}, 'out-sine')
            timer:after(0.5,function() timer:tween(0.5, self.vy, {y=0}, 'out-sine') end)
            timer:tween(1, self.vx, {x=direction}, 'out-sine')
            for i=1, downtime do
                timer:after(i, function() self.downtimer = self.downtimer + 1
                local randompercent2 = random(0, 100)
                    if randompercent2 > 80-(i*5) then
                        print('struggle')
                    end
                 end)
            end
        else
            self.stun(downtime+3.5, 1)
            timer:tween(0.5, self.vy, {y=15}, 'out-sine')
            timer:after(0.5,function() timer:tween(0.5, self.vy, {y=0}, 'out-sine') end)
            timer:tween(1, self.vx, {x=direction}, 'out-sine')
            timer:after(downtime, function() timer:tween(1, self.vy, {y=self.sy}, 'out-sine') end)
            timer:after(downtime, function() timer:tween(1, self.vx, {x=self.sx}, 'out-sine') end)
            for i=1, downtime do
                timer:after(i, function() self.downtimer = self.downtimer + 1
                local randompercent2 = random(0, 100)
                    if randompercent2 > 60 then
                        print('struggle')
                    end
                 end)
                
            end

            timer:after(downtime, function() timer:tween(1, self, {display_hp = self.hp}, 'out-sine') end)
            timer:after(downtime+3, function() self.attacking = true 
            self.attackpats = self.attackpats + 1
            self.pattern = nil
            self.specialblock = false
            self.guard = self.guardstances[self.currentguard]
            self.stage = 0
            self.attackpats = 0 self.downed = false  self.downtimer = 0 self.cancelall() end)
        end
    end
    enemyx, enemyy = self.x, self.y
end

function Enemy:draw()
    if self.hitanim then
        love.graphics.rectangle('fill', self.x, self.y-200, 50, 50)
    end
    if self.legImage then
        love.graphics.draw(self.legImage, self.lquads[self.lframe], self.x, self.y, 0, self.scale, 1.5, self.IW/2, self.IH/2)
    end
    love.graphics.draw(self.image, self.quads[self.bframe], self.x, self.y, 0, self.scale, 1.5, self.IW/2, self.IH/2)
    if Debug_Vision then
        love.graphics.print(self.hp, -gw/2, (-gh/2)+60)
        love.graphics.print(tostring(self.guardtime), -gw/2, (-gh/2)+120)
        love.graphics.print(tostring(self.currentguard), -gw/2, (-gh/2)+(140))
        for i=1, #self.guard do
            love.graphics.print(tostring(self.guard[i]), -gw/2, (-gh/2)+(140+(i*20)))
        end
        love.graphics.print(tostring(self.downtimer), -gw/2+100, (-gh/2)+20)
    end

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+80, 200, 20)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', -gw/2 + 100, (-gh/2)+80, (self.display_hp / self.maxhp) * 200, 20)
    love.graphics.setColor(1, 1, 1)
end
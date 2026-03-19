Room = GameObject:extend()

function Room:new(area, x, y, opts)
    Room.super.new(self, area, x, y, opts)
    self.x = x
    self.y = y
    self.id = opts.id
    self.area = area
    self.enterance = {}
    self.start = false
    DoorDestroy = false
    if self.id == 1 then
        self.area:addGameObject('Wall', x-300, y+300, {w=200, h=25})
        self.area:addGameObject('Wall', x+100, y+300, {w=200, h=25})

        self.area:addGameObject('Wall', x-300, y-300, {w=25, h=600})

        self.area:addGameObject('Wall', x-300, y-300, {w=600, h=25})

        self.area:addGameObject('Wall', x+300, y-300, {w=25, h=625})

        --self.area:addGameObject('Wall', x+300-50, y-100-50, {w=100, h=100})
        --self.area:addGameObject('Wall', x-300-50, y+100-50, {w=100, h=100})

        self.waves = {0}
        self.enterance = {{x = 0, y = 0, w = 0, h = 0}}
        self.door = {x = 0, y = 0, w = 0, h = 0}
    elseif self.id == 2 then
        self.area:addGameObject('Wall', x-500, y-300, {w=400, h=25})
        self.area:addGameObject('Wall', x+100, y-300, {w=400, h=25})
        
        self.area:addGameObject('Wall', x-500, y+300, {w=400, h=25})
        self.area:addGameObject('Wall', x+100, y+300, {w=400, h=25})

        self.area:addGameObject('Wall', x+500, y-300, {w=25, h=200})
        self.area:addGameObject('Wall', x+500, y+100, {w=25, h=225})

        self.area:addGameObject('Wall', x-500, y-300, {w=25, h=200})
        self.area:addGameObject('Wall', x-500, y+100, {w=25, h=225})

        self.area:addGameObject('Wall', x-300-50, y-100-50, {w=100, h=100})
        self.area:addGameObject('Wall', x+300-50, y+100-50, {w=100, h=100})

        self.enterance = {{x = x-500, y = y-300+155, w = 1000, h = 5}, {x = x-500+150, y = y-300, w = 5, h = 600}, {x = x+300+100, y = y-300, w = 5, h = 600}, {x = x-500+45, y = y+100+50, w = 1000, h = 5}}
        self.door = {{x = x-100, y = y-300, w = 200, h = 25}, {x = x-500, y = y-100, w = 25, h = 200}, {x = x-100, y = y+300, w = 200, h = 25}, {x = x+500, y = y-100, w = 25, h = 200}}
        self.Barea = {x=x-500, y=y-300, w=1025,h=625}
        self.waves = {2, 
            function() self.area:addGameObject('Summoner', self.x-500+75, self.y-300+75, {type='gunner', hp = 10}) self.area:addGameObject('Summoner', self.x+500-50, self.y+300-50, {type='gunner', hp = 10}) end,
            function() self.area:addGameObject('Summoner', self.x, self.y+100, {type='basic', hp = 5}) end}
    elseif self.id == 3 then
        self.area:addGameObject('Wall', x-500, y+300, {w=1000, h=25})
        
        self.area:addGameObject('Wall', x-500, y, {w=700, h=25})
        self.area:addGameObject('Wall', x+400, y, {w=125, h=25})

        self.area:addGameObject('Wall', x+500, y, {w=25, h=325})

        self.area:addGameObject('Wall', x-500, y+25, {w=25, h=25+25/2})
        self.area:addGameObject('Wall', x-500, y+250+25/2, {w=25, h=25+25/2})

        self.area:addGameObject('Wall', x-175, y+150, {w=25, h=150})
        self.area:addGameObject('Wall', x+175, y+25, {w=25, h=150})

        self.enterance = {{x = x-400, y = y, w = 5, h = 350}, {x = x-350, y = y+125, w = 850, h = 5}}
        self.door = {{x = x-500, y = y+75-25/2, w = 25, h = 200}, {x = x+200, y = y, w = 200, h = 25}}
        self.Barea = {x=x-500, y=y, w=1025,h=325}
        self.waves = {2, function() self.area:addGameObject('Summoner', self.x, self.y+150, {type='leap', hp=5}) self.area:addGameObject('Summoner', self.x+400, self.y+250, {type='gunner', hp = 8}) self.area:addGameObject('Summoner', self.x-400, self.y+50, {type='gunner', hp = 8}) end, function() self.area:addGameObject('Summoner', self.x+400, self.y+250, {type='gunner', hp = 5}) self.area:addGameObject('Summoner', self.x-400, self.y+50, {type='gunner', hp = 5}) end}
    end
end

function Room:update(dt)
    if self.start == false then
        if not self.finished then
            if self.waves[1] > 0 then
                if self.waves[1] == #self.waves -1 then
                    for i=1, #self.enterance do
                        self.colliders = self.area.world:queryRectangleArea(self.enterance[i].x, self.enterance[i].y, self.enterance[i].w, self.enterance[i].h, {'Player'})
                        if self.colliders[1] then
                            print('enter', self.id)
                            self.waves[self.waves[1]+1]()
                            self.summoning = true
                            timer:after(1.1, function() self.summoning = false end)
                            for i=1, #self.enterance do
                                self.area:addGameObject('Wall', self.door[i].x, self.door[i].y, {w=self.door[i].w, h=self.door[i].h, door=true})
                            end
                            self.start = true
                        end
                    end
                else
                    print(self.id, "cont.")
                    self.waves[self.waves[1]+1]()
                    for i=1, #self.enterance do
                        self.area:addGameObject('Wall', self.door[i].x, self.door[i].y, {w=self.door[i].w, h=self.door[i].h, door=true})
                    end
                    self.start = true
                end
            end
        end
    end
    if self.start then
        if self.summoning == false then
            self.colliders = self.area.world:queryRectangleArea(self.Barea.x, self.Barea.y, self.Barea.w, self.Barea.h, {'Enemy'})
            if not self.colliders[1] then
                self.start = false 
                self.waves[1] = self.waves[1] - 1
                if self.waves[1] <= 0 then
                    DoorDestroy = true
                    self.finished = true
                    print('gotem')
                end
            end
        end
    end
end

function Room:draw()

end
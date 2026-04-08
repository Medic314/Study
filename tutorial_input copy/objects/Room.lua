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
        self.area:addGameObject('Wall', x, y+(24*tile), {w=(8*tile), h=tile})
        self.area:addGameObject('Wall', x+(16*tile), y+(24*tile), {w=(8*tile), h=tile})

        self.area:addGameObject('Wall', x, y, {w=tile, h=(24*tile)})

        self.area:addGameObject('Wall', x, y, {w=(24*tile), h=tile})

        self.area:addGameObject('Wall', x+(24*tile), y, {w=tile, h=(25*tile)})

        --self.area:addGameObject('Wall', x+300-50, y-100-50, {w=100, h=100})
        --self.area:addGameObject('Wall', x-300-50, y+100-50, {w=100, h=100})

        self.waves = {0}
        self.enterance = {{x = 0, y = 0, w = 0, h = 0}}
        self.door = {x = 0, y = 0, w = 0, h = 0}
    elseif self.id == 2 then
        self.Barea = {x=x, y=y, w=(41*tile),h=(25*tile)}
        self.area:addGameObject('Wall', x, y, {w=self.Barea.w, h=self.Barea.h, nc = true, tileskin='tilebg'})

        self.area:addGameObject('Wall', x, y, {w=(16*tile), h=tile})
        self.area:addGameObject('Wall', x+(24*tile), y, {w=(16*tile), h=tile})
        
        self.area:addGameObject('Wall', x, y+(24*tile), {w=(16*tile), h=tile})
        self.area:addGameObject('Wall', x+(24*tile), y+(24*tile), {w=(16*tile), h=tile})

        self.area:addGameObject('Wall', x+(40*tile), y, {w=tile, h=(8*tile)})
        self.area:addGameObject('Wall', x+(40*tile), y+(16*tile), {w=tile, h=(9*tile)})

        self.area:addGameObject('Wall', x, y, {w=tile, h=(8*tile)})
        self.area:addGameObject('Wall', x, y+(16*tile), {w=tile, h=(9*tile)})

        self.area:addGameObject('Wall', x+(5*tile), y+(5*tile), {w=(5*tile), h=(4*tile), tileskin='shelf'})
        self.area:addGameObject('Wall', x+(10*tile), y+(6*tile), {w=(4*tile), h=(3*tile), tileskin='shelf1'})
        self.area:addGameObject('Wall', x+(32*tile), y+(16*tile), {w=(5*tile), h=(4*tile), tileskin='shelf'})
        self.area:addGameObject('Wall', x+(27*tile), y+(17*tile), {w=(4*tile), h=(3*tile), tileskin='shelf1'})

        self.enterance = {{x = x, y = y+(6*tile), w = (40*tile), h = 5}, {x = x+(34*tile), y = y, w = 5, h = (24*tile)}, {x = x+(6*tile), y = y, w = 5, h = (24*tile)}, {x = x, y = y+(18*tile), w = (40*tile), h = 5}}
        self.door = {{x = x+(16*tile), y = y+(24*tile), w = (8*tile), h = tile}, {x = x, y = y+(8*tile), w = tile, h = (8*tile)}, {x = x+(16*tile), y = y, w = (8*tile), h = tile}, {x = x+(40*tile), y = y+(8*tile), w = tile, h = (8*tile)}}
        self.waves = {2, 
            function() self.area:addGameObject('Summoner', self.x+(3*tile), self.y+(3*tile), {type='gunner', hp = 8}) self.area:addGameObject('Summoner', self.x+(37*tile), self.y+(22*tile), {type='gunner', hp = 8}) end,
            function() self.area:addGameObject('Summoner', self.x+(20*tile), self.y+(12*tile), {type='basic', hp = 5}) end}
        self.special = {types = {'shotgunner'}, waves = {2}}
    elseif self.id == 3 then
        self.Barea = {x=x, y=y, w=(41*tile),h=(14*tile)}
        self.area:addGameObject('Wall', x, y, {w=self.Barea.w, h=self.Barea.h, nc = true, tileskin='tilebg'})

        self.area:addGameObject('Wall', x, y+(13*tile), {w=(40*tile), h=tile})
        
        self.area:addGameObject('Wall', x, y, {w=(28*tile), h=tile})
        self.area:addGameObject('Wall', x+(36*tile), y, {w=(4*tile), h=tile})

        self.area:addGameObject('Wall', x+(40*tile), y, {w=tile, h=(14*tile)})

        self.area:addGameObject('Wall', x, y+tile, {w=tile, h=(2*tile)})
        self.area:addGameObject('Wall', x, y+(11*tile), {w=tile, h=(2*tile)})

        self.area:addGameObject('Wall', x+(12*tile), y+(5*tile), {w=tile*2, h=(6*tile), tileskin = 'shelf2'})
        self.area:addGameObject('Wall', x+(9*tile), y+(5*tile), {w=tile*2, h=(6*tile), tileskin = 'shelf2'})
        self.area:addGameObject('Wall', x+(26*tile), y+tile, {w=tile*2, h=(6*tile), tileskin = 'shelf2'})

        self.enterance = {{x = x+(4*tile), y = y, w = 5, h = (14*tile)}, {x = x+(5*tile), y = y+(5*tile), w = (30*tile), h = 5}}
        self.door = {{x = x, y = y+(3*tile), w = tile, h = (8*tile)}, {x = x+(28*tile), y = y, w = (8*tile), h = tile}}
        self.waves = {2, function() self.area:addGameObject('Summoner', self.x+(20*tile), self.y+(6*tile), {type='leap', hp=5})  self.area:addGameObject('Summoner', self.x+(22*tile), self.y+(8*tile), {type='leap', hp=5}) self.area:addGameObject('Summoner', self.x+(18*tile), self.y+(8*tile), {type='leap', hp=5}) end,
        function() self.area:addGameObject('Summoner', self.x+(3*tile), self.y+(3*tile), {type='gunner', hp = 8}) self.area:addGameObject('Summoner', self.x+(38*tile), self.y+(12*tile), {type='gunner', hp = 8}) end}
    elseif self.id == 4 then
        self.Barea = {x=x, y=y, w=(45*tile),h=(45*tile)}
        self.area:addGameObject('Wall', x, y, {w=self.Barea.w, h=self.Barea.h, nc = true, tileskin='tilebg'})

        self.area:addGameObject('Wall', x, y+(45*tile), {w=(45*tile), h=tile})
        
        self.area:addGameObject('Wall', x, y, {w=(19*tile), h=tile})
        self.area:addGameObject('Wall', x+(27*tile), y, {w=(18*tile), h=tile})

        self.area:addGameObject('Wall', x+(45*tile), y, {w=tile, h=(45*tile)})
        self.area:addGameObject('Wall', x, y, {w=tile, h=(45*tile)})

        self.area:addGameObject('Wall', x+(17*tile), y+(20*tile), {w=(5*tile), h=(4*tile), tileskin='shelf'})
        self.area:addGameObject('Wall', x+(23*tile), y+(22*tile), {w=(5*tile), h=(4*tile), tileskin='shelf'})
        self.area:addGameObject('Wall', x+(19*tile), y+(26*tile), {w=(4*tile), h=(3*tile), tileskin='shelf1'})
        
        self.area:addGameObject('Wall', x+(15*tile), y+(20*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        
        self.area:addGameObject('Wall', x+(40*tile), y+(7*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(37*tile), y+(7*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(35*tile), y+(8*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(32*tile), y+(7*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(29*tile), y+(7*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(24*tile), y+(7*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        
        self.area:addGameObject('Wall', x+(3*tile), y+(34*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(6*tile), y+(39*tile), {w=(3*tile), h=(4*tile), tileskin='shelf1'})
        
        self.area:addGameObject('Wall', x+(42*tile), y+(34*tile), {w=(2*tile), h=(6*tile), tileskin='shelf2'})
        self.area:addGameObject('Wall', x+(37*tile), y+(39*tile), {w=(3*tile), h=(4*tile), tileskin='shelf1'})

        self.enterance = {{x = x, y = y+(5*tile), w = (45*tile), h = 5}}
        self.door = {{x = x+(19*tile), y = y, w = (8*tile), h = tile}}
        self.waves = {3, function() self.area:addGameObject('Summoner', self.x+(23*tile), self.y+(6*tile), {type='trenchcoat', hp=15}) end,

        function() self.area:addGameObject('Summoner', self.x+(8*tile), self.y+(8*tile), {type='shotgunner', hp = 8}) 
        self.area:addGameObject('Summoner', self.x+(10*tile), self.y+(25*tile), {type='leap', hp = 5})
        self.area:addGameObject('Summoner', self.x+(8*tile), self.y+(25*tile), {type='leap', hp = 5})
        self.area:addGameObject('Summoner', self.x+(32*tile), self.y+(25*tile), {type='leap', hp = 5})
        self.area:addGameObject('Summoner', self.x+(35*tile), self.y+(25*tile), {type='leap', hp = 5}) end,

        function() self.area:addGameObject('Summoner', self.x+(8*tile), self.y+(8*tile), {type='trenchcoat', hp = 15}) 
        self.area:addGameObject('Summoner', self.x+(20*tile), self.y+(35*tile), {type='sentry', hp = 10})
        self.area:addGameObject('Summoner', self.x+(25*tile), self.y+(35*tile), {type='sentry', hp = 10}) end}

        self.special = {types = {'sentry'}, waves = {3}}
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
                                --self.area:addGameObject('Wall', self.enterance[i].x, self.enterance[i].y, {w=self.enterance[i].w, h=self.enterance[i].h, door=true})
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

            if self.special then
                local sn = 0
                for i=1, #self.colliders do
                    for j=1, #self.special.types do
                        if self.colliders[i].type == self.special.types[j] then
                            if self.special.waves[j] == self.waves[1] then
                                sn = sn + 1
                            end
                        end
                        if sn == #self.colliders then
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
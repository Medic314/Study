Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    if self.world then self.world:update(dt) end

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then 
            game_object:destroy()
            table.remove(self.game_objects, i) 
        end
    end
end

function Area:draw()
    if self.world then if Debug_Vision == true then self.world:draw() end end
    local ui, fore, main, back = {}, {}, {}, {}
    for _, game_object in ipairs(self.game_objects) do
        if game_object.layer == 'ui' then
            table.insert(ui, game_object)
        end
        if game_object.layer == 'foreground' then
            table.insert(fore, game_object)
        end
        if game_object.layer == 'main layer' then
            table.insert(main, game_object)
        end
        if game_object.layer == 'background' then
            table.insert(back, game_object)
        end
    end
    for _, game_object in ipairs(back) do
        game_object:draw()
    end
    for _, game_object in ipairs(main) do
        game_object:draw()
    end
    for _, game_object in ipairs(fore) do
        game_object:draw()
    end
    for _, game_object in ipairs(ui) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:addPhysicsWorld()
    self.world = Physics.newWorld(0, 0, true)
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:destroy()
        table.remove(self.game_objects, i)
    end
    self.game_objects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end
end
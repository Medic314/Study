zBasicenemy = Enemy:extend()

function zBasicenemy:new(area, x, y, opts)
    zBasicenemy.super.new(self, area, x, y, opts)
end

function zBasicenemy:update(dt)
    zBasicenemy.super.new(self, dt)
end

function zBasicenemy:draw()
    zBasicenemy.super.new(self)
end
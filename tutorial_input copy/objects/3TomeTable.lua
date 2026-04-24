TTo = GameObject:extend()

function TTo:new(area, x, y, opts)
    TTo.super.new(self, area, x, y, opts)
    TT = {
        DefaultTome = {
            Act1={cooldown = 10/playerCooldown, type='ability', func=function() if not activeitemactive then activeitemactive = true for i=1, 24 do self.area:addGameObject('Bullet', PlayerX, PlayerY, {rot=i-1, type='basic', shape='circle'}) end timer:after(10/playerCooldown, function() activeitemactive = false end) end end},
            Act2={cooldown = 20/playerCooldown, type='timer', func=function() if not activeitemactive then activeitemactive = true TomeBuffs.BulletSpeed = TomeBuffs.BulletSpeed + 0.5 TomeBuffs.Attackspeed = TomeBuffs.Attackspeed + 3 timer:after(5, function() TomeBuffs.BulletSpeed = TomeBuffs.BulletSpeed - 0.5 TomeBuffs.Attackspeed = TomeBuffs.Attackspeed - 3 end) timer:after(20/playerCooldown, function() activeitemactive = false end) end end},
            Act3={cooldown = 20/playerCooldown, type='timer', func=function() if not activeitemactive then activeitemactive = true TomeBuffs.scale = TomeBuffs.scale + 0.2 TomeBuffs.Speed = TomeBuffs.Speed + 0.2 timer:after(5, function() TomeBuffs.scale = TomeBuffs.scale - 0.2 TomeBuffs.Speed = TomeBuffs.Speed - 0.2 end) timer:after(20/playerCooldown, function() activeitemactive = false end) end end},
            TopPath = {Up1=function() print('tup1') TomeBuffs.Damage = TomeBuffs.Damage + 0.5 end, Up2=function() print('tup2') activeitem = TT.DefaultTome.Act1 end, Up3=function() print('tup3') end},
            MidPath = {Up1=function() print('mup1') TomeBuffs.Attackspeed = TomeBuffs.Attackspeed + 0.5 end, Up2=function() print('mup2') activeitem = TT.DefaultTome.Act2 end, Up3=function() print('mup3') end},
            BotPath = {Up1=function() print('bup1') TomeBuffs.Speed = TomeBuffs.Speed + 0.2 end, Up2=function() print('bup2') activeitem = TT.DefaultTome.Act3 end, Up3=function() print('bup3') end},
            image = ST['DefaultTome'],
            name = "DefaultTome"
        }
    }
end
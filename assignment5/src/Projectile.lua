--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init()
end

function Projectile:update(dt)
  GameObject.update(self, dt)
end

function Projectile:render()
  GameObject.render(self)
end

--[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    self.locked = def.locked
    self.if_flag = def.if_flag
    self.currentAnimation = def.currentAnimation
end

function GameObject:collides(target)
    return not (target.x + 3 > self.x + self.width or self.x > target.x + target.width - 3 or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
  if self.if_flag then
    self.currentAnimation:update(dt)
  end
end

function GameObject:render()
  if self.if_flag then
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()], self.x, self.y)
  else
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
  end
end

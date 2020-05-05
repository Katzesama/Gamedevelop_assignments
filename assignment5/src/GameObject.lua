--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.consumable = def.consumable

    self.defaultState = def.defaultState or 1
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
    self.onConsume = function() end
end

function GameObject:update(dt)

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:fire(direction)
  self.crushed = false
  local max_distance = 4 * TILE_SIZE
  local shiftX, shiftY = self.x, self.y

  if direction == 'left' then
    shiftX = math.max(self.x - max_distance, MAP_RENDER_OFFSET_X + self.height / 2)
  elseif direction == 'right' then
    shiftX = math.min(self.x + max_distance, VIRTUAL_WIDTH  - TILE_SIZE / 2 - self.width / 2)
  elseif direction == 'up' then
    shiftY = math.max(self.y - max_distance, MAP_RENDER_OFFSET_Y - self.height / 2)
  elseif direction == 'down' then
    shiftY = math.min(self.y + max_distance, VIRTUAL_WIDTH - TILE_SIZE)
  end

  Timer.tween(0.5, {
      [self] = {x = shiftX, y = shiftY}
  }):finish(function()
    self.state = 'broken'
    Timer.after(0.5, function()
      self.crushed = true
    end)
  end)
end

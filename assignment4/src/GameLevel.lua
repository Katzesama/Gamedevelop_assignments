--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(entities, objects, tilemap, level)
    self.entities = entities
    self.objects = objects
    self.tileMap = tilemap
    self.flagframe = math.random(#FLAGS)
    self.currentLevel = level or 1
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function GameLevel:clear()
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    for i = #self.entities, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end
end

function GameLevel:update(dt)
    self.tileMap:update(dt)

    for k, object in pairs(self.objects) do
        object:update(dt)
    end

    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end
end

function GameLevel:render()
    self.tileMap:render()

    for k, object in pairs(self.objects) do
        object:render()
    end

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end

function GameLevel:spawnFlag()
  table.insert(self.objects, self:generatePole())
  table.insert(self.objects, self:generateFlag())
end

function GameLevel:generateFlag()
  return GameObject {
      texture = 'flags',
      x = (self.tileMap.width - 1) * TILE_SIZE - 9,
      y = (4 - 1) * TILE_SIZE + 5,
      width = 16,
      height = 16,
      if_flag = true,

      currentAnimation = Animation{
        frames = {
          1 + 3 * (self.flagframe - 1),
          2 + 3 * (self.flagframe - 1),
          3 + 3 * (self.flagframe - 1)
        },
        interval = 0.3
      },
      collidable = false,
      solid = false
  }
end

function GameLevel:generatePole()
  return GameObject {
      texture = 'poles',
      x = (self.tileMap.width - 2) * TILE_SIZE,
      y = (4 - 1) * TILE_SIZE,
      width = 16,
      height = 64,

      -- make it a random variant
      frame = math.random(#POLES),
      collidable = true,
      consumable = true,
      solid = false,

      onConsume = function(player, object)
        gSounds['powerup-reveal']:play()
        gStateMachine:change('play', player)
      end
  }
end

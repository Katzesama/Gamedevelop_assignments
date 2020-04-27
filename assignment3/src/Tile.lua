--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)

    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.shiny = math.random(25) == 1 and true or false

    if self.shiny then
      -- from assignment 2, add particle system for the shiny effect
      self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

      -- various behavior-determining functions for the particle system
      -- https://love2d.org/wiki/ParticleSystem

      -- lasts between 0.5-1 seconds seconds
      self.psystem:setParticleLifetime(0.5, 1)

      -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
      -- gives generally downward
      self.psystem:setLinearAcceleration(-1, -1, 1, 1)

      -- spread of particles; normal looks more natural than uniform
      self.psystem:setAreaSpread('normal', 5, 5)

      Timer.every(0.5, function()
          self.psystem:emit(2)
      end)

      self.psystem:setColors(
          243,
          240,
          240,
          80,
          255,
          255,
          255,
          0
      )
    end

end

function Tile:update(dt)
  if self.shiny then
    self.psystem:update(dt)
  end
end

function Tile:render(x, y)

    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.shiny then
      love.graphics.draw(self.psystem, self.x + x + 16, self.y + y + 16)
    end
end

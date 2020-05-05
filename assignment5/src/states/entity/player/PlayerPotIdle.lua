PlayerPotIdle = Class{__includes = EntityIdleState}

function PlayerPotIdle:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    self.pot = params

    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)
end

function PlayerPotIdle:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerPotIdle:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk', self.pot)
    end

    if love.keyboard.wasPressed('space') then
        -- throw the pot
        Event.dispatch('throw-pot', {pot = self.pot, direction = self.entity.direction})
        self.entity:changeState('idle')
        self.entity.has_pot = false
    end

    -- update the pot's position so it will stick with the player
    self.pot.x = self.entity.x
    self.pot.y = self.entity.y - self.pot.height + 4
end

function PlayerPotIdle:render()
  EntityIdleState.render(self)
  self.pot:render(0, 0)
end

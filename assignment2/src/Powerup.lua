--[[
    -- Powerup Class --
    Represents a powerup which will descend and if it collides
    with the player's paddle, and two more balls will be activate.
    if the level has a locked brick, there will be a key powerup,
    to unlock the brick.
]]

Powerup = Class{}

function Powerup:init()
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    -- x and y position of the powerup
    self.x = math.random(20, VIRTUAL_WIDTH-20)
    self.y = 110 + math.random(-10, 35)

    -- used to determine whether this powerup should be rendered
    self.inPlay = false

    self.velocity = 20

    -- used to count the timer whether this powerup should be rendered
    self.timer = 0

    -- 9 for the balls up, 10 for key
    self.skin = 9
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the powerup randomly below the bricks
]]
function Powerup:reset()
    self.x = math.random(20, VIRTUAL_WIDTH-20)
    self.y = 110 + math.random(-10, 35)
    self.timer = 0
    self.inPlay = false
    self.skin = 9
end

function Powerup:update(dt)
    self.y = self.y + self.velocity * dt
end

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- PowerupgFrames is a table of quads mapping to each individual powerup skin in the texture
    if self.inPlay then
      love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin],
        self.x, self.y)
    end
end

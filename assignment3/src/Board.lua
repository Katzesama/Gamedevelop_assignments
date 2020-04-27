--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.matches = {}
    self.level = level or 1
    self.color_set = {
      [1] = math.random(2) == 1 and 1 or 3,
      [2] = math.random(2) == 1 and 2 or 4,
      [3] = math.random(2) == 1 and 5 or 7,
      [4] = math.random(2) == 1 and 6 or 8,
      [5] = math.random(2) == 1 and 9 or 11,
      [6] = math.random(2) == 1 and 10 or 12,
      [7] = math.random(13, 15),
      [8] = math.random(16, 18)
    }
    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do

        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do

            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, self.color_set[math.random(8)], math.random(self.level % 7)))
        end
    end

    while self:calculateMatches() do

        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    local shinyRow = {
      [1] = false,
      [2] = false,
      [3] = false,
      [4] = false,
      [5] = false,
      [6] = false,
      [7] = false,
      [8] = false
    }

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1

        -- every horizontal tile
        for x = 2, 8 do
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])

                        -- if there is one shiny block then add the entire row to the match
                        -- the blocks already matches can be double scored
                        if self.tiles[y][x2].shiny then
                          shinyRow[y] = true
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])

                if self.tiles[y][x].shiny then
                  shinyRow[y] = true
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do

                        -- if the block has already been cancelled due to the shiny blocks, ignore it
                        -- if not add the matched blocks and detect if there is a shiny block
                        if not shinyRow[y2] then
                          table.insert(match, self.tiles[y2][x])
                          if self.tiles[y2][x].shiny then
                            shinyRow[y2] = true
                          end
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
              if not shinyRow[y2] then
                table.insert(match, self.tiles[y][x])
                if self.tiles[y][x].shiny then
                  shinyRow[y] = true
                end
              end
            end

            table.insert(matches, match)
        end
    end

    -- add the row that has shiny blocks and has 3 or more matched blocks
    for y = 1, 8 do
      local match = {}
      if shinyRow[y] then
        for x = 1, 8 do
          table.insert(match, self.tiles[y][x])
        end
        table.insert(matches, match)
      end
    end
    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do

            -- if our last tile was a space...
            local tile = self.tiles[y][x]

            if space then

                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then

                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = Tile(x, y,self.color_set[math.random(8)], math.random(self.level % 7))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

--[[ This function will update the particle effect if
  the tile is shiny]]
function Board:update(dt)
  for y = 1, #self.tiles do
      for x = 1, #self.tiles[1] do
          self.tiles[y][x]:update(dt)
      end
  end
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end

--[[
    Check if the four directions from this tile will have any match.
    We only need to check the 2 blocks above, down, left and right to the
    tile we passed in. Since the match number only needs to be equal or
    greater than 3.
]]
function Board:ifMatch(x, y)
  local matchNum = 0
  local colorToMatch = self.tiles[y][x].color

  -- check vertically
  for r = math.max(y - 2, 1), math.min(y + 2, 8) do
    if self.tiles[r][x].color == colorToMatch then
        matchNum = matchNum + 1
        if matchNum >= 3 then
          return true
        end
    else
      matchNum = 0
    end
  end

  matchNum = 0

  --check horizontally
  for c = math.max(x - 2, 1), math.min(x + 2, 8) do
    if self.tiles[y][c].color == colorToMatch then
        matchNum = matchNum + 1
        if matchNum >= 3 then
          return true
        end
    else
      matchNum = 0
    end
  end

  return false
end

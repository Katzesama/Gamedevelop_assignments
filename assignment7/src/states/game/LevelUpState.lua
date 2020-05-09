levelUpState = Class{__includes = BaseState}

function levelUpState:init(def, onComplete)
    self.statMenu = Menu {
        x = VIRTUAL_WIDTH - 200,
        y = VIRTUAL_HEIGHT - 64 - 120,
        width = 200,
        height = 130,
        cursor_on = false,
        items = {
            {
                text = 'HP  ' .. tostring(def.O_HP) .. ' + ' .. tostring(def.HPIncrease) .. ' = ' .. tostring(def.O_HP+def.HPIncrease)
            },
            {
                text = 'Attack ' .. tostring(def.O_attack) .. ' + ' .. tostring(def.attackIncrease) .. ' = ' .. tostring(def.O_attack+def.attackIncrease)
            },
            {
                text = 'Defense ' .. tostring(def.O_defense) .. ' + ' .. tostring(def.defenseIncrease) .. ' = ' .. tostring(def.O_defense+def.defenseIncrease)
            },
            {
                text = 'Speed ' .. tostring(def.O_speed) .. ' + ' .. tostring(def.speedIncrease) .. ' = ' .. tostring(def.O_speed+def.speedIncrease)
            }
        }
    }

    self.onComplete = onComplete or function() end
end

function levelUpState:update(dt)
    self.statMenu:update(dt)

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      gStateStack:pop()
      self.onComplete()
    end
end

function levelUpState:render()
    self.statMenu:render()
end

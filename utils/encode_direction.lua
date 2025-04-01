local command_constants = require "constants.command"

encode_direction = {}

---@param x number
---@param y number
---@return string
function encode_direction.axis(x , y)
  -- Neutro
  if math.abs(x) < 0.5 and math.abs(y) < 0.5 then
      return '5' 
  end
  
  ---@type number
  local angle = math.atan2(y, x)
  ---@type number
  local dir = math.floor((angle + math.pi) * 8 / (2 * math.pi) + 0.5) % 8
  ---@type string[] 
  local directions = {'4', '7', '8', '9', '6', '3', '2', '1'}
  return directions[dir + 1]
end

---@param dpad_inputs string[]
---@return string
function encode_direction.dpad(dpad_inputs)
  if #dpad_inputs == 0 or #dpad_inputs > 2 then
    return "5"
  end

  if #dpad_inputs == 1 then
    local cur_input = dpad_inputs[1]
    if cur_input == 'dpup' then
      return "8"
    end

    if cur_input == 'dpdown' then
      return "2"
    end

    if cur_input == "dpleft" then
      return "4"
    end

    if cur_input == "dpright" then
      return "6"
    end
  end

  if #dpad_inputs == 2 then
    local dpad_diagonals = command_constants.dpad_diagonals
    local str_cur_inp = table.concat(dpad_inputs, ",")
    if  string.find(dpad_diagonals.left_up, str_cur_inp) then
      return "7"
    end

    if string.find(dpad_diagonals.right_up, str_cur_inp) then
      return "9"
    end

    if string.find(dpad_diagonals.left_down, str_cur_inp) then
      return "1"
    end

    if string.find(dpad_diagonals.right_down, str_cur_inp) then
      return "3"
    end
  end

  return "5"
end

return encode_direction
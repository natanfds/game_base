if arg[2] == "debug" then
  require("lldebugger").start()
end

local input = require 'handlers.input'
local buttons = require 'constants.buttons'
local input_config = require 'config.inputs'
local encode_direction = require 'utils.encode_direction'
local command_handler = require 'handlers.command'
local command_constants = require "constants.command"

local debug = false

---@return void
function love.load()
    input.init()
end

---@param dt number
---@return void
function love.update(dt)
    input.update()

    local current_dpad = {}
    for _, button in ipairs(buttons) do
      local button_is_dpad = string.find(table.concat(command_constants.dpad_buttons, ","), button)
      if input.pressed(button) then
        if button_is_dpad then
          table.insert(current_dpad, button)
        end
        if debug then
          print(string.format('BTN %s pressed', button))
        end
      end
      if input.released(button) then
        if debug then
          print(string.format('BTN %s released', button))
        end
      end
      
      if input.isDown(button) then
        if button_is_dpad then
          local button_already_registered = string.find(table.concat(current_dpad, ","), button)
          if not button_already_registered then
            table.insert(current_dpad, button)
          end
        end
        if debug then
          print(string.format('BTN %s still pressed', button))
        end
      end
    end

    
    ---@type number
    local lx = input.getAxis('leftx')
    ---@type number
    local ly = input.getAxis('lefty')
    ---@type number
    local rx = input.getAxis('rightx')
    ---@type number
    local ry = input.getAxis('righty')

    ---@type string
    local direction = encode_direction.axis(lx, ly)
    if direction == "5" then
      direction = encode_direction.dpad(current_dpad)
    end
    command_handler.update(dt, direction)
    patterns = command_handler.identify_direction_pattern()
    if #patterns > 0 then
      print(table.concat(patterns, ", "))
    end

    if debug then
      print(string.format('Direction %s', direction))
    end
    

    if math.abs(lx) > input_config.sensitivity and debug then
      print(string.format('L Axis - x=%.2f', lx))
    end
    if math.abs(ly) > input_config.sensitivity and debug then
      print(string.format('L Axis - y=%.2f', ly))
    end
    if math.abs(rx) > input_config.sensitivity and debug then
      print(string.format('R Axis - x=%.2f', rx))
    end
    if math.abs(ry) > input_config.sensitivity and debug then
      print(string.format('R Axis - y=%.2f', ry))
    end

    local triggerL = input.getAxis('triggerleft')
    local triggerR = input.getAxis('triggerright')

    if triggerL > input_config.sensitivity and debug then
        print(string.format('L Trigger - %.2f', triggerL))
    end
    if triggerR > input_config.sensitivity and debug then
        print(string.format('R Trigger - %.2f', triggerR))
    end
end

---@return void
function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end
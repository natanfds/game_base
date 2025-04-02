if arg[2] == "debug" then
  require("lldebugger").start()
end

local input = require 'handlers.input'
local buttons = require 'constants.buttons'
local input_config = require 'config.inputs'
local encode_direction = require 'utils.encode_direction'
local command_handler = require 'handlers.command'
local command_constants = require "constants.command"
local list_utils = require "utils.list"

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
    local current_actions = {}

    for _, button in ipairs(buttons) do
      local button_is_dpad = list_utils.in_list(command_constants.dpad_buttons, button)
      local button_is_action = list_utils.in_list(command_constants.action_buttons, button)
      if input.pressed(button) then
        if button_is_dpad then
          table.insert(current_dpad, button)
        elseif button_is_action then
          table.insert(current_actions, button)
        end
      end
      if input.released(button) then
        if debug then
          print(string.format('BTN %s released', button))
        end
      end
      
      if input.isDown(button) then
        if button_is_dpad then
          local dpad_already_registered = list_utils.in_list(current_dpad, button)
          if not dpad_already_registered then
            table.insert(current_dpad, button)
          end
        elseif button_is_action then
          local action_already_registered = list_utils.in_list(current_actions, button)
          if not action_already_registered then
            table.insert(current_actions, button)
          end
          
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
    command_handler.update(dt, direction, current_actions)
    local commands_found = command_handler.identify_command()
    for _, cmd in pairs(commands_found) do
      print(cmd.pattern)
      print(table.concat(cmd.action, ", "))
    end

    local triggerL = input.getAxis('triggerleft')
    local triggerR = input.getAxis('triggerright')

end

---@return void
function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end
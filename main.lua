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

    local triggerL = input.getAxis('triggerleft')
    local triggerR = input.getAxis('triggerright')
    local lx = input.getAxis('leftx')
    local ly = input.getAxis('lefty')
    local rx = input.getAxis('rightx')
    local ry = input.getAxis('righty')

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
        -- if button_is_dpad then
        --   local dpad_already_registered = list_utils.in_list(current_dpad, button)
        --   if not dpad_already_registered then
        --     table.insert(current_dpad, button)
        --   end
        -- elseif button_is_action then
        --   local action_already_registered = list_utils.in_list(current_actions, button)
        --   if not action_already_registered then
        --     table.insert(current_actions, button)
        --   end
          
        -- end
      end
    end


    local trigger_l_active = false
    if triggerL > 0 then
      if not trigger_l_active then
        table.insert(current_actions, 'triggerleft')
        trigger_l_active = true
      end
    else
      trigger_l_active = false
    end

    local trigger_r_active = false
    if triggerR > 0 then
      if not trigger_r_active then
        table.insert(current_actions, 'triggerright')
      end
    else 
      trigger_r_active = false
    end

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

end

---@return void
function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end
local input = require 'handlers.input'
local buttons = require 'constants.buttons'
local input_config = require 'config.inputs'
local encode_direction = require 'utils.encode_direction'

local debug = false

function love.load()
    input.init()
end

function love.update(dt)
    input.update()


    for _, button in ipairs(buttons) do
      if input.pressed(button) and debug then
        print(string.format('BTN %s pressed', button))
      end
      
      if input.released(button) and debug then
          print(string.format('BTN %s released', button))
      end
      
      if input.isDown(button) and debug then
          print(string.format('BTN %s still pressed', button))
      end
    end

    
    local lx = input.getAxis('leftx')
    local ly = input.getAxis('lefty')
    local rx = input.getAxis('rightx')
    local ry = input.getAxis('righty')

    direction = encode_direction(lx, ly)
    print(string.format('Direction %s', direction))

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

function love.draw()
    love.graphics.print('Hello World!', 400, 300)
end
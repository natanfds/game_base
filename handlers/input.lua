local buttons = require 'constants.buttons'
local input_config = require 'config.inputs'

local input = {
    current = {},
    previous = {},
    axes = {
        leftx = 0,
        lefty = 0,
        rightx = 0,
        righty = 0,
        triggerleft = 0,
        triggerright = 0
    }
}

---@return void
function input.init()
    for _, button in ipairs(buttons) do
        input.current[button] = false
        input.previous[button] = false
    end
end

---@return void
function input.update()
    local joystick = love.joystick.getJoysticks()[1]
    

    for button, _ in pairs(input.current) do
        input.previous[button] = input.current[button]
    end
    

    if joystick then
        for _, button in ipairs(buttons) do
            input.current[button] = joystick:isGamepadDown(button)
        end
        
        input.axes.leftx = joystick:getGamepadAxis('leftx')
        input.axes.lefty = joystick:getGamepadAxis('lefty')
        input.axes.rightx = joystick:getGamepadAxis('rightx')
        input.axes.righty = joystick:getGamepadAxis('righty')
        input.axes.triggerleft = joystick:getGamepadAxis('triggerleft')
        input.axes.triggerright = joystick:getGamepadAxis('triggerright')
    else
        for axis, _ in pairs(input.axes) do
            input.axes[axis] = 0
        end
    end
end

---@param button string
---@return boolean
function input.isDown(button)
    return input.current[button]
end

---@param button string
---@return boolean
function input.pressed(button)
    return input.current[button] and not input.previous[button]
end

---@param button string
---@return boolean
function input.released(button)
    res = not input.current[button] and input.previous[button]
    input.previous[button] = false
    return res
end

---@param axis string
---@return number
function input.getAxis(axis)
    if input.axisThreshold(axis, input_config.sensitivity) then
        return input.axes[axis]
    end
    return 0
end

---@param axis string
---@param threshold number
---@return boolean
function input.axisThreshold(axis, threshold)
    return math.abs(input.axes[axis]) > (threshold or 0.5)
end

return input

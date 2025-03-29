local buttons = require  'constants.buttons'

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

function input.init()
    for _, button in ipairs(buttons) do
        input.current[button] = false
        input.previous[button] = false
    end
end

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


function input.isDown(button)
    return input.current[button]
end


function input.pressed(button)
    return input.current[button] and not input.previous[button]
end


function input.released(button)
    res = not input.current[button] and input.previous[button]
    input.previous[button] = false
    return res
end

function input.getAxis(axis)
    return input.axes[axis]
end

function input.axisThreshold(axis, threshold)
    return math.abs(input.axes[axis]) > (threshold or 0.5)
end

return input

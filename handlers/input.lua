local buttons = require  'constants.buttons'

local input = {
    current = {},
    previous = {},
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

return input

local input = require 'handlers.input'
local command_constants = require 'constants.command'
local InputData = require 'classes.input_data'
local command = {
    buffer_direction = {},
    buffer_action = {},
    last_inp_time = 0
}
---@param buffer table
---@return boolean
function command.has_expired(buffer)
    local current_time = love.timer.getTime()
    if #buffer == 0 then
        return false
    end 
    local passed_time = current_time - buffer[1].created_at
    return passed_time > command_constants.maxTime
end

---@return void
function command.clear_inputs()
    local buffer_direction = command.buffer_direction
    local buffer_action = command.buffer_action
    local buffer_size = command_constants.bufferSize

    while #buffer_direction > buffer_size do
        table.remove(buffer_direction, 1)
    end

    while #buffer_action > buffer_size do
        table.remove(buffer_action, 1)
    end
    
    while command.has_expired(buffer_direction) do
        table.remove(buffer_direction, 1)
    end

    while command.has_expired(buffer_action) do
        table.remove(buffer_action, 1)
    end
end

---@param btn string
---@param queue table
---@return boolean
function command.not_registered(btn, queue)
    if #queue == 0 then
        return true
    end
    return btn ~= queue[#queue].btn
end

---@param dt number
---@param direction string
---@param actions string[]
---@return void
function command.update(dt, direction, actions)

    if command.not_registered(direction, command.buffer_direction) then
        table.insert(command.buffer_direction, InputData.new(direction))
        command.last_inp_time = love.timer.getTime()
    end

    if #actions > 0 and command.not_registered(actions, command.buffer_action) then
        table.insert(command.buffer_action, InputData.new(actions))
        command.last_inp_time = love.timer.getTime()
    end

    command.clear_inputs()
end

---@return string[]
function command.identify_direction_pattern()
    local buffer_direction = command.buffer_direction
    local registered_patterns = {}
    local current_inputs = {}

    for _, register in ipairs(buffer_direction) do
        table.insert(current_inputs, register.btn)
    end

    if #current_inputs < 3 then
        return registered_patterns
    end

    if #current_inputs == 3 then
        index_of_five = string.find(table.concat(current_inputs), "5")
        if index_of_five and index_of_five ~= 2 then
            goto finish
        end
    end
    
    for pattern_name, pattern in pairs(command_constants.patterns) do
        local cur_input_str = table.concat(current_inputs, "")
        local has_pattern = string.find(cur_input_str, pattern)
        if has_pattern then
            table.insert(registered_patterns, pattern_name)
        end
    end

    ::finish::


    return registered_patterns
end

function command.identify_command()
    local buffer_direction = command.buffer_direction
    local buffer_action = command.buffer_action
    local cur_commands = {}
    if #buffer_action == 0 then
        return cur_commands
    end

    local found_patterns = command.identify_direction_pattern()

    local str_cur_directions =  ""

    for _, direction in pairs(buffer_direction) do
        str_cur_directions = str_cur_directions .. direction.btn
    end

    for i, pattern in ipairs(found_patterns) do
        local ptn_i, ptn_last_i = string.find(str_cur_directions, command_constants.patterns[pattern])
       
        if ptn_last_i == #buffer_direction then
            goto finish
        end

        ---@type number[]
        local action_limit_times = {}
        for i = ptn_last_i, #buffer_direction do
            ---@type number
            local created_at = buffer_direction[i].created_at
            table.insert(action_limit_times, created_at)
        end

        for _, action in pairs(buffer_action) do
            for _, limit_times in pairs(action_limit_times) do
                if limit_times - action.created_at <= command_constants.maxTime then

                    local pre_command = {
                        action = action.btn,
                        pattern = pattern
                    }
                    local has_cmd_in_pool = false
                    for _, cmd in pairs(cur_commands) do
                        if cmd.action == pre_command.action and cmd.pattern == pre_command.pattern then
                            has_cmd_in_pool = true
                        end
                    end

                    if not has_cmd_in_pool then
                        table.insert(cur_commands, pre_command)
                    end
                end
            end
        end
    end

    ::finish::

    return cur_commands
end

return command 
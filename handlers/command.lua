local input = require 'handlers.input'
local command_constants = require 'constants.command'

local command = {
    buffer = {},
    lastInputTime = 0
}

---@param currentTime number
---@return boolean
function command.has_expired(currentTime)
    if #command.buffer == 0 then
        return false
    end 
    local passed_time = currentTime - command.buffer[1].created_at
    return passed_time > command_constants.maxTime
end

---@param currentTime number
---@return void
function command.clear_inputs(currentTime)
    while #command.buffer > command_constants.bufferSize do
        table.remove(command.buffer, 1)
    end
    
    while command.has_expired(currentTime) do
        table.remove(command.buffer, 1)
    end
end

---@param btn string
---@return boolean
function command.not_registered(btn)
    if #command.buffer == 0 then
        return true
    end
    return btn ~= command.buffer[#command.buffer].btn
end

---@param dt number
---@param btn string
---@return void
function command.update(dt, btn)
    local currentTime = love.timer.getTime()

    if command.not_registered(btn) then
        table.insert(command.buffer, {
            btn = btn,
            created_at = currentTime
        })
        command.lastInputTime = currentTime
    end

    command.clear_inputs(currentTime)
end

---@return string[]
function command.identify_direction_pattern()
    registered_patterns = {}
    current_inputs = {}

    for _, register in ipairs(command.buffer) do
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


return command 
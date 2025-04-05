local input = require 'handlers.input'
local command_constants = require 'constants.command'
local InputData = require 'classes.input_data'


local CommandHandler = {}
CommandHandler.__index = CommandHandler

function CommandHandler:new()
    local obj = {}
    obj.direction_pool = {}
    obj.action_pool = {}
    obj.last_inp_time = 0
    return setmetatable(obj, CommandHandler)
end

---@param buffer table
---@return boolean
function CommandHandler:has_expired(buffer)
    local current_time = love.timer.getTime()
    if #buffer == 0 then
        return false
    end 
    local passed_time = current_time - buffer[1].created_at
    return passed_time >= command_constants.maxTime
end

---@return void
function CommandHandler:clear_inputs()
    local BUFFER_SIZE = command_constants.bufferSize
    while #self.direction_pool > BUFFER_SIZE do
        table.remove(self.direction_pool, 1)
    end

    while #self.action_pool > BUFFER_SIZE do
        table.remove(self.action_pool, 1)
    end
    
    while self:has_expired(self.direction_pool) do
        table.remove(self.direction_pool, 1)
    end

    while self:has_expired(self.action_pool) do
        table.remove(self.action_pool, 1)
    end
end

---@param btn string
---@param queue table
---@return boolean
function CommandHandler:not_registered(btn, queue)
    if #queue == 0 then
        return true
    end
    return btn ~= queue[#queue].btn
end

---@param dt number
---@param direction string
---@param actions string[]
---@return void
function CommandHandler:update(dt, direction, actions)

    if self:not_registered(direction, self.direction_pool) then
        table.insert(
            self.direction_pool, 
            InputData.new(direction)
        )
        self.last_inp_time = love.timer.getTime()
    end

    if #actions > 0 and self:not_registered(actions, self.action_pool) then
        table.insert(
            self.action_pool, 
            InputData.new(actions)
        )
        self.last_inp_time = love.timer.getTime()
    end

    self:clear_inputs()
end

---@return string[]
function CommandHandler:identify_direction_pattern()
    local direction_pool = self.direction_pool
    local registered_patterns = {}
    local current_inputs = {}

    for _, register in ipairs(direction_pool) do
        table.insert(current_inputs, register.btn)
    end

    if #current_inputs < 3 then
        return registered_patterns
    end

    if #current_inputs == 3 then
        local index_of_five = string.find(
            table.concat(current_inputs), 
            "5"
        )
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

function CommandHandler:identify_command()
    local direction_pool = self.direction_pool
    local action_pool = self.action_pool
    local cur_commands = {}
    if #action_pool == 0 then
        return cur_commands
    end

    local found_patterns = self:identify_direction_pattern()

    local str_cur_directions =  ""

    for _, direction in pairs(direction_pool) do
        str_cur_directions = str_cur_directions .. direction.btn
    end

    for i, pattern in ipairs(found_patterns) do
        local ptn_i, ptn_last_i = string.find(
            str_cur_directions, 
            command_constants.patterns[pattern]
        )
       
        if ptn_last_i == #direction_pool then
            goto finish
        end

        ---@type number[]
        local action_limit_times = {}
        for i = ptn_last_i, #direction_pool do
            ---@type number
            local created_at = direction_pool[i].created_at
            table.insert(action_limit_times, created_at)
        end

        for _, action in pairs(action_pool) do
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

    if #cur_commands > 0 then
        self:clear_inputs()
    end
    return cur_commands
end

return CommandHandler 
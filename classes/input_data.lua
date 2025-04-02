local InputData = {}


---@param btn string
function InputData.new(btn)
  local obj = {
    btn = btn,
    created_at = love.timer.getTime()
  }
  local self = setmetatable(obj, InputData)
  return self
end

return InputData
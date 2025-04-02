local list_utils = {}

---@param list any[]
---@param target any
---@param delimiter? string
---@return boolean
function list_utils.in_list(list, target, delimiter)
  if not delimiter then
    delimiter = ","
  end
  local res = string.find(table.concat(list, delimiter), target)

  if not res then
    return false
  end

  return true
end

return list_utils
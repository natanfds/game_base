local string_utlis = {}

---@param str string
---@param delim string
---@return string[]
function string_utlis.split(str, delim)
  local result = {}
  for match in str:gmatch("[^" .. delim .. "]+") do
      table.insert(result, match)
  end

  if #result == 0 then
    return {str}
  end
  return result
end

return string_utlis
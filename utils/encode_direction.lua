
function encode_direction(x , y)
  -- Neutro
  if math.abs(x) < 0.5 and math.abs(y) < 0.5 then
      return '5' 
  end
  
  local angle = math.atan2(y, x)
  local dir = math.floor((angle + math.pi) * 8 / (2 * math.pi) + 0.5) % 8
  
  local directions = {'4', '7', '8', '9', '6', '3', '2', '1'}
  return directions[dir + 1]
end

return encode_direction
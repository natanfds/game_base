local input = require 'handlers.input'
local buttons = require  'constants.buttons'

function love.load()
    input.init()
end

function love.update(dt)
    input.update()
    
    -- Exemplo de uso:
    if input.pressed('a') then
        print('Botão A foi pressionado!', 400, 300)
    end
    
    if input.released('b') then
        print('Botão B foi solto!', 400, 300)
    end
    
    if input.isDown('x') then
        print('Botão X está sendo segurado!', 400, 300)
    end
end

function love.draw()
  love.graphics.print('Hello World!', 400, 300)
end
local bump = require 'libs/bump/bump'
local coronaImg = love.graphics.newImage('imgs/corona.png')
local counter = 19
local speed = 0
local maxWidth = love.graphics.getWidth()

local world = bump.newWorld()
local floor = { x = 0, y = 550, w = maxWidth, h = 2 }
local player = { x=50,y=530,w=20,h=20, speed = 120 }
local blocks = {}

local coronas = {}

local function addBlock(x,y,w,h)
    local block = {x=x,y=y,w=w,h=h}
    blocks[#blocks+1] = block
    world:add(block, x,y,w,h)
end

local function drawBox(box, r,g,b)
    love.graphics.setColor(r,g,b,70)
    love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

local function drawCorona(corona)
    love.graphics.draw(coronaImg, corona.x, corona.y)
end

local function drawCoronas()
    for _, value in ipairs(coronas) do
        drawCorona(value)
    end
end

local function drawPlayer()
    drawBox(player, 0, 255, 0)
    drawBox(floor, 0, 255, 0)
end

local function drawScore()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(speed, 15, 15) -- Yap, it's the speed D:
 end

local function addCorona(dt)
    counter = counter + 1 + speed
    speed = speed + 1
    if counter % 20 ~= 0 then -- Oh, such a terrible terrible person did this
        return
    end
    local corona = { x = math.random(0, maxWidth), y = math.random(0, 30), w = 20, h = 2 }
    coronas[#coronas+1] = corona
    world:add(corona, corona.x, corona.y, corona.w, corona.h)
end

local function updatePlayer(dt)
    local speed = player.speed
  
    local dx, dy = 0, 0
    if love.keyboard.isDown('right') then
      dx = speed * dt
    elseif love.keyboard.isDown('left') then
      dx = -speed * dt
    end

    if dx ~= 0 and player.x + dx > 0 and player.x + dx <= maxWidth then
        player.x, player.y, cols, cols_len = world:move(player, player.x + dx, player.y + dy)
    end
end

local function checkGameOver(cols)
    for _, col in ipairs(cols) do
        if col.other == player then
            love.event.quit()
        end
    end

end

local function updateCoronas(dt) 
    for _, value in ipairs(coronas) do
        value.y = value.y + 1 + (dt * 100)
        value.x, value.y, cols, cols_len = world:move(value, value.x, value.y )
        checkGameOver(cols)
    end
end

function love.load()
    world:add(player, player.x, player.y, player.w, player.h)
end
 
function love.update(dt)
    addCorona(dt)
    updatePlayer(dt)
    updateCoronas(dt)

end

function love.draw()
    drawPlayer()
    drawCoronas()
    drawScore()
end
local Player = require("player")
local Enemy  = require("enemy")
local Coin   = require("coin")
local Camera = require("camera")

local player
local enemies = {}
local coins = {}

local cam
local VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 640, 480

local score = 1
local highScore = 0
local playerDead = false
local lastEnemyScore = 0
----------------------------------
local function spawnCoin()
    local coinSize = 16  -- same as coin  
    local x = math.random(0, VIRTUAL_WIDTH - coinSize)
    local y = math.random(0, VIRTUAL_HEIGHT - coinSize)
    return Coin.new(x, y)
end


local function spawnEnemy()
    local enemySize = 32
    local x = math.random(0, VIRTUAL_WIDTH - enemySize)
    local y = math.random(0, VIRTUAL_HEIGHT - enemySize)
    
    
    while player:checkCollision({x = x, y = y, width = enemySize, height = enemySize}) do
        x = math.random(0, VIRTUAL_WIDTH - enemySize)
        y = math.random(0, VIRTUAL_HEIGHT - enemySize)
    end

    table.insert(enemies, Enemy.new(x, y))
end
--------------------------------

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local windowWidth, windowHeight = love.graphics.getDimensions()
    cam = Camera.new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, windowWidth, windowHeight)
    
    player = Player.new(100, 100)
    table.insert(enemies, Enemy.new(300, 150))
    table.insert(enemies, Enemy.new(400, 250))
    table.insert(coins, Coin.new(200, 100))
    table.insert(coins, Coin.new(250, 250))

    -- initializing coins
    coins = {}
    for i = 1, 5 do
        table.insert(coins, spawnCoin())
    end
end

function love.update(dt)
    player:update(dt)

    for _, enemy in ipairs(enemies) do
    enemy:update(dt)
    if player:checkCollision(enemy) then
        playerDead = true          
        if score > highScore then
            highScore = score       
        end
        score = 1   
        player:reset()
    end
    end

     -- collision with coins
    for i = #coins, 1, -1 do
        local coin = coins[i]
        if player:checkCollision(coin) then
            table.remove(coins, i)
            score = score + 1
        end
    end
    
        if score % 5 == 0 and score ~= 0 and score ~= lastEnemyScore then
            spawnEnemy()
            lastEnemyScore = score
        end

    -- respawning coins if all collected
    if #coins == 0 then
        for i = 1, 5 do
            table.insert(coins, spawnCoin())
        end
    end
end

function love.draw()
    cam:start()
    
    player:draw()
    for _, enemy in ipairs(enemies) do enemy:draw() end
    for _, coin in ipairs(coins) do coin:draw() end

    -- draw score on screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. tostring(score), 10, 10)
    love.graphics.print("High Score: " .. tostring(highScore), 10, 30)

    cam:stop()
end

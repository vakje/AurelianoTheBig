local Coin = {}
Coin.__index = Coin

function Coin.new(x, y)
    local self = setmetatable({}, Coin)
    self.x, self.y = x, y
    self.width, self.height = 16, 16
    return self
end

function Coin:draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, self.width / 2)
    love.graphics.setColor(1, 1, 1)
end

return Coin

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y)
    local self = setmetatable({}, Enemy)
    self.x, self.y = x, y
    self.width, self.height = 32, 32

 
    local speed = math.random(80, 150)

    
    local angle = math.random() * 2 * math.pi
    self.vx = math.cos(angle) * speed
    self.vy = math.sin(angle) * speed

    return self
end

function Enemy:update(dt)
  
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    
    if self.x < 0 then
        self.x = 0
        self.vx = -self.vx
    elseif self.x + self.width > 640 then
        self.x = 640 - self.width
        self.vx = -self.vx
    end

    if self.y < 0 then
        self.y = 0
        self.vy = -self.vy
    elseif self.y + self.height > 480 then
        self.y = 480 - self.height
        self.vy = -self.vy
    end

    -- Rnadom jitter smal chnace to slightly change direction every frame
    if math.random() < 0.02 then
        local angle = math.random() * 2 * math.pi
        local speed = math.sqrt(self.vx^2 + self.vy^2)
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
    end
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

return Enemy

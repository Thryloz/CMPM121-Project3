--Jim Lee

LocationClass = {}

LOCATION_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
}

function LocationClass:new(xPos, yPos, name, player)
    local location = {}
    setmetatable(location, {__index = LocationClass})
    location.name = name
    location.position = Vector(xPos, yPos)
    location.power = 0
    location.size = CARD_SIZE
    location.cardTable = {}
    location.player = player
    location.opposingLocation = nil

    location.slotPositions = {}
    location.slotPositions[1] = Vector(location.position.x, location.position.y)
    location.slotPositions[2] = Vector(location.position.x + CARD_OFFSET.x, location.position.y)
    location.slotPositions[3] = Vector(location.position.x, location.position.y + CARD_OFFSET.y)
    location.slotPositions[4] = Vector(location.position.x + CARD_OFFSET.x, location.position.y + CARD_OFFSET.y)

    location.interactSize = Vector(CARD_SIZE.x + CARD_OFFSET.x, CARD_SIZE.y + CARD_OFFSET.y)

    return location
end

function LocationClass:draw()
    -- draw power
    if self.player then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(tostring(self.power), self.position.x, self.position.y - 20, self.interactSize.x, "center")
    else
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(tostring(self.power), self.position.x, self.position.y + self.interactSize.y + 10, self.interactSize.x, "center")
    end



    -- draw slots
    love.graphics.setColor(0, 0, 0, 0.5)
    for i = 1, #self.slotPositions, 1 do
        love.graphics.rectangle("fill", self.slotPositions[i].x, self.slotPositions[i].y, self.size.x, self.size.y, 6, 6)
    end

    if (self.state == LOCATION_STATE.MOUSE_OVER and grabber.heldObject ~= nil) then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)
    end

    -- draw cards
    if #self.cardTable ~= 0 then
        for _, card in ipairs(self.cardTable) do
            card:draw()
        end
    end
end

function LocationClass:addCard(card)
    table.insert(self.cardTable, card)
    card.location = self
    self:organizeCards()
    self:calculatePower();
end

function LocationClass:removeCard(index)
    self.cardTable[index].location = nil
    table.remove(self.cardTable, index)
    self:organizeCards();
    self:calculatePower();
end

function LocationClass:checkForMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.interactSize.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.interactSize.y

  self.state = isMouseOver and LOCATION_STATE.MOUSE_OVER or LOCATION_STATE.IDLE
end

function LocationClass:organizeCards()
    for i, card in ipairs(self.cardTable) do
        card:moveCard(self.slotPositions[i].x, self.slotPositions[i].y)
    end
end


function LocationClass:calculatePower()
    self.power = 0;
    for _, card in ipairs(self.cardTable) do
        self.power = self.power + card.power
    end
end

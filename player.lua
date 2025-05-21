--Jim Lee

PlayerClass = {}

PLAYER_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
}

function PlayerClass:new()
    local player = {}
    setmetatable(player, {__index = PlayerClass})

    player.deck = {}
    player.hand = {}
    player.discard = {}
    player.mana = 0
    player.points = 0
    player.state = PLAYER_STATE.IDLE

    player.interactSize = Vector(CARD_SIZE.x*7, 20)
    player.position = Vector(SCREEN_WIDTH/2 - player.interactSize.x/2 , SCREEN_HEIGHT - 10)

    player.showAllCards = false
    player.showAllCardsPosition = Vector(SCREEN_WIDTH/8, SCREEN_HEIGHT - 50)
    player.showAllCardsPositionSize = Vector(SCREEN_WIDTH/20, SCREEN_HEIGHT/30)


    return player
end

function PlayerClass:update()
    if self.showAllCards then
        for _, card in ipairs(self.hand) do
            card:moveCard(card.position.x, player.position.y - CARD_SIZE.y + 10)
        end
    else
        for _, card in ipairs(self.hand) do
            if card.state == CARD_STATE.MOUSE_OVER then
                card:moveCard(card.position.x, player.position.y - CARD_SIZE.y + 10)
            else
                card:moveCard(card.position.x, player.position.y - 20)
            end
        end
    end
end


function PlayerClass:draw()

    -- deck
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH/16, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Deck", SCREEN_WIDTH/16 , LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")
    -- draw cards in deck
   
    -- discard
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Discard", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")

    -- show all button
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.showAllCardsPosition.x - self.showAllCardsPositionSize.x/2, self.showAllCardsPosition.y, self.showAllCardsPositionSize.x, self.showAllCardsPositionSize.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Show All Cards", self.showAllCardsPosition.x - self.showAllCardsPositionSize.x/2, self.showAllCardsPosition.y, self.showAllCardsPositionSize.x, "center")

    -- hand
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)

    if (self.state == PLAYER_STATE.MOUSE_OVER and grabber.heldObject ~= nil) then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)
    end

    for _, card in ipairs(self.hand) do
        card:draw()
    end
end

function PlayerClass:addCardToHand(card)
    table.insert(self.hand, card)
    card.location = self
    self:orderCards()
end

function PlayerClass:removeCardFromHand(index)
    table.remove(self.hand, index)
    self:orderCards()
end

function PlayerClass:orderCards()
    if #self.hand == 0 then return end

    for i = 1, #self.hand, 1 do
        self.hand[i]:moveCard(self.position.x + self.interactSize.x/2 - (CARD_SIZE.x * (#self.hand/2 - (i-1))), self.position.y)
    end
end


function PlayerClass:checkForMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.interactSize.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.interactSize.y

  self.state = isMouseOver and PLAYER_STATE.MOUSE_OVER or PLAYER_STATE.IDLE
end


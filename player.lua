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
    player.mana = 10
    player.state = PLAYER_STATE.IDLE

    player.interactSize = Vector(CARD_SIZE.x*7, 20)
    player.position = Vector(SCREEN_WIDTH/2 - player.interactSize.x/2 , SCREEN_HEIGHT - 10)

    player.showAllCards = false
    -- player.showAllCardsPosition = Vector(SCREEN_WIDTH/8, SCREEN_HEIGHT - 50)
    -- player.showAllCardsPositionSize = Vector(SCREEN_WIDTH/20, SCREEN_HEIGHT/30)


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

   
    -- discard
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Discard", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")
    -- draw cards in discard
    
    -- hand
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)

    if (self.state == PLAYER_STATE.MOUSE_OVER and grabber.heldObject ~= nil) then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)
    end

    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.setFont(infoFont) 
    love.graphics.printf("Mana: " ..tostring(self.mana), SCREEN_WIDTH/(INFO_FONT_SIZE-10), SCREEN_HEIGHT/2 + SCREEN_HEIGHT/20, INFO_FONT_SIZE * 5, "center")

    love.graphics.setColor(0, 0.329, 0, 1)
    love.graphics.setFont(infoFont)
    love.graphics.printf("Points: " ..tostring(gameManager.playerPoints), 7 * SCREEN_WIDTH/8 - 30, SCREEN_HEIGHT/2 + SCREEN_HEIGHT/20, INFO_FONT_SIZE * 5, "center")

    love.graphics.setFont(cardFont)
    -- draw cards in hand
    for _, card in ipairs(self.hand) do
        if card.state ~= CARD_STATE.GRABBED then
            card:draw()
        end
    end

    -- draw cards in deck
    for _, card in ipairs(self.deck) do
        card.faceUp = false
        card:draw()
    end

    -- draw cards in discard
    for _, card in ipairs(self.discard) do
        card.faceUp = true
        card:draw()
    end
end

function PlayerClass:addCardToHand(card)
    if card == nil or #self.hand == 7 then return end
    table.insert(self.hand, card)
    card.location = self
    card.faceUp = true
    self:orderCards()
end

function PlayerClass:removeCardFromHand(index)
    table.remove(self.hand, index)
    self:orderCards()
end

function PlayerClass:orderCards()
    if #self.hand == 0 then return end

    for i = 1, #self.hand, 1 do
        self.hand[i]:moveCard(self.position.x + self.interactSize.x/2 - (CARD_SIZE.x * (#self.hand/2 - (i-1))), self.position.y - 20)
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


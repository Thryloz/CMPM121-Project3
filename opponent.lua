--Jim Lee

OpponentClass = {}

function OpponentClass:new()
    local opponent = {}
    setmetatable(opponent, {__index = OpponentClass})

    opponent.deck = {}
    opponent.hand = {}
    opponent.discard = {}
    opponent.mana = 1

    opponent.interactSize = Vector(CARD_SIZE.x*7, 20)
    opponent.position = Vector(SCREEN_WIDTH/2 - opponent.interactSize.x/2, -10)



    return opponent
end

function OpponentClass:update()
    for _, card in ipairs(self.hand) do
        if card.state == CARD_STATE.MOUSE_OVER then
            card:moveCard(card.position.x, opponent.position.y - CARD_SIZE.y + 10)
        else
            card:moveCard(card.position.x, opponent.position.y - 20)
        end
    end
end


function OpponentClass:draw()
    
    -- deck
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Deck", SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")
    
    -- draw cards in deck

    
    -- discard
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH/16, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Discard", SCREEN_WIDTH/16 , LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")
   
    -- draw cards in discard

    -- hand
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)


    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(infoFont)
    love.graphics.printf("Mana: " ..tostring(self.mana), 7 * SCREEN_WIDTH/8 - 30, SCREEN_HEIGHT/2 - SCREEN_HEIGHT/10, INFO_FONT_SIZE * 5, "center")

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(infoFont)
    love.graphics.printf("Points: " ..tostring(gameManager.opponentPoints), SCREEN_WIDTH/(INFO_FONT_SIZE-10), SCREEN_HEIGHT/2 - SCREEN_HEIGHT/10, INFO_FONT_SIZE * 5, "center")

    love.graphics.setFont(cardFont)
    for _, card in ipairs(self.hand) do
        if card.state ~= CARD_STATE.GRABBED then
            card:draw()
        end
    end
end

function OpponentClass:addCardToHand(card)
    table.insert(self.hand, card)
    card.location = self
    self:orderCards()
end

function OpponentClass:removeCardFromHand(index)
    table.remove(self.hand, index)
    self:orderCards()
end

function OpponentClass:orderCards()
    if #self.hand == 0 then return end

    for i = 1, #self.hand, 1 do
        self.hand[i]:moveCard(self.position.x + self.interactSize.x/2 - (CARD_SIZE.x * (#self.hand/2 - (i-1))), self.position.y - 20)
    end
end


function OpponentClass:checkForMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.interactSize.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.interactSize.y

  self.state = isMouseOver and PLAYER_STATE.MOUSE_OVER or PLAYER_STATE.IDLE
end


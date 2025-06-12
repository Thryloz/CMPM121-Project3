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
    for _, card in ipairs(self.deck) do
        card:draw()
    end

    -- discard
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", SCREEN_WIDTH/16, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2, CARD_SIZE.x, CARD_SIZE.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Discard", SCREEN_WIDTH/16 , LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2 - 20, CARD_SIZE.x, "center")
    -- draw cards in discard
    for _, card in ipairs(self.discard) do
        card:draw()
    end

    -- hand
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(infoFont) 
    love.graphics.printf("Mana: " ..tostring(self.mana), SCREEN_WIDTH/(INFO_FONT_SIZE-10), SCREEN_HEIGHT/2 - SCREEN_HEIGHT/10, INFO_FONT_SIZE * 5, "center")

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(infoFont)
    love.graphics.printf("Points: " ..tostring(gameManager.opponentPoints), 7 * SCREEN_WIDTH/8 - 30, SCREEN_HEIGHT/2 - SCREEN_HEIGHT/10, INFO_FONT_SIZE * 5, "center")

    love.graphics.setFont(cardFont)
    for _, card in ipairs(self.hand) do
        card:draw()
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

function OpponentClass:addCardToHand(card)
    if card == nil then return end
    table.insert(self.hand, card)
    card.location = self
    self:orderCards()
end

function OpponentClass:removeCardFromHand(card)
    for i, ownCard in ipairs(self.hand) do
        if ownCard == card then
            table.remove(self.hand, i)
        end
    end
    self:orderCards()
end

function OpponentClass:orderCards()
    if #self.hand == 0 then return end

    for i = 1, #self.hand, 1 do
        self.hand[i]:moveCard(self.position.x + self.interactSize.x/2 - (CARD_SIZE.x * (#self.hand/2 - (i-1))), self.position.y - CARD_SIZE.y + 35)
    end
end


function OpponentClass:stageCards()
    if #self.hand == 0 then return end
    local numCardsToPlay = math.random(#self.hand)
    local count = 0
    for i = 0, numCardsToPlay, 1 do
        local card = self.hand[math.random(#self.hand)]
        local location = opponentLocationTable[math.random(3)]
        if card.cost <= self.mana and #location.cardTable < 4 then
            self:removeCardFromHand(card)
            location:addCard(card)
            self.mana = self.mana - card.cost
            count = count + 1
        end
    end
    if count == 0 then
        print("Opponent did not add any cards to the field!")
    elseif count == 1 then
        print("Opponent added 1 card to the field!")
    else
        print("Opponent added "..count.." cards to the field!")
    end
end


--Jim Lee

OpponentClass = {}

function OpponentClass:new()
    local opponent = {}
    setmetatable(opponent, {__index = OpponentClass})

    opponent.deck = {}
    opponent.hand = {}
    opponent.mana = 0
    opponent.points = 0

    opponent.interactSize = Vector(CARD_SIZE.x*7, 20)
    opponent.position = Vector(SCREEN_WIDTH/2 - player.interactSize.x/2 , -10)
    

    return opponent
end

function OpponentClass:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)

    for _, card in ipairs(self.hand) do
        card.faceUp = false
        card:draw()
    end
end

function OpponentClass:addCard(card)
    table.insert(self.hand, card)
    card.location = self
end

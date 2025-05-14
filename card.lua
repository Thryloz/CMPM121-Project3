--Jim Lee

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

EFFECT_TYPE = {
    none = 1,
    onPlay = 2,
    onReveal = 3,
    onDiscard = 4,
    onEndTurn = 5
}

function CardClass:new()
    local card = {}
    setmetatable(card, {__index = CardClass})

    card.position = Vector(0, 0)
    card.size = CARD_SIZE
    card.name = "Wooden Cow"
    card.cost = 1
    card.power = 1
    card.text = "Vanilla"
    card.effectType = EFFECT_TYPE.none
    card.state = CARD_STATE.IDLE
    card.location = nil
    card.isPlayer = true
    card.faceUp = false

    function CardClass:activateEffect()
    end

    return card
end

function CardClass:draw()
    if self.state ~= CARD_STATE.IDLE then
        love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
        local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
        love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
    end
    if self.faceUp then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

        love.graphics.setColor({0, 0, 1, 1})
        love.graphics.printf(self.cost, self.position.x + 5, self.position.y, self.size.x, "left")
        love.graphics.setColor({0, 0.7, 0.2, 1})
        love.graphics.printf(self.power, self.position.x - 5, self.position.y, self.size.x, "right")
        love.graphics.setColor({0, 0, 0, 1})
        love.graphics.printf(self.name, self.position.x, self.position.y, self.size.x, "center")
        love.graphics.printf(self.text, self.position.x, self.position.y+self.size.y/2, self.size.x, "center")
    else
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    end
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end

  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y

  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:moveCard(x, y)
    self.position.x = x
    self.position.y = y
end

PegasusCard = CardClass:new()
function PegasusCard:new()
    self.name = "Pegasus"
    self.cost = 3
    self.power = 5
    self.text = "Vanilla"
    self.effectType = EFFECT_TYPE.none
    self.faceUp = false
    return self
end

MinotaurCard = CardClass:new()
function MinotaurCard:new()
    self.name = "Minotaur"
    self.cost = 5
    self.power = 9
    self.text = "Vanilla"
    self.effectType = EFFECT_TYPE.none
    self.faceUp = false
    return self
end

TitanCard = CardClass:new()
function TitanCard:new()
    self.name = "Titan"
    self.cost = 6
    self.power = 12
    self.text = "Vanilla"
    self.effectType = EFFECT_TYPE.none
    self.faceUp = false
    return self
end

ZeusCard = CardClass:new()
function ZeusCard:new()
    self.name = "Zeus"
    self.cost = 5
    self.power = 9
    self.text = "When Revealed: Lower the power of each card in your opponent's hand by 1."
    self.effectType = EFFECT_TYPE.onReveal
    self.faceUp = false

    function ZeusCard:activateEffect()
        local hand = nil
        if self.player then hand = opponent.hand else hand = player.hand end -- this made me realize lua doesn't really have ternary operators
        for _, card in ipairs(hand) do
            card.power = card.power-1
        end
    end

    return self
end

CyclopsCard = CardClass:new()
function CyclopsCard:new()
    self.name = "Cyclops"
    self.cost = 5
    self.power = 9
    self.text = "When Revealed: Discard your other cards here, gain +2 power for each discarded."
    self.effectType = EFFECT_TYPE.onReveal
    self.faceUp = false

    function CyclopsCard:activateEffect()
        for i, card in ipairs(self.location.cardTable) do
            if card ~= self then
                self.location:discardCard(i)
                self.power = self.power + 2
            end
        end
    end

    return self
end


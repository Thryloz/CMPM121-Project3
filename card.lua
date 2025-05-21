--Jim Lee


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

CardClass = {}
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
    card.effectActivated = false
    card.faceUp = false

    function CardClass:activateEffect()
    end

    return card
end

function CardClass:draw()
    if self.state ~= CARD_STATE.IDLE then
        love.graphics.setColor(1, 0, 0, 1) -- color values [0, 1]
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x+0.5, self.size.y+0.5, 6, 6)
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
  if self.state == CARD_STATE.GRABBED or grabber.currentMousePos == nil or grabber.heldObject ~= nil then
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

PegasusCard = {}
function PegasusCard:new()
    PegasusCard.__index = PegasusCard
    setmetatable(PegasusCard, {__index = CardClass})
    local pegasus = CardClass:new()
    setmetatable(pegasus, PegasusCard)
    pegasus.name = "Pegasus"
    pegasus.cost = 3
    pegasus.power = 5 
    pegasus.text = "Vanilla"
    pegasus.effectType = EFFECT_TYPE.none
    return pegasus
end

MinotaurCard = {}
function MinotaurCard:new()
    MinotaurCard.__index = MinotaurCard
    setmetatable(MinotaurCard, {__index = CardClass})
    local minotaur = CardClass:new()
    setmetatable(minotaur, MinotaurCard)
    minotaur.name = "Minotaur"
    minotaur.cost = 5
    minotaur.power = 9
    minotaur.text = "Vanilla"
    minotaur.effectType = EFFECT_TYPE.none
    return minotaur
end

TitanCard = {}
function TitanCard:new()
    TitanCard.__index = TitanCard
    setmetatable(TitanCard, {__index = CardClass})
    local titan = CardClass:new()
    setmetatable(titan, TitanCard)
    titan.name = "Titan"
    titan.cost = 6
    titan.power = 12
    titan.text = "Vanilla"
    titan.effectType = EFFECT_TYPE.none
    return titan
end

ZeusCard = {}
function ZeusCard:new()
    ZeusCard.__index = ZeusCard
    setmetatable(ZeusCard, {__index = CardClass})
    local zeus = CardClass:new()
    setmetatable(zeus, ZeusCard)
    zeus.name = "Zeus"
    zeus.cost = 5
    zeus.power = 9
    zeus.text = "When Revealed: Lower the power of each card in your opponent's hand by 1."
    zeus.effectType = EFFECT_TYPE.onReveal

    function ZeusCard:activateEffect()
        local hand = nil
        if zeus.player then hand = opponent.hand else hand = player.hand end -- this made me realize lua doesn't really have ternary operators
        for _, card in ipairs(hand) do
            card.power = card.power-1
        end
        print(zeus.text)
    end

    return zeus
end

CyclopsCard = CardClass:new()
function CyclopsCard:new()
    self.name = "Cyclops"
    self.cost = 5
    self.power = 9
    self.text = "When Revealed: Discard your other cards here, gain +2 power for each discarded."
    self.effectType = EFFECT_TYPE.onReveal

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


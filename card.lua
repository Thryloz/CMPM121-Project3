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
function CardClass:new(isPlayer)
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
        love.graphics.setColor({0.024, 0.251, 0.169, 1})
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

WoodenCowCard = {}
function WoodenCowCard:new()
    WoodenCowCard.__index = WoodenCowCard
    setmetatable(WoodenCowCard, {__index = CardClass})
    local WoodenCow = CardClass:new()
    setmetatable(WoodenCow, WoodenCowCard)
    WoodenCow.name = "Wooden Cow"
    WoodenCow.cost = 1
    WoodenCow.power = 1 
    WoodenCow.text = "Vanilla"
    WoodenCow.effectType = EFFECT_TYPE.none
    return WoodenCow
end

PegasusCard = {}
function PegasusCard:new()
    PegasusCard.__index = PegasusCard
    setmetatable(PegasusCard, {__index = CardClass})
    local Pegasus = CardClass:new()
    setmetatable(Pegasus, PegasusCard)
    Pegasus.name = "Pegasus"
    Pegasus.cost = 3
    Pegasus.power = 5 
    Pegasus.text = "Vanilla"
    Pegasus.effectType = EFFECT_TYPE.none
    return Pegasus
end

MinotaurCard = {}
function MinotaurCard:new()
    MinotaurCard.__index = MinotaurCard
    setmetatable(MinotaurCard, {__index = CardClass})
    local Minotaur = CardClass:new()
    setmetatable(Minotaur, MinotaurCard)
    Minotaur.name = "Minotaur"
    Minotaur.cost = 5
    Minotaur.power = 9
    Minotaur.text = "Vanilla"
    Minotaur.effectType = EFFECT_TYPE.none
    return Minotaur
end

TitanCard = {}
function TitanCard:new()
    TitanCard.__index = TitanCard
    setmetatable(TitanCard, {__index = CardClass})
    local Titan = CardClass:new()
    setmetatable(Titan, TitanCard)
    Titan.name = "Titan"
    Titan.cost = 6
    Titan.power = 12
    Titan.text = "Vanilla"
    Titan.effectType = EFFECT_TYPE.none
    return Titan
end

ZeusCard = {}
function ZeusCard:new()
    ZeusCard.__index = ZeusCard
    setmetatable(ZeusCard, {__index = CardClass})
    local Zeus = CardClass:new()
    setmetatable(Zeus, ZeusCard)
    Zeus.name = "Zeus"
    Zeus.cost = 5
    Zeus.power = 9
    Zeus.text = "When Revealed: Lower the power of each card in your opponent's hand by 1."
    Zeus.effectType = EFFECT_TYPE.onReveal

    function ZeusCard:activateEffect()
        local hand = nil
        if Zeus.player then hand = opponent.hand else hand = player.hand end -- this made me realize lua doesn't really have ternary operators
        for _, card in ipairs(hand) do
            card.power = card.power-1
        end
    end

    return Zeus
end

AresCard = {}
function AresCard:new()
    AresCard.__index = AresCard
    setmetatable(AresCard, {__index = CardClass})
    local Ares = CardClass:new()
    setmetatable(Ares, AresCard)
    Ares.name = "Ares"
    Ares.cost = 4
    Ares.power = 2
    Ares.text = "When Revealed: Gain +2 power for each enemy card here."
    Ares.effectType = EFFECT_TYPE.onReveal

    function AresCard:activateEffect()
        local userTable = nil
        local opponentTable = nil
        if self.isPlayer then 
            userTable = playerLocationTable
            opponentTable = opponentLocationTable
        else
            userTable = opponentLocationTable
            opponentTable = playerLocationTable
        end


        for i, location in ipairs(userTable) do
            if location == self.location then
                for _, card in ipairs[opponentTable[i]] do
                    self.power = self.power + 2
                end
            end
        end
    end

    return Ares
end

MedusaCard = {}
function MedusaCard:new()
    MedusaCard.__index = MedusaCard
    setmetatable(MedusaCard, {__index = CardClass})
    local Medusa = CardClass:new()
    setmetatable(Medusa, MedusaCard)
    Medusa.name = "Medusa"
    Medusa.cost = 7
    Medusa.power = 10
    Medusa.text = "When Revealed: Gain +2 power for each enemy card here."
    Medusa.effectType = EFFECT_TYPE.onPlay

    function MedusaCard:activateEffect()
        for _, card in ipairs(self.location) do
            if card ~= self then
                card.power = card.power - 1
            end
        end
    end

    return Medusa
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


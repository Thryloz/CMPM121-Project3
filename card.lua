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

function CardClass:discardCard()
    if self.isPlayer then
        for _, card in ipairs(self.location.cardTable) do
            if card == self then
                self.location:removeCard(card)
            end
        end
        self.location = player.discard
        self:moveCard(SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2)
        table.insert(player.discard, self)
    else
        for _, card in ipairs(self.location.cardTable) do
            if card == self then
                self.location:removeCard(card)
            end
        end
        self.location = opponent.discard
        self:moveCard(SCREEN_WIDTH/16, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2)
        table.insert(opponent.discard, self)
    end
    
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
    Zeus.power = 6
    Zeus.text = "When Revealed: Lower the power of each card in your opponent's hand by 1."
    Zeus.effectType = EFFECT_TYPE.onReveal

    function ZeusCard:activateEffect()
        local hand = nil
        if Zeus.player then hand = opponent.hand else hand = player.hand end -- this made me realize lua doesn't really have ternary operators
        for _, card in ipairs(hand) do
            card.power = card.power - 1
            if card.power < 0 then card.power = 0 end
        end
        self.effectActivated = true
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
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            self.power = self.power + 2
        end
        self.effectActivated = true
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
    Medusa.text = "When ANY other card is played here, lower that card's power by 1."
    Medusa.effectType = EFFECT_TYPE.onPlay

    function MedusaCard:activateEffect()
        for _, card in ipairs(self.location.cardTable) do
            if card ~= Medusa then
                card.power = card.power - 1
            end
            if card.power < 0 then card.power = 0 end
        end
    end

    return Medusa
end

CyclopsCard = CardClass:new()
function CyclopsCard:new()
    CyclopsCard.__index = CyclopsCard
    setmetatable(CyclopsCard, {__index = CardClass})
    local Cyclops = CardClass:new()
    setmetatable(Cyclops, CyclopsCard)
    Cyclops.name = "Cyclops"
    Cyclops.cost = 5
    Cyclops.power = 9
    Cyclops.text = "When Revealed: Discard your other cards here, gain +2 power for each discarded."
    Cyclops.effectType = EFFECT_TYPE.onReveal

    function CyclopsCard:activateEffect()
        local cards = {}
        for _, card in ipairs(self.location.cardTable) do
            table.insert(cards, card)
        end
        for _, card in ipairs(cards) do
            if card ~= self then
                card:discardCard()
                self.power = self.power + 2
            end
        end
        self.effectActivated = true
    end

    return Cyclops
end

PoseidonCard = CardClass:new() 
function PoseidonCard:new()
    PoseidonCard.__index = PoseidonCard
    setmetatable(PoseidonCard, {__index = CardClass})
    local Poseidon = CardClass:new()
    setmetatable(Poseidon, PoseidonCard)
    Poseidon.name = "Poseidon"
    Poseidon.cost = 4
    Poseidon.power = 2
    Poseidon.text = "When Revealed: Move away an enemy card here with the lowest power."
    Poseidon.effectType = EFFECT_TYPE.onReveal

    function PoseidonCard:activateEffect()
        if #self.location.opposingLocation.cardTable == 0 then return end

        -- find lowest power card
        local lowestPower = 100
        local lowestCard = nil
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            if card.power < lowestPower then
                lowestPower = card.power
                lowestCard = card
            end
        end

        if lowestCard == nil then return end

        -- find available locations
        local locationOptions = {}
        local locationTable = nil
        if self.isPlayer then locationTable = playerLocationTable else locationTable = opponentLocationTable end
        for _, location in ipairs(locationTable) do
            if location ~= lowestCard.location and #location.cardTable ~= 4 then table.insert(locationOptions, location) end
        end

        if #locationOptions == 0 then lowestCard:discardCard() end -- TODO: move to discard

        -- move card
        local num = math.random(#locationOptions)
        local resultingLocation = locationOptions[num]
        self.location.opposingLocation:removeCard(lowestCard)
        resultingLocation:addCard(lowestCard)

        self.effectActivated = true  
    end

    return Poseidon
end

ArtemisCard = CardClass:new()
function ArtemisCard:new()
    ArtemisCard.__index = ArtemisCard
    setmetatable(ArtemisCard, {__index = CardClass})
    local Artemis = CardClass:new()
    setmetatable(Artemis, ArtemisCard)
    Artemis.name = "Artemis"
    Artemis.cost = 3
    Artemis.power = 3
    Artemis.text = "When Revealed: Gain +5 power if there is exactly one enemy card here."
    Artemis.effectType = EFFECT_TYPE.onReveal

    function ArtemisCard:activateEffect()
        if #self.location.opposingLocation.cardTable == 1 then
            self.power = self.power + 5
        end
        self.effectActivated = true
    end

    return Artemis
end

HeraCard = CardClass:new()
function HeraCard:new()
    HeraCard.__index = HeraCard
    setmetatable(HeraCard, {__index = CardClass})
    local Hera = CardClass:new()
    setmetatable(Hera, HeraCard)
    Hera.name = "Hera"
    Hera.cost = 5
    Hera.power = 6
    Hera.text = "When Revealed: Give cards in your hand +1 power."
    Hera.effectType = EFFECT_TYPE.onReveal

    function HeraCard:activateEffect()
        hand = nil
        if Hera.isPlayer then hand = player.hand else hand = opponent.hand end
        for _, card in ipairs(hand) do
            card.power = card.power + 1
        end
        self.effectActivated = true
    end

    return Hera
end

DemeterCard = CardClass:new()
function DemeterCard:new()
    DemeterCard.__index = DemeterCard
    setmetatable(DemeterCard, {__index = CardClass})
    local Demeter = CardClass:new()
    setmetatable(Demeter, DemeterCard)
    Demeter.name = "Demeter"
    Demeter.cost = 3
    Demeter.power = 2
    Demeter.text = "When Revealed: Both players draw a card."
    Demeter.effectType = EFFECT_TYPE.onReveal

    function DemeterCard:activateEffect()
        if #player.hand < 7 and #player.deck >= 1 then
            local drawnCard = table.remove(player.deck, 1)
            player:addCardToHand(drawnCard)
        end

        if #opponent.hand < 7 and #opponent.deck >= 1 then
            local drawnCard = table.remove(opponent.deck, 1)
            opponent:addCardToHand(drawnCard)
        end
        self.effectActivated = true
    end

    return Demeter
end

HadesCard = CardClass:new()
function HadesCard:new()
    HadesCard.__index = HadesCard
    setmetatable(HadesCard, {__index = CardClass})
    local Hades = CardClass:new()
    setmetatable(Hades, HadesCard)
    Hades.name = "Hades"
    Hades.cost = 4
    Hades.power = 1
    Hades.text = "When Revealed: Gain +2 power for each card in your discard pile."
    Hades.effectType = EFFECT_TYPE.onReveal

    function HadesCard:activateEffect()
        local discard = nil
        if self.isPlayer then discard = player.discard else discard = opponent.discard end
        if #discard == 0 then return end
        self.power = self.power + (#discard * 2)
        
        self.effectActivated = true
    end

    return Hades
end

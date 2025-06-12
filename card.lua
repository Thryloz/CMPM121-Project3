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
    card.isPlayer = isPlayer
    card.effectActivated = false
    card.faceUp = false

    function CardClass:activateEffect()
    end

    return card
end

function CardClass:draw()
    love.graphics.setFont(cardFont)
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

    if self.isPlayer and self.effectActivated then
        love.graphics.setColor(1, .843, 0, 1) -- color values [0, 1]
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x+0.5, self.size.y+0.5, 6, 6)
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
        if self.player then hand = opponent.hand else hand = player.hand end -- this made me realize lua doesn't really have ternary operators
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
    Ares.power = 4
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
            if card ~= self then
                card.power = card.power - 1
            end
            if card.power < 0 then card.power = 0 end
        end
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            if card ~= self then
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
        if self.isPlayer then locationTable = opponentLocationTable else locationTable = playerLocationTable end
        for _, location in ipairs(locationTable) do
            if location ~= lowestCard.location and #location.cardTable ~= 4 then table.insert(locationOptions, location) end
        end

        if #locationOptions == 0 then lowestCard:discardCard() end

        -- move card
        local num = math.random(#locationOptions)
        local resultingLocation = locationOptions[num]
        if resultingLocation == nil then self.effectActivated = true return end 
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
        if self.isPlayer then hand = player.hand else hand = opponent.hand end
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
    Hades.power = 2
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

HerculesCard = CardClass:new()
function HerculesCard:new()
    HerculesCard.__index = HerculesCard
    setmetatable(HerculesCard, {__index = CardClass})
    local Hercules = CardClass:new()
    setmetatable(Hercules, HerculesCard)
    Hercules.name = "Hercules"
    Hercules.cost = 5
    Hercules.power = 8
    Hercules.text = "When Revealed: Doubles its power if its the strongest card here."
    Hercules.effectType = EFFECT_TYPE.onReveal

    function HerculesCard:activateEffect()
        local strongestCard = nil
        local highestPower = -1
        for _, card in ipairs(self.location.cardTable) do
            if card.power > highestPower then
                highestPower = card.power
                strongestCard = card
            end
        end
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            if card.power > highestPower then
                highestPower = card.power
                strongestCard = card
            end
        end
        if strongestCard == self then self.power = self.power * 2 end
        self.effectActivated = true
    end

    return Hercules
end

DionysusCard = CardClass:new()
function DionysusCard:new()
    DionysusCard.__index = DionysusCard
    setmetatable(DionysusCard, {__index = CardClass})
    local Dionysus = CardClass:new()
    setmetatable(Dionysus, DionysusCard)
    Dionysus.name = "Dionysus"
    Dionysus.cost = 6
    Dionysus.power = 8
    Dionysus.text = "When Revealed: Gain +2 power for each of your other cards here."
    Dionysus.effectType = EFFECT_TYPE.onReveal

    function DionysusCard:activateEffect()
        self.power = self.power + ((#self.location.cardTable-1) * 2)
        self.effectActivated = true
    end

    return Dionysus
end

HermesCard = CardClass:new()
function HermesCard:new()
    HermesCard.__index = HermesCard
    setmetatable(HermesCard, {__index = CardClass})
    local Hermes = CardClass:new()
    setmetatable(Hermes, HermesCard)
    Hermes.name = "Hermes"
    Hermes.cost = 2
    Hermes.power = 4
    Hermes.text = "When Revealed: Moves to another location."
    Hermes.effectType = EFFECT_TYPE.onReveal

    function HermesCard:activateEffect()
        -- find locations
        local locationOptions = {}
        local locationTable = nil
        if self.isPlayer then locationTable = playerLocationTable else locationTable = opponentLocationTable end
        for _, location in ipairs(locationTable) do
            if location ~= self.location and #location.cardTable ~= 4 then table.insert(locationOptions, location) end
        end

        if #locationOptions == 0 then self.effectActivated = true return end

        -- move card
        local num = math.random(#locationOptions)
        local resultingLocation = locationOptions[num]
        self.location:removeCard(self)
        resultingLocation:addCard(self)
        self.effectActivated = true
    end

    return Hermes
end

ShipOfTheseusCard = CardClass:new()
function ShipOfTheseusCard:new()
    ShipOfTheseusCard.__index = ShipOfTheseusCard
    setmetatable(ShipOfTheseusCard, {__index = CardClass})
    local ShipOfTheseus = CardClass:new()
    setmetatable(ShipOfTheseus, ShipOfTheseusCard)
    ShipOfTheseus.name = "ShipOfTheseus"
    ShipOfTheseus.cost = 2
    ShipOfTheseus.power = 2
    ShipOfTheseus.text = "When Revealed: Add a copy with +1 power to your hand."
    ShipOfTheseus.effectType = EFFECT_TYPE.onReveal

    function ShipOfTheseusCard:activateEffect()
        if self.isPlayer then
            local card = ShipOfTheseusCard:new()
            card.power = self.power + 1
            card.effectActivated = false
            card.isPlayer = true
            player:addCardToHand(card)
        else
            local card = ShipOfTheseusCard:new()
            card.power = self.power + 1
            card.effectActivated = false
            card.isPlayer = false
            opponent:addCardToHand(card)
        end
        self.effectActivated = true
    end

    return ShipOfTheseus
end

SwordOfDamoclesCard = CardClass:new()
function SwordOfDamoclesCard:new()
    SwordOfDamoclesCard.__index = SwordOfDamoclesCard
    setmetatable(SwordOfDamoclesCard, {__index = CardClass})
    local SwordOfDamocles = CardClass:new()
    setmetatable(SwordOfDamocles, SwordOfDamoclesCard)
    SwordOfDamocles.name = "DamocleSword"
    SwordOfDamocles.cost = 3
    SwordOfDamocles.power = 7
    SwordOfDamocles.text = "End of Turn: Loses 1 power if not winning this location."
    SwordOfDamocles.effectType = EFFECT_TYPE.onEndTurn

    function SwordOfDamoclesCard:activateEffect()
        if self.location.power <= self.location.opposingLocation.power then
            self.power = self.power - 1
        end
    end

    return SwordOfDamocles
end

MidasCard = {}
function MidasCard:new()
    MidasCard.__index = MidasCard
    setmetatable(MidasCard, {__index = CardClass})
    local Midas = CardClass:new()
    setmetatable(Midas, MidasCard)
    Midas.name = "Midas"
    Midas.cost = 5
    Midas.power = 3
    Midas.text = "When Revealed: Set ALL cards here to 3 power."
    Midas.effectType = EFFECT_TYPE.onReveal

    function MidasCard:activateEffect()
        for _, card in ipairs(self.location.cardTable) do
            card.power = 3
        end
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            card.power = 3
        end
        self.effectActivated = true
    end

    return Midas
end

AphroditeCard = {}
function AphroditeCard:new()
    AphroditeCard.__index = AphroditeCard
    setmetatable(AphroditeCard, {__index = CardClass})
    local Aphrodite = CardClass:new()
    setmetatable(Aphrodite, AphroditeCard)
    Aphrodite.name = "Aphrodite"
    Aphrodite.cost = 4
    Aphrodite.power = 7
    Aphrodite.text = "When Revealed: Lower the power of each enemy card here by 1."
    Aphrodite.effectType = EFFECT_TYPE.onReveal

    function AphroditeCard:activateEffect()
        for _, card in ipairs(self.location.opposingLocation.cardTable) do
            card.power = card.power - 1
        end
        self.effectActivated = true
    end

    return Aphrodite
end

ApolloCard = {}
function ApolloCard:new()
    ApolloCard.__index = ApolloCard
    setmetatable(ApolloCard, {__index = CardClass})
    local Apollo = CardClass:new()
    setmetatable(Apollo, ApolloCard)
    Apollo.name = "Apollo"
    Apollo.cost = 5
    Apollo.power = 6
    Apollo.text = "When Revealed: Gain +1 mana next turn."
    Apollo.effectType = EFFECT_TYPE.onReveal

    function ApolloCard:activateEffect()
        if self.isPlayer then playerApolloManaBoost = true else opponentApolloManaBoost = true end
        self.effectActivated = true
    end

    return Apollo
end

HephaestusCard = {}
function HephaestusCard:new()
    HephaestusCard.__index = HephaestusCard
    setmetatable(HephaestusCard, {__index = CardClass})
    local Hephaestus = CardClass:new()
    setmetatable(Hephaestus, HephaestusCard)
    Hephaestus.name = "Hephaestus"
    Hephaestus.cost = 4
    Hephaestus.power = 3
    Hephaestus.text = "When Revealed: Lower the cost of 2 cards in your hand by 1."
    Hephaestus.effectType = EFFECT_TYPE.onReveal

    function HephaestusCard:activateEffect()
        local hand = nil
        if self.isPlayer then hand = player.hand else hand = opponent.hand end

        local randomCard1 = hand[math.random(#hand)]
        randomCard1.cost = randomCard1.cost - 1

        local randomCard2 = hand[math.random(#hand)]
        randomCard2 = randomCard2.cost -1
        self.effectActivated = true
    end

    return Hephaestus
end

PersephoneCard = {}
function PersephoneCard:new()
    PersephoneCard.__index = PersephoneCard
    setmetatable(PersephoneCard, {__index = CardClass})
    local Persephone = CardClass:new()
    setmetatable(Persephone, PersephoneCard)
    Persephone.name = "Persephone"
    Persephone.cost = 4
    Persephone.power = 6
    Persephone.text = "When Revealed: Discard the lowest power card in your hand."
    Persephone.effectType = EFFECT_TYPE.onReveal

    function PersephoneCard:activateEffect()
        local hand = nil
        if self.isPlayer then hand = player.hand else hand = opponent.hand end

        -- find lowest power card
        local lowestPower = 100
        local lowestCard = nil
        for _, card in ipairs(hand) do
            if card.power < lowestPower then
                lowestPower = card.power
                lowestCard = card
            end
        end

        if lowestCard == nil then return end
        
        if self.isPlayer then
            for i, card in ipairs(hand) do
                if card == lowestCard then
                    player:removeCardFromHand(i)
                end
            end
            lowestCard.location = player.discard
            lowestCard:moveCard(SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2)
            table.insert(player.discard, lowestCard)
        else
            for i, card in ipairs(hand) do
                if card == lowestCard then
                    opponent:removeCardFromHand(i)
                end
            end
            lowestCard.location = opponent.discard
            lowestCard:moveCard(SCREEN_WIDTH/16, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2)
            table.insert(opponent.discard, lowestCard)
        end
        self.effectActivated = true
    end

    return Persephone
end

PrometheusCard = {}
function PrometheusCard:new()
    PrometheusCard.__index = PrometheusCard
    setmetatable(PrometheusCard, {__index = CardClass})
    local Prometheus = CardClass:new()
    setmetatable(Prometheus, PrometheusCard)
    Prometheus.name = "Prometheus"
    Prometheus.cost = 6
    Prometheus.power = 6
    Prometheus.text = "When Revealed: Draw a card from your opponent's deck."
    Prometheus.effectType = EFFECT_TYPE.onReveal

    function PrometheusCard:activateEffect()
        local deck = nil
        if self.isPlayer then deck = opponent.deck else deck = player.deck end

        local randomNum = math.random(#deck)
        stolenCard = table.remove(deck, randomNum)
        if self.isPlayer then player:addCardToHand(stolenCard) else opponent:addCardToHand(stolenCard) end
        self.effectActivated = true
    end

    return Prometheus
end

PandoraCard = {}
function PandoraCard:new()
    PandoraCard.__index = PandoraCard
    setmetatable(PandoraCard, {__index = CardClass})
    local Pandora = CardClass:new()
    setmetatable(Pandora, PandoraCard)
    Pandora.name = "Pandora"
    Pandora.cost = 4
    Pandora.power = 6
    Pandora.text = "When Revealed: If no ally cards are here, lower this card's power by 5."
    Pandora.effectType = EFFECT_TYPE.onReveal

    function PandoraCard:activateEffect()
        if #self.location.cardTable == 1 then
            self.power = self.power - 5

            if self.power < 0 then
                self.power = 0
            end
        end
        self.effectActivated = true
    end

    return Pandora
end

IcarusCard = {}
function IcarusCard:new()
    IcarusCard.__index = IcarusCard
    setmetatable(IcarusCard, {__index = CardClass})
    local Icarus = CardClass:new()
    setmetatable(Icarus, IcarusCard)
    Icarus.name = "Icarus"
    Icarus.cost = 5
    Icarus.power = 3
    Icarus.text = "End of Turn: Gains +1 power, but is discarded when its power is greater than 7."
    Icarus.effectType = EFFECT_TYPE.onEndTurn

    function IcarusCard:activateEffect()
        self.power = self.power + 1
        if self.power > 7 then
            self:discardCard()
        end
    end

    return Icarus
end

IrisCard = {}
function IrisCard:new()
    IrisCard.__index = IrisCard
    setmetatable(IrisCard, {__index = CardClass})
    local Iris = CardClass:new()
    setmetatable(Iris, IrisCard)
    Iris.name = "Iris"
    Iris.cost = 7
    Iris.power = 3
    Iris.text = "End of Turn: Give your cards at each other location +1 power if they have unique powers."
    Iris.effectType = EFFECT_TYPE.onEndTurn

    function IrisCard:activateEffect()
        local locationOptions = {}
        local locationTable = {}

        if self.isPlayer then locationTable = playerLocationTable else locationTable = opponentLocationTable end
        for _, location in ipairs(locationTable) do
            if location ~= self.location then
                table.insert(locationOptions, location)
            end
        end
        
        for _, location in ipairs(locationOptions) do
            for _, card in ipairs(location) do
                card.power = card.power + 1
            end
        end
    end

    return Iris
end

NyxCard = {}
function NyxCard:new()
    NyxCard.__index = NyxCard
    setmetatable(NyxCard, {__index = CardClass})
    local Nyx = CardClass:new()
    setmetatable(Nyx, NyxCard)
    Nyx.name = "Nyx"
    Nyx.cost = 6
    Nyx.power = 2
    Nyx.text = "When Revealed: Discards your other cards here, add their power to this card."
    Nyx.effectType = EFFECT_TYPE.onReveal

    function NyxCard:activateEffect()
        local cards = {}
        for _, card in ipairs(self.location.cardTable) do
            if card ~= self then
                table.insert(cards, card)
            end
        end
        for _, card in ipairs(cards) do
            card:discardCard()
            self.power = self.power + card.power
        end
        self.effectActivated = true
    end

    return Nyx
end

AtlasCard = {}
function AtlasCard:new()
    AtlasCard.__index = AtlasCard
    setmetatable(AtlasCard, {__index = CardClass})
    local Atlas = CardClass:new()
    setmetatable(Atlas, AtlasCard)
    Atlas.name = "Atlas"
    Atlas.cost = 8
    Atlas.power = 16
    Atlas.text = "End of Turn: Loses 1 power if your side of this location is full."
    Atlas.effectType = EFFECT_TYPE.onEndTurn

    function AtlasCard:activateEffect()
        if #self.location.cardTable == 4 then
            self.power = self.power - 1
        end
    end

    return Atlas
end

HeliosCard = {}
function HeliosCard:new()
    HeliosCard.__index = HeliosCard
    setmetatable(HeliosCard, {__index = CardClass})
    local Helios = CardClass:new()
    setmetatable(Helios, HeliosCard)
    Helios.name = "Helios"
    Helios.cost = 6
    Helios.power = 15
    Helios.text = "End of Turn: Discard this."
    Helios.effectType = EFFECT_TYPE.onEndTurn

    function HeliosCard:activateEffect()
        self:discardCard()
    end

    return Helios
end
-- Jim Lee
-- CMPM 121 - Project3
-- 5/9/2025
io.stdout:setvbuf("no")

require "vector"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
CARD_SIZE = Vector(SCREEN_WIDTH*0.078125, SCREEN_HEIGHT*0.194444)
CARD_OFFSET = Vector(CARD_SIZE.x + 10, CARD_SIZE.y + 10)
CARD_FONT_SIZE = 10
INFO_FONT_SIZE = 30

LOCATION_WIDTH_CENTER = SCREEN_WIDTH/2 - CARD_SIZE.x - (CARD_OFFSET.x-CARD_SIZE.x)/2
LOCATION_HEIGHT_PLAYER = SCREEN_HEIGHT/2 + SCREEN_HEIGHT/4 - CARD_SIZE.y - (CARD_OFFSET.y-CARD_SIZE.y)/2
LOCATION_HEIGHT_OPPONENT = SCREEN_HEIGHT/2 - SCREEN_HEIGHT/4 - CARD_SIZE.y- (CARD_OFFSET.y - CARD_SIZE.y)/2

BUTTON_WIDTH = SCREEN_WIDTH/20
BUTTON_HEIGHT = SCREEN_HEIGHT/30

WIN_SCORE = 100



require "location"
require "card"
require "grabber"
require "player"
require "opponent"
require "button"
require "GameManager"

cardPool = {
    WoodenCowCard,
    PegasusCard,
    MinotaurCard,
    TitanCard,
    ZeusCard,
    AresCard,
    CyclopsCard,
    PoseidonCard,
    ArtemisCard,
    HeraCard,
    DemeterCard,
    HadesCard,
    HerculesCard,
    DionysusCard,
    HermesCard,
    ShipOfTheseusCard,
    SwordOfDamoclesCard,
    MidasCard,
    AphroditeCard,
    ApolloCard,
    HephaestusCard,
    PersephoneCard,
    PrometheusCard,
    PandoraCard,
    IcarusCard, 
    NyxCard,
}

function love.load()
    love.window.setTitle("Of Gods and Monsters")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setBackgroundColor(0, 0.5, 0.5, 1)
    math.randomseed(os.time())
    grabber = GrabberClass:new()

    cardFont = love.graphics.newFont(CARD_FONT_SIZE)
    infoFont = love.graphics.newFont(INFO_FONT_SIZE)
    endFont = love.graphics.newFont(100)
    resultsFont = love.graphics.newFont(50)
    locationPointsFont = love.graphics.newFont(20)

    player = PlayerClass:new()
    playerLocationTable = {}
    playerLocationTable[1] = LocationClass:new(LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_PLAYER, "Arcadia", true)
    playerLocationTable[2] = LocationClass:new(LOCATION_WIDTH_CENTER, LOCATION_HEIGHT_PLAYER, "Olympus", true)
    playerLocationTable[3] = LocationClass:new(LOCATION_WIDTH_CENTER + LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_PLAYER, "Elysium", true)

    opponent = OpponentClass:new()
    opponentLocationTable = {}
    opponentLocationTable[1] = LocationClass:new(LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_OPPONENT, "Arcadia", false)
    opponentLocationTable[2] = LocationClass:new(LOCATION_WIDTH_CENTER, LOCATION_HEIGHT_OPPONENT,  "Olympus", false)
    opponentLocationTable[3] = LocationClass:new(LOCATION_WIDTH_CENTER + LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_OPPONENT, "Elysium", false)

    playerLocationTable[1].opposingLocation = opponentLocationTable[1]
    playerLocationTable[2].opposingLocation = opponentLocationTable[2]
    playerLocationTable[3].opposingLocation = opponentLocationTable[3]
    opponentLocationTable[1].opposingLocation = playerLocationTable[1]
    opponentLocationTable[2].opposingLocation = playerLocationTable[2]
    opponentLocationTable[3].opposingLocation = playerLocationTable[3]

    ShowCardsButton = ShowAllCardsButton:new(SCREEN_WIDTH/8 - BUTTON_WIDTH, SCREEN_HEIGHT - 50)
    EndTurnButton = EndTurnButton:new(7 *SCREEN_WIDTH/8, SCREEN_HEIGHT - 50)
    gameManager = GameManagerClass:new()

    win = false
    --create player deck
    dupeCount = {}
    for i = 0, 19, 1 do
        local num = math.random(#cardPool)
        local card = cardPool[num]:new()

        while not isLessThanThreeDupes(card) do
            num = math.random(#cardPool)
            card = cardPool[num]:new()
        end

        card:moveCard(SCREEN_WIDTH/16, LOCATION_HEIGHT_PLAYER + CARD_SIZE.y/2)
        card.faceUp = false
        card.isPlayer = true
        table.insert(player.deck, card)
    end

    for i = 0, 3, 1 do
        local num = math.random(#player.deck)
        local card = player.deck[num]
        table.remove(player.deck, num)
        player:addCardToHand(card)
    end

    --create opponent deck
    dupeCount = {}
    for i = 0, 19, 1 do
        local num = math.random(#cardPool)
        local card = cardPool[num]:new()

        while not isLessThanThreeDupes(card) do
            num = math.random(#cardPool)
            card = cardPool[num]:new()
        end
        
        card:moveCard(SCREEN_WIDTH - SCREEN_WIDTH/16 - CARD_SIZE.x, LOCATION_HEIGHT_OPPONENT + CARD_SIZE.y/2)
        card.faceUp = false
        card.isPlayer = false
        table.insert(opponent.deck, card)
    end

    for i = 0, 3, 1 do
        local num = math.random(#opponent.deck)
        local card = opponent.deck[num]
        table.remove(opponent.deck, num)
        opponent:addCardToHand(card)
    end
    opponent:stageCards()
end


function love.update(dt)
    gameManager:update(dt)
    if (isRevealingCards) then return end
    player:update()
    grabber:update()
end

function love.draw()
    if win == true then
        RestartButton = RestartButton:new(SCREEN_WIDTH/2 - BUTTON_WIDTH/2, SCREEN_HEIGHT/2 + (SCREEN_HEIGHT/4) - BUTTON_HEIGHT/2)
        if gameManager.winningPlayer == player then
            love.graphics.setFont(endFont)
            love.graphics.printf("YOU WIN!", SCREEN_WIDTH/2 - endFont:getWidth("YOU WIN")/2, SCREEN_HEIGHT/6, endFont:getWidth("YOU WIN!"),  "center")
        else
            love.graphics.setFont(endFont)
            love.graphics.printf("YOU LOSE!", SCREEN_WIDTH/2 - endFont:getWidth("YOU LOSE!")/2, SCREEN_HEIGHT/6, endFont:getWidth("YOU LOSE!"),  "center")
        end
        love.graphics.setFont(resultsFont)
        love.graphics.printf("RESULTS", SCREEN_WIDTH/2 - endFont:getWidth("RESULTS")/2, SCREEN_HEIGHT/3, endFont:getWidth("RESULTS"), "center")

        love.graphics.setColor(0, 0.329, 0, 1)
        love.graphics.printf("YOUR POINTS", SCREEN_WIDTH/3 - endFont:getWidth("YOUR POINTS")/2, SCREEN_HEIGHT/2.25, endFont:getWidth("YOUR POINTS"), "center")
        love.graphics.printf(tostring(gameManager.playerPoints), SCREEN_WIDTH/3 - endFont:getWidth(tostring(gameManager.playerPoints))/2, SCREEN_HEIGHT/1.75, endFont:getWidth(tostring(gameManager.playerPoints)), "center")

        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf("OPPONENT POINTS", SCREEN_WIDTH/1.5 - endFont:getWidth("OPPONENT POINTS")/2, SCREEN_HEIGHT/2.25, endFont:getWidth("OPPONENT POINTS"), "center")
        love.graphics.printf(tostring(gameManager.opponentPoints), SCREEN_WIDTH/1.5 - endFont:getWidth(tostring(gameManager.opponentPoints))/2, SCREEN_HEIGHT/1.75, endFont:getWidth(tostring(gameManager.opponentPoints)), "center")


        RestartButton:draw()

        return
    end

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, SCREEN_HEIGHT/2-1, SCREEN_WIDTH, 2)

    love.graphics.setFont(cardFont)

    for _, location in ipairs(playerLocationTable) do
        location:draw()
    end

    for _, location in ipairs(opponentLocationTable) do
        location:draw()
    end

    ShowCardsButton:draw()
    EndTurnButton:draw()

    opponent:draw()
    player:draw()
    grabber:draw()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse: "..tostring(love.mouse.getX()) .. ", ".. tostring(love.mouse.getY()))

end

function isLessThanThreeDupes(card)
    local found = false
    for name, count in pairs(dupeCount) do
        if card.name == name then
            dupeCount[name] = dupeCount[name] + 1
            found = true
            break
        end
    end

    if found == false then
        dupeCount[card.name] = 1
        return true
    end

    if dupeCount[card.name] == 3 then
        dupeCount[card.name] = 2
        return false
    end

    return true

end


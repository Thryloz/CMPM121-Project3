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

WIN_SCORE = 20

require "location"
require "card"
require "grabber"
require "player"
require "opponent"
require "button"
require "GameManager"

function love.load()
    love.window.setTitle("Of Gods and Monsters")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setBackgroundColor(0, 0.5, 0.5, 1)
    math.randomseed(os.time())
    grabber = GrabberClass:new()

    cardFont = love.graphics.newFont(CARD_FONT_SIZE)
    infoFont = love.graphics.newFont(INFO_FONT_SIZE)

    player = PlayerClass:new()
    playerLocationTable = {}
    playerLocationTable[1] = LocationClass:new(LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_PLAYER, "Greece", true)
    playerLocationTable[2] = LocationClass:new(LOCATION_WIDTH_CENTER, LOCATION_HEIGHT_PLAYER, "Olympus", true)
    playerLocationTable[3] = LocationClass:new(LOCATION_WIDTH_CENTER + LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_PLAYER, "River Styx", true)


    opponent = OpponentClass:new()
    opponentLocationTable = {}
    opponentLocationTable[1] = LocationClass:new(LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_OPPONENT, "Greece", false)
    opponentLocationTable[2] = LocationClass:new(LOCATION_WIDTH_CENTER, LOCATION_HEIGHT_OPPONENT,  "Olympus", false)
    opponentLocationTable[3] = LocationClass:new(LOCATION_WIDTH_CENTER + LOCATION_WIDTH_CENTER/2, LOCATION_HEIGHT_OPPONENT, "River Styx", false)

    ShowCardsButton = ShowAllCardsButton:new(SCREEN_WIDTH/8 - BUTTON_WIDTH, SCREEN_HEIGHT - 50)
    EndTurnButton = EndTurnButton:new(7 *SCREEN_WIDTH/8, SCREEN_HEIGHT - 50)
    gameManager = GameManagerClass:new()

    card = ZeusCard:new()
    card.isPlayer = true
    card.faceUp = true
    player:addCardToHand(card)
    card = ZeusCard:new()
    card.isPlayer = true
    card.faceUp = true
    player:addCardToHand(card)
    card = ZeusCard:new()
    card.isPlayer = true
    card.faceUp = true
    player:addCardToHand(card)
end

function love.update()
    player:update()
    grabber:update()
end

function love.draw()
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
    grabber:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse: "..tostring(love.mouse.getX()) .. ", ".. tostring(love.mouse.getY()))
    
    player:draw()
end




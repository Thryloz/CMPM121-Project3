-- Jim Lee
-- CMPM 121 - Project3
-- 5/9/2025
io.stdout:setvbuf("no")

require "vector"

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
CARD_SIZE = Vector(SCREEN_WIDTH*0.078125, SCREEN_HEIGHT*0.194444)
CARD_OFFSET = Vector(CARD_SIZE.x + 10, CARD_SIZE.y + 10)
FONT_SIZE = 10

LOCATION_WIDTH_CENTER = SCREEN_WIDTH/2 - CARD_SIZE.x - (CARD_OFFSET.x-CARD_SIZE.x)/2
LOCATION_HEIGHT_PLAYER = SCREEN_HEIGHT/2 + SCREEN_HEIGHT/4 - CARD_SIZE.y - (CARD_OFFSET.y-CARD_SIZE.y)/2
LOCATION_HEIGHT_OPPONENT = SCREEN_HEIGHT/2 - SCREEN_HEIGHT/4 - CARD_SIZE.y- (CARD_OFFSET.y - CARD_SIZE.y)/2

require "location"
require "card"
require "grabber"
require "player"
require "opponent"

function love.load()
    love.window.setTitle("Of Gods and Monsters")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.graphics.setBackgroundColor(0, 0.5, 0.5, 1)
    math.randomseed(os.time())
    grabber = GrabberClass:new()

    cardFont = love.graphics.newFont(FONT_SIZE)

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

    card = ZeusCard:new()
    card.faceUp = true
    player:addCard(card)
    card1 = PegasusCard:new()
    card1.faceUp = true
    player:addCard(card1)
    card2 = CyclopsCard:new()
    card2.faceUp = true
    player:addCard(card2)
    card3 = ZeusCard:new()
    card3.faceUp = true
    player:addCard(card3)

end

function love.update()
    player:update()
    grabber:update()
    for _, location in ipairs(playerLocationTable) do
        location:update()
    end
    for _, location in ipairs(opponentLocationTable) do
        location:update()
    end


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

    player:draw()
    opponent:draw()
    grabber:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Mouse: "..tostring(love.mouse.getX()) .. ", ".. tostring(love.mouse.getY()))


end




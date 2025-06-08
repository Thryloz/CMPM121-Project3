--Jim Lee

BUTTON_STATE = {
    IDLE = 0,
    MOUSE_OVER = 1,
}

ButtonClass = {}
function ButtonClass:new(posX, posY)
    local button = {}
    setmetatable(button, {__index = ButtonClass})

    button.position = Vector(posX, posY)
    button.size = Vector(BUTTON_WIDTH, BUTTON_HEIGHT)
    button.text = "Restart"
    button.state = BUTTON_STATE.IDLE
    
    return button
end

function ButtonClass:draw()
    love.graphics.setFont(cardFont)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.text, self.position.x, self.position.y, self.size.x, "center")

    if self.state == BUTTON_STATE.MOUSE_OVER and grabber.heldObject == nil then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    end
end

function ButtonClass:checkForMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver =
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y

  self.state = isMouseOver and BUTTON_STATE.MOUSE_OVER or BUTTON_STATE.IDLE
end

ShowAllCardsButton = {}
function ShowAllCardsButton:new(posX, posY)
    ShowAllCardsButton.__index = ShowAllCardsButton
    setmetatable(ShowAllCardsButton, {__index = ButtonClass})
    local showAllCards = ButtonClass:new()
    setmetatable(showAllCards, ShowAllCardsButton)

    showAllCards.position = Vector(posX, posY)
    showAllCards.text = "Show All Cards"

    return showAllCards
end

EndTurnButton = {}
function EndTurnButton:new(posX, posY)
    EndTurnButton.__index = EndTurnButton
    setmetatable(EndTurnButton, {__index = ButtonClass})
    local endTurn = ButtonClass:new()
    setmetatable(endTurn, EndTurnButton)
    
    endTurn.position = Vector(posX, posY)
    endTurn.text = "End Turn"

    return endTurn
end

RestartButton = {}
function RestartButton:new(posX, posY)
    RestartButton.__index = RestartButton
    setmetatable(RestartButton, {__index = ButtonClass})
    local restart = ButtonClass:new()
    setmetatable(restart, RestartButton)

    restart.position = Vector(posX, posY)
    restart.text = "Restart"

    return restart
end

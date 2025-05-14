--Jim Lee

PlayerClass = {}

PLAYER_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
}

function PlayerClass:new()
    local player = {}
    setmetatable(player, {__index = PlayerClass})

    player.deck = {}
    player.hand = {}
    player.mana = 0
    player.points = 0
    player.state = PLAYER_STATE.IDLE

    player.position = Vector(SCREEN_WIDTH/4 , SCREEN_HEIGHT - 10)
    player.interactSize = Vector(SCREEN_WIDTH/2, 20)


    return player
end

function PlayerClass:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)

    if (self.state == PLAYER_STATE.MOUSE_OVER and grabber.heldObject ~= nil) then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.position.x, self.position.y, self.interactSize.x, self.interactSize.y, 6, 6)
    end

    for _, card in ipairs(self.hand) do
        if card.state == CARD_STATE.MOUSE_OVER then
            card:moveCard(SCREEN_WIDTH/2 - CARD_SIZE.x/2, player.position.y - CARD_SIZE.y + 10)
        else
            card:moveCard(SCREEN_WIDTH/2 - CARD_SIZE.x/2, player.position.y - 20)
        end
        card:draw()
    end
end

function PlayerClass:addCard(card)
    table.insert(self.hand, card)
    card.location = self
end

function PlayerClass:removeCard(index)
    table.remove(self.hand, index)
end

function PlayerClass:checkForMouseOver(grabber)
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.interactSize.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.interactSize.y

  self.state = isMouseOver and PLAYER_STATE.MOUSE_OVER or PLAYER_STATE.IDLE
end
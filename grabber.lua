-- From Zac Emerzian
-- Modified by Jim Lee to achieve the grab functionality

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  setmetatable(grabber, {__index = GrabberClass})

  grabber.currentMousePos = nil
  grabber.grabPos = nil
  grabber.heldObject = nil
  grabber.offset = nil
  grabber.previousLocation = nil

  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  if grabber.currentMousePos == nil then return end

  player:checkForMouseOver(grabber)
  ShowCardsButton:checkForMouseOver(grabber)
  EndTurnButton:checkForMouseOver(grabber)

  for _, card in ipairs(player.hand) do
    card:checkForMouseOver(grabber)
  end

  for _, location in ipairs(playerLocationTable) do
    location:checkForMouseOver(grabber)
    for _, card in ipairs(location.cardTable) do
      card:checkForMouseOver(grabber)
    end
  end

  -- Grab card
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end

  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end
end

-- draw card in grabber's hand
function GrabberClass:draw()
  if self.heldObject ~= nil then
    self.heldObject:moveCard(self.currentMousePos.x + self.offset.x, self.currentMousePos.y + self.offset.y)
    self.heldObject:draw()
  end
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos

  -- check if show all button is clicked
  if self:CheckShowCardsButton() then player.showAllCards = not player.showAllCards return end
  if self:CheckEndTurnButton() then gameManager:endTurn() return end
  if self:CheckRestartButton() then love.load() return end

  -- check hand
  for i, card in ipairs(player.hand) do
    if card.state == CARD_STATE.MOUSE_OVER then
      self.heldObject = card
      self.offset = card.position - self.grabPos
      self.previousLocation = player.hand
      self.heldObject.state = CARD_STATE.GRABBED
      player:removeCardFromHand(i)
      break
    end
  end

  -- check locations
  if (self.heldObject == nil) then
    for _, location in ipairs(playerLocationTable) do
      for _, card in ipairs(location.cardTable) do
        if card.state == CARD_STATE.MOUSE_OVER then
          self.heldObject = card
          self.offset = card.position - self.grabPos
          self.previousLocation = location
          self.heldObject.state = CARD_STATE.GRABBED
          location:removeCard(card)

          if self.previousLocation == playerLocationTable[1] or self.previousLocation == playerLocationTable[2] or self.previousLocation == playerLocationTable[3] then
            player.mana = player.mana + self.heldObject.cost
          end
          break
        end
      end
    end
  end
end

function GrabberClass:release()
  if self.heldObject == nil then -- we have nothing to release
      self.offset = nil
      self.grabPos = nil
    return
  end

  local validLocation = false

  if self:CheckPlayerHand() then
      player:addCardToHand(self.heldObject)
      validLocation = true
  end

  for _, location in ipairs(playerLocationTable) do
    if self:CheckValidLocation(location) then
      location:addCard(self.heldObject)

      player.mana = player.mana - self.heldObject.cost

      validLocation = true
      break
    end
  end

  if not validLocation then
    if self.previousLocation == player.hand then 
      player:addCardToHand(self.heldObject);
    else
      print("invalid location")
      self.previousLocation:addCard(self.heldObject)
      player.mana = player.mana - self.heldObject.cost
    end
  end

  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.previousLocation = nil
  self.offset = nil
  self.grabPos = nil
end

-- helper function to see if mouse is in a location
function GrabberClass:CheckValidLocation(location)
  if self.currentMousePos.x > location.position.x and
  self.currentMousePos.x < location.position.x + location.interactSize.x and
  self.currentMousePos.y > location.position.y and
  self.currentMousePos.y < location.position.y + location.interactSize.y and
  #location.cardTable < 4 and player.mana >= self.heldObject.cost then return true end return false
end

-- helper function to see if mouse is hovering on hand section
function GrabberClass:CheckPlayerHand()
  if self.currentMousePos.x > player.position.x and
  self.currentMousePos.x < player.position.x + player.interactSize.x and
  self.currentMousePos.y > player.position.y and
  self.currentMousePos.y < player.position.y + player.interactSize.y and
  #player.hand < 7 then return true end return false
end

-- helper function to see if mouse is hovering over show all button
function GrabberClass:CheckShowCardsButton()
  if self.currentMousePos.x > ShowCardsButton.position.x and
  self.currentMousePos.x < ShowCardsButton.position.x + ShowCardsButton.size.x and
  self.currentMousePos.y > ShowCardsButton.position.y and
  self.currentMousePos.y < ShowCardsButton.position.y + ShowCardsButton.size.y
  then return true end return false
end

-- helper function to see if mouse is hovering over End Turn button
function GrabberClass:CheckEndTurnButton()
  if self.currentMousePos.x > EndTurnButton.position.x and
  self.currentMousePos.x < EndTurnButton.position.x + EndTurnButton.size.x and
  self.currentMousePos.y > EndTurnButton.position.y and
  self.currentMousePos.y < EndTurnButton.position.y + EndTurnButton.size.y
  then return true end return false
end

function GrabberClass:CheckRestartButton()
  if self.currentMousePos.x > RestartButton.position.x and
  self.currentMousePos.x < RestartButton.position.x + RestartButton.size.x and
  self.currentMousePos.y > RestartButton.position.y and
  self.currentMousePos.y < RestartButton.position.y + RestartButton.size.y
  then return true end return false
end

--Jim Lee

GameManagerClass = {}

function GameManagerClass:new()
    local gameManager = {}
    setmetatable(gameManager, {__index = GameManagerClass})

    gameManager.turn = 1
    gameManager.playerPoints = 0
    gameManager.opponentPoints = 0

    if math.random() > 0.5 then gameManager.winningPlayer = player else gameManager.winningPlayer = opponent end
    player.mana = gameManager.turn
    opponent.mana = gameManager.turn
    return gameManager
end

function GameManagerClass:endTurn()
    
    -- determine whose winning
    if gameManager.turn ~= 1 then
      if self.playerPoints > self.opponentPoints then self.winningPlayer = player
      elseif self.opponentPoints > self.playerPoints then self.winningPlayer = opponent
      elseif self.opponentPoints == self.playerPoints then
        if math.random() > 0.5 then gameManager.winningPlayer = player else gameManager.winningPlayer = opponent end
      end
    end

    -- determine which locations activate effects first
    local firstTable = nil
    local secondTable = nil
    if self.winningPlayer == player then
      firstTable = playerLocationTable
      secondTable = opponentLocationTable
    else
      firstTable = opponentLocationTable
      secondTable = playerLocationTable
    end


    -- activate effects
    for _, location in ipairs(firstTable) do
      for _, card in ipairs(location.cardTable) do
        if card.effectType == EFFECT_TYPE.onReveal and not card.effectActivated and card.location == location then
          card:activateEffect()
        end
        card.faceUp = true
      end
    end

    for _, location in ipairs(secondTable) do
      for _, card in ipairs(location.cardTable) do
        if card.effectType == EFFECT_TYPE.onReveal and not card.effectActivated and card.location == location then
          card.faceUp = true
          card:activateEffect()
        end
        card.faceUp = true
      end
    end

    -- calculated power after all effects are done
    for _, location in ipairs(firstTable) do
      location:calculatePower()
    end

    for _, location in ipairs(secondTable) do
      location:calculatePower()
    end

    -- points 
    for _, location in ipairs(playerLocationTable) do
      local diff = location.power - location.opposingLocation.power
      if diff >= 0 then
        self.playerPoints = self.playerPoints + diff
      else
        self.opponentPoints = self.opponentPoints - diff
      end
    end

    -- check win 
    if self.playerPoints >= WIN_SCORE then
      winningPlayer = player
      win = true
      return
    end

    if self.opponentPoints >= WIN_SCORE then
      winningPlayer = opponent
      win = true
    end

    -- end turn
    gameManager.turn = gameManager.turn + 1
    player.mana = gameManager.turn
    opponent.mana = gameManager.turn

    if #player.hand < 7 and #player.deck >= 1 then 
      local drawnCard = table.remove(player.deck, 1)
      player:addCardToHand(drawnCard)
    end

    if #opponent.hand < 7 and #opponent.deck >= 1 then 
      local drawnCard = table.remove(opponent.deck, 1)
      opponent:addCardToHand(drawnCard)
    end

    opponent:stageCards()
end




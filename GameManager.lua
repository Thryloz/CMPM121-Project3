--Jim Lee

isRevealingCards = false
playerApolloManaBoost = false
opponentApolloManaBoost = false
local cardsToActivate = {}

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
    print("-----Turn "..gameManager.turn.."-----")
    return gameManager
end

function GameManagerClass:endTurn()
    cardsToActivate = {}

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
        if card.effectType == EFFECT_TYPE.none and card.faceUp == false then
          table.insert(cardsToActivate, card)
        end
        if card.effectType == EFFECT_TYPE.onReveal and card.effectActivated == false then
          table.insert(cardsToActivate, card)
        end
      end
    end

    for _, location in ipairs(secondTable) do
      for _, card in ipairs(location.cardTable) do
        if card.effectType == EFFECT_TYPE.none and card.faceUp == false then
          table.insert(cardsToActivate, card)
        end
        if card.effectType == EFFECT_TYPE.onReveal and card.effectActivated == false then
          table.insert(cardsToActivate, card)
        end
      end
    end

    isRevealingCards = true

end

timer = 0
delay = 0.5

function GameManagerClass:update(dt)
  if isRevealingCards then
    if #cardsToActivate == 0 then
      isRevealingCards = false
      
      -- calculated power after all effects are done
      for _, location in ipairs(playerLocationTable) do
        location:calculatePower()
      end

      for _, location in ipairs(opponentLocationTable) do
        location:calculatePower()
      end

      print("---Point Breakdown---")
      -- points 
      for _, location in ipairs(playerLocationTable) do
        local diff = location.power - location.opposingLocation.power
        if diff >= 0 then
          self.playerPoints = self.playerPoints + diff
          if diff == 0 then
            print("Tie at " ..(location.name).. ", no points gained!")
          else
            print("You are winning at "..(location.name).." gaining "..(diff).." points!")
          end
        else
          self.opponentPoints = self.opponentPoints - diff
          if diff == 0 then
            print("Tie at " ..(location.name).. ", no points gained!")
          else
            print("Opponent is winning at "..(location.name).." gaining "..(-diff).." points!")
          end
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

      
      if playerApolloManaBoost then player.mana = player.mana + 1 end
      if opponentApolloManaBoost then opponent.mana = opponent.mana + 1 end
      playerApolloManaBoost = false
      opponentApolloManaBoost = false

      if #player.hand < 7 and #player.deck >= 1 then 
        local drawnCard = table.remove(player.deck, 1)
        player:addCardToHand(drawnCard)
      end

      if #opponent.hand < 7 and #opponent.deck >= 1 then 
        local drawnCard = table.remove(opponent.deck, 1)
        opponent:addCardToHand(drawnCard)
      end
      
      print("-----Turn "..gameManager.turn.."-----")
      opponent:stageCards()
      return
    end

    if timer < delay then
      timer = timer + dt
    else
      local card = cardsToActivate[1]
      if card.effectType == EFFECT_TYPE.onReveal then
        card:activateEffect()
      end
      card.faceUp = true
      if card.isPlayer then
        print("You reveal " ..card.name..".")
      else
        print("Opponent reveals " ..card.name..".")
      end
      table.remove(cardsToActivate, 1)
      timer = 0
    end
  end
end


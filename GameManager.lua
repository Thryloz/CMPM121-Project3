--Jim Lee

GameManagerClass = {}

GAME_STATE = {
  STAGING = 0,
  REVEAL = 1,
  END_TURN = 2,
}

function GameManagerClass:new()
    local gameManager = {}
    setmetatable(gameManager, {__index = GameManagerClass})

    gameManager.turn = 1
    gameManager.playerPoints = 0
    gameManager.opponentPoints = 0

    if math.random() > 0.5 then gameManager.winningPlayer = player else gameManager.winningPlayer = opponent end

    return gameManager
end

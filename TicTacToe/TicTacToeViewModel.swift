//
//  ViewModel.swift
//  TicTacToeViewModel
//
//  Created by Gianna Stylianou on 17/6/23.
//

import Foundation

class TicTacToeViewModel: ObservableObject {
    
    @Published var gameState = [[Square]]()
    @Published var currentPlayer = Player.X
    @Published var firstPlayer = Player.X
    @Published var xPlayerScore = 0
    @Published var oPlayerScore = 0
    @Published var xPlayerName = ""
    @Published var oPlayerName = ""
    @Published var displayMessage = false
    @Published var gameHasEnded = false
    @Published var messageToShow = GameStateMessage.start.rawValue
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        var newGame = [[Square]]()
        
        for _ in 0...2 {
            var row = [Square]()
            for _ in 0...2 {
                row.append(Square(tileType: .empty))
            }
            newGame.append(row)
        }
        
        currentPlayer = currentPlayer == firstPlayer ? Player.O : Player.X
        messageToShow = currentPlayer == Player.X ? "\(xPlayerName) plays first": "\(oPlayerName) plays first"

        gameHasEnded = false
        gameState = newGame
    }
    
    func startGame() {
        resetGame()
        messageToShow = "\(xPlayerName) plays first"
    }
    
    func placeTile(x: Int, y: Int) {
        if gameState[x][y].tileType != TileType.empty && !gameHasEnded {
            messageToShow = GameStateMessage.alert.rawValue
        } else {
            displayMessage = false
            if currentPlayer.rawValue == TileType.cross.rawValue {
                gameState[x][y].tileType = TileType.cross
            } else {
                gameState[x][y].tileType = TileType.circle
            }
        }
        
        if checkForWin(gameState: gameState, currentPlayer: currentPlayer) {
            gameHasEnded = true
            displayMessage = true
            messageToShow = currentPlayer.rawValue == TileType.cross.rawValue ? "\(xPlayerName) has won!" : "\(oPlayerName) has won!"
            
            if currentPlayer.rawValue == TileType.cross.rawValue {
                xPlayerScore += 1
            } else {
                oPlayerScore += 1
            }
            return
        } else {
            currentPlayer = currentPlayer.rawValue == TileType.cross.rawValue ? Player.O : Player.X
        }
        
        if checkForDraw(gameState: gameState) {
            gameHasEnded = true
            displayMessage = true
            messageToShow = GameStateMessage.draw.rawValue
        }

    }


    func checkForWin(gameState: [[Square]], currentPlayer: Player) -> Bool {
        let winPatterns: Set<Set<[Int]>> = [
            [[0, 0], [0, 1], [0, 2]], // Top row
            [[1, 0], [1, 1], [1, 2]], // Middle row
            [[2, 0], [2, 1], [2, 2]], // Bottom row
            [[0, 0], [1, 0], [2, 0]], // Left column
            [[0, 1], [1, 1], [2, 1]], // Middle column
            [[0, 2], [1, 2], [2, 2]], // Right column
            [[0, 0], [1, 1], [2, 2]], // Diagonal from top-left to bottom-right
            [[0, 2], [1, 1], [2, 0]]  // Diagonal from top-right to bottom-left
        ]
        
        for x in winPatterns {
            var playerWins = true
            for y in x {
                if gameState[y[0]][y[1]].tileType.rawValue != currentPlayer.rawValue {
                    playerWins = false
                    break
                }
            }
            
            if playerWins {
                gameHasEnded = true
                return true
            }
        }
        return false
    }

    
    func checkForDraw(gameState: [[Square]]) -> Bool {
        for row in 0..<3 {
            for column in 0..<3 {
                if gameState[row][column].tileType == .empty {
                    return false
                }
            }
        }
            
        return true
    }
}


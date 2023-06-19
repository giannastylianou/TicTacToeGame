//
//  TicTacToeData.swift
//  TicTacToe
//
//  Created by Gianna Stylianou on 17/6/23.
//

import Foundation

enum TileType: Int
{
    case cross = 0
    case circle = 1
    case empty = 2
    
    var tileIcon: String {
        switch self {
        case .cross: return "X_icon"
        case .circle: return "O_icon"
        case .empty: return "empty_icon"
        }
    }
}

struct Square {
    
    var tileType: TileType
    
    init(tileType: TileType) {
        self.tileType = tileType
    }

}

enum Player: Int
{
    case X = 0
    case O = 1
}

enum GameStateMessage: String
{
    case draw   = "It's a draw"
    case alert  = "Please choose a tile that is empty"
    case start  = "Start playing"
}


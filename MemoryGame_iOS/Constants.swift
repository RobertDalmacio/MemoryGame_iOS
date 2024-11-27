//
//  Constants.swift
//  MemoryGame
//
//  Created by Chaoyi Wu on 2024-10-23.
//

import Foundation
import UIKit

enum GameDifficulty: String{
    case easy
    case medium
    case hard
}

let defaultIconName = "alien"
let cardBackgroundImage = UIImage(named: "background_card")

let timeElapsedText = "Time elapsed (s): "
let movesText = "Moves: "

let NUM_GAMES = "numberOfGamesPlayed"
let COMPLETION_TIME = "completionTime"
let DATE_TIME = "dateTime"
let NUM_OF_MOVES = "numberOfMoves"
let GAME_DIFFICULTY = "gameDifficulty"

func getCardTotal(difficulty: GameDifficulty) -> Int {
    switch difficulty {
    case .medium:
        return 18
    case .hard:
        return 24
    default:
        return 8
    }
}

func getWidth(difficulty: GameDifficulty) -> Int {
    switch difficulty {
    case .medium:
        return 3
    case .hard:
        return 4
    default:
        return 2
    }
}

func getHeight(difficulty: GameDifficulty) -> Int {
    return getCardTotal(difficulty: difficulty) / getWidth(difficulty: difficulty)
}

func getNumberOfPairs(difficulty: GameDifficulty) -> Int {
    return getCardTotal(difficulty: difficulty)/2
}

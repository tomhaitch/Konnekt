//
//  GameState.swift
//  Konnekt
//
//  Created by Tom on 08/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Stores the current state of the game
// Singleton

import Foundation
import UIKit

class GameState{
    static let sharedInstance = GameState()
    
    var isPaused = false
    var isGameInProgress = false
    var currentScore: GameScore = GameScore(score: 0)
    var currentGameBoardPieces: [OnBoardGamePiece] = []
    
}



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

class GameState{
    static let sharedInstance = GameState()
    
    var paused = false
}

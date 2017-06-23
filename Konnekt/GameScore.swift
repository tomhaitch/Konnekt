//
//  GameScore.swift
//  Konnekt
//
//  Created by Tom on 10/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Class for holding score information about
// played games including currently playing
// game

// hold score, peice layout

import Foundation

// enum of score amounts per piece matches
enum PieceMatchValue: Int {
    case Zero = 0
    case One = 3
    case Two = 9
    case Three = 27
    case Four = 81
    case Five = 243
    case Six = 729
}

class GameScore{
    
    var score: Int
    var scoreDelegate: GameScoreDidChange? = nil          // the object to inform of score changes
    
    
    // init without delegate
    init(score: Int) {
        self.score = score
    }

    
    // init with a delegate
    init(score: Int, delegate: GameScoreDidChange) {
        self.score = score
        self.scoreDelegate = delegate
    }
    
    // method to increase the score as pieces are matched on the
    // game board
    func increaseForMatchedPieces(matchedPiece: OnBoardGamePiece) {
        self.score += matchedPiece.pieceScoreValue.rawValue
        
        // inform the delegate of the change
        self.scoreDelegate?.scroeDidChange(newScore: self.score)
    }
}


// the protocol to be adhered to for changing the score labels
protocol GameScoreDidChange {
    func scroeDidChange(newScore: Int)           // the score has changed
}

//
//  OnBoardGamePiece.swift
//  Konnekt
//
//  Created by Tom on 18/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// game piece class used for when a piece is on the 
// game board. stores extra info not required by the standard
// game piece.

import Foundation
import SpriteKit

// enum for pieces adjacent on the game board
// raw values used to access array
enum AdjacentPieceLocations: Int {
    case Left = 0
    case Above = 1
    case Right = 2
    case Below = 3
}

class OnBoardGamePiece: GamePiece {
    var boardCoordinates: CGPoint = .zero           // the board coords of this piece
    var boardGridPosition: Int = 0                  // the board array position of this piece
    private var adjacentArray: [OnBoardGamePiece?] =
                                        [nil, nil, nil, nil]    // the array of adjacent pieces
                                                                // set to true if any location
                                                                // matches piece type
    
    private (set) var pieceScoreValue: PieceMatchValue
                                        = .Zero                // what score value is this piece worth
    
    //init for empty piece
    init() {
        self.pieceScoreValue = .Zero
        super.init(pieceType: .Empty)
    }
    
    // init and set matching adjacents, in format
    // [left, up, right, down] true/false
    override init(pieceType: PieceType) {
        super.init(pieceType: pieceType)
        
        
        // set the piece score value
        switch pieceType {
        case .One:
            self.pieceScoreValue = .One
            break
            
        case .Two:
            self.pieceScoreValue = .Two
            break
            
        case .Three:
            self.pieceScoreValue = .Three
            break
            
        case .Four:
            self.pieceScoreValue = .Four
            break
            
        case .Five:
            self.pieceScoreValue = .Five
            break
            
        case .Six:
            self.pieceScoreValue = .Six
            break
            
        default:
            self.pieceScoreValue = .Zero
            break
        }
    
    }
    
    // required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // informs this piece that a matching adjacent piece has been placed
    func matchingAdjacentPiecePlaced(matchingPiece: OnBoardGamePiece, adjacentLocation: AdjacentPieceLocations) {
        self.adjacentArray[adjacentLocation.rawValue] = matchingPiece
    }
    
    // checks for matching pieces adjacent and returns coord of any matching
    // if not returns nil
    func checkForMatchingAdjacent() -> [OnBoardGamePiece] {
        var matches: [OnBoardGamePiece] = []
        
        // check through the adjacent pieces for any matches
        for i in 0 ... 3 {
            let element = self.adjacentArray[i]
            if element != nil {       // its not nil, so must be a match
                                
                // add to the returnable array and then call the adjacent piece to
                // check its adjacent pieces
                matches.append(element!)
                matches.append(contentsOf: self.adjacentArray[i]!.checkForMatchingAdjacent(avoiding: self))
            }
        }
        return matches
    }
    
    // checks for any matching adjacent pieces except for the piece that has called 
    // this method
    func checkForMatchingAdjacent(avoiding: OnBoardGamePiece) -> [OnBoardGamePiece]{
        var matches: [OnBoardGamePiece] = []
        
        // check through the adjacent pieces for any matches
        for i in 0 ... 3 {
            let element = self.adjacentArray[i]
            if element != nil && element != avoiding {       // its not nil, so must be a match
                
                // add to the returnable array and then call the adjacent piece to
                // check its adjacent pieces
                matches.append(element!)
                //matches.append(contentsOf: self.adjacentArray[i]!.checkForMatchingAdjacent())
            }
        }
        return matches

    }
}

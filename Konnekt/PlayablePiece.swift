//
//  PlayablePiece.swift
//  Konnekt
//
//  Created by Tom on 13/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// responsible for holding up to two game pieces when
// used together. 
// Piece 1 is spawned left and Piece 2 spawned right
// only Piece 1 used for single piece

// set andRightPieceType to nil for single piece

import Foundation
import SpriteKit

class PlayablePiece: SKNode{
    
    var Piece1: GamePiece!           // first game piece
    var Piece2: GamePiece!           // second game piece
    
    var currentRotation: Int = 0    // the current rotation of the pair. locked
                                    // to 0, 90, 180, 270 degrees
    
    init(withLeftPieceType: PieceType, andRightPieceType: PieceType? = nil) {
        
        super.init()
        
        // create and position piece one
        self.Piece1 = createGamePiece(type: withLeftPieceType)
        self.Piece1.position = CGPoint(x: 0, y: 0)    // minus due to sknode anchor point being
                                                        // .zero
        self.addChild(Piece1)
        
        if andRightPieceType != nil{
            
            // reset the position of piece one to allow for two pieces
            // to fit
            self.Piece1.position = CGPoint(x: -59, y: 0)    // minus due to sknode anchor point being
            // .zero
            
            //create and position piece two
            self.Piece2 = createGamePiece(type: andRightPieceType!)
            self.Piece2.position = CGPoint(x: 59, y: 0)
            self.addChild(Piece2)
        }
        
    }
    
    // create a game piece
    private func createGamePiece(type: PieceType) -> GamePiece{
        return GamePiece(pieceType: type)
    }
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

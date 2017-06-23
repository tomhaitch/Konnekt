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

enum PlayblePieceType {         // is it a single or a dual type piece
    case Single
    case Dual
}

enum PieceDirection {           // which direction is the piece facing if dual
    case Left
    case Up
    case Right
    case Down
}

class PlayablePiece: SKNode{
    
    let type: PlayblePieceType
    
    var Piece1: GamePiece!           // first game piece
    var Piece2: GamePiece!           // second game piece
    
    var currentDirection: PieceDirection = .Left    // the current direction of the pair
    
    // helper init method to make making a single playable piece type easier
    init(withPieceType: PieceType){
        
        type = .Single              // set the type of piece
        
        super.init()
        createPlayablePiece(withLeftPieceType: withPieceType, andRightPieceType: nil)
    }
    
    // helper init method to make a dual playable piece type
    init(leftPiece: PieceType, rightPiece: PieceType){
        
        type = .Dual                // set the type of piece
        
        super.init()
        createPlayablePiece(withLeftPieceType: leftPiece, andRightPieceType: rightPiece)
    }
    
    
    // master init method called by all others
    private func createPlayablePiece(withLeftPieceType: PieceType, andRightPieceType: PieceType? = nil) {
        
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
    
    // rotate by 90 degrees and set current direction flag
    func rotatePiece(){
        if self.type == .Dual {
            // switch based on the current amount of rotation
            switch self.currentDirection {
            case .Left:             // default rotation
                self.zRotation = 4.71239         // rotate by 90 degrees
                self.currentDirection = .Up
                self.Piece1.rotatePiece(to: .Up)        // rotate the piece to match down direction
                self.Piece2.rotatePiece(to: .Up)
                break
                
            case .Up:        // rotated clockwise by 90 degrees
                self.zRotation = 3.14159        // rotate by 90 degrees
                self.currentDirection = .Right
                self.Piece1.rotatePiece(to: .Right)        // rotate the piece to match down direction
                self.Piece2.rotatePiece(to: .Right)
                break
                
            case .Right:       // mirrored by 180 degrees
                self.zRotation = 1.5708       // rotate by 90 degrees
                self.currentDirection = .Down
                self.Piece1.rotatePiece(to: .Down)        // rotate the piece to match down direction
                self.Piece2.rotatePiece(to: .Down)
                break
                
            case .Down:       // rotated clockwise by 270 degrees
                self.zRotation = 0              // reset to 0 as gone all the way around
                self.currentDirection = .Left
                self.Piece1.rotatePiece(to: .Left)        // rotate the piece to match down direction
                self.Piece2.rotatePiece(to: .Left)
                break
            }
        }
    }
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

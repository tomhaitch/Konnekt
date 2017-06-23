//
//  GamePiece.swift
//  Konnekt
//
//  Created by Tom on 13/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

//  Class for the game pieces, contains logic to 
//  select the correct sprite

import Foundation
import SpriteKit

// enum piece types
enum PieceType: Int {
    case One = 1
    case Two = 2
    case Three = 3
    case Four = 4
    case Five = 5
    case Six = 6
    case Star = 7
    case Empty = 100        // empty slot piece holder
}

// enum piece rotation
enum PieceRotation {
    case Left
    case Up
    case Right
    case Down
}

class GamePiece: SKNode{
    
    private(set) var pieceType: PieceType   // the type of piece this is. only settable
                                            // by this class
    
    private var backgroundSprite: SKSpriteNode?      // Sprite for the piece bg
    private var dotsSprite: SKSpriteNode?            // sprite for the piece dots
    
    private(set) var currentRotation: PieceRotation =
                                                .Left   // which way is the piece currently facing
                                                        // where is the bottom edge
    
    
    init(pieceType : PieceType) {
        self.pieceType = pieceType
        
        super.init()
        
        // if not empty piece create the texture else be blank
        if pieceType != .Empty {
        
            let backgroundName = "Piece_" + String(self.pieceType.rawValue) + "_Bg.png"   // texture from piece
                                                                                // type
            let dotsName = "Piece_" + String(self.pieceType.rawValue) + "_Dot.png" // name of the dots image
            
            // create the two sprite nodes
            backgroundSprite = SKSpriteNode(imageNamed: backgroundName)
            dotsSprite = SKSpriteNode(imageNamed: dotsName)
            
            self.addChild(backgroundSprite!)
            self.addChild(dotsSprite!)
            
        }
    }
    
    // rotate the piece background to ensure the bottom is always down
    func rotatePiece(to: PieceRotation) {
        
        // which way is it currently facing, then rotate to new angle and reset
        // the currentRotation field
        
        switch self.currentRotation {
        case .Left:                             // currently standard, rotate to the right
            self.backgroundSprite?.zRotation = 1.5708
            self.dotsSprite?.zRotation = 1.5708
            self.currentRotation = .Up
            break
        case .Up:                               // rotated up, rotate to opposite
            self.backgroundSprite?.zRotation = 3.14159
            self.dotsSprite?.zRotation = 3.14159
            self.currentRotation = .Right
            break
        case .Right:                            // rotated right, rotate to right
            self.backgroundSprite?.zRotation = 4.71239
            self.dotsSprite?.zRotation = 4.71239
            self.currentRotation = .Down
            break
        case .Down:                             // rotated down, rotate to original
            self.backgroundSprite?.zRotation = 0
            self.dotsSprite?.zRotation = 0
            self.currentRotation = .Left
            break
        }
    }
    
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

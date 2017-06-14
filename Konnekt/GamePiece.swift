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
}

class GamePiece: SKSpriteNode{
    
    private(set) var pieceType: PieceType   // the type of piece this is. only settable
                                            // by this class
    
    init(pieceType : PieceType) {
        self.pieceType = pieceType
        
        let textureName = "Piece_" + String(self.pieceType.rawValue) + ".png"   // texture from piece
                                                                                // type
        let texture = SKTexture(imageNamed: textureName)
        
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

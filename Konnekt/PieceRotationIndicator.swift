//
//  PieceRotationIndicator.swift
//  Konnekt
//
//  Created by Tom on 11/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// class for the piece rotation indicator
// spins whilst not selected
// stops whilst piece grabbed

import Foundation
import SpriteKit

class PieceRotationIndicator: SKSpriteNode {
    
    private let spinAction: SKAction!   // action to spin the indicator, repeated forever
    
    init(){
        
        //create the texture for the sprite
        let texture = SKTexture(imageNamed: "Piece_Rotate_Indicator.png")
        
        // create the rotation action to keep the indicator spinning
        // repeated forever until cancelled
        self.spinAction = SKAction.repeatForever(SKAction.rotate(byAngle: -(360.0 * CGFloat.pi) / 180.0, duration: 6.0))
        
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    // piece spawned / released start action
    func startIndicating(){
        self.run(spinAction)
    }
    
    // piece grabbed stop action
    func stopIndicating(){
        self.removeAllActions()
    }
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

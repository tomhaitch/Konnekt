//
//  PeiceHold.swift
//  Konnekt
//
//  Created by Tom on 11/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// area / button to hold a peice that
// the played doesnt wish to use at this
// time, can only hold 1 peice at a time
// replaces when changed

import Foundation
import SpriteKit

class PieceHold : SKSpriteNode{
    
    private var label: SKLabelNode!     // label node to show hold / swap
    
    init() {
        //create the textures
        let emptyTexture = SKTexture(imageNamed: "Hold_Area_Empty.png")
        
        label = SKLabelNode.init(fontNamed: "Quicksand Bold")
        label.fontColor = .white
        label.fontSize = 22
        label.text = "Hold"
        
        label.verticalAlignmentMode = .baseline
        label.horizontalAlignmentMode = .right
        label.position = CGPoint(x: 99, y: 6)
        
        
        super.init(texture: emptyTexture, color: .white, size: emptyTexture.size())
        
        self.addChild(label)    // add the label
    }
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

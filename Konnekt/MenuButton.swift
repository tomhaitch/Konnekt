//
//  MenuButton.swift
//  Konnekt
//
//  Created by Tom on 08/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Button Class to create SpriteNode buttons
// and handle reactions to touches

// !! Must be child of scene only !!

import Foundation
import SpriteKit

class MenuButton: SKSpriteNode{
    
    private var touchedMethod: () -> Void   // method to call when button touched
    private let standardTexture: SKTexture  // default texture
    private let touchedTexture: SKTexture   // texture to use when button held down
    
    private var movedOutsideButton = false  // touch moved outside button
    
    init(defaultTextureName: String, pressedTextureName: String, touchMethod: @escaping () -> Void){
        
        standardTexture = SKTexture(imageNamed: defaultTextureName)
        touchedTexture = SKTexture(imageNamed: pressedTextureName)
        self.touchedMethod = touchMethod
        
        super.init(texture: standardTexture, color: .white, size: standardTexture.size())
        self.isUserInteractionEnabled = true    // enable touch interaction
    }
    
    
    // button down touched change texture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = touchedTexture
    }
    
    // touch moved, if outside button change to default texture
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.parent!)
            if !self.contains(location){
                self.texture = standardTexture
                movedOutsideButton = true
            }
        }
    }
    
    // touch ended, change to default texture
    // if touch location inside button call associated method
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = standardTexture
        
        for touch in touches {
            let location = touch.location(in: self.parent!)
            if self.contains(location) && !movedOutsideButton{
                self.touchedMethod()
            }
        }
        
        movedOutsideButton = false 
    }
    
    // required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

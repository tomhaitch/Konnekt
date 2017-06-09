//
//  MenuScene.swift
//  Konnekt
//
//  Created by Tom on 07/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Main menu scene
// Built from bottom to top

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    private let gameState = GameState.sharedInstance
    
    override func didMove(to view: SKView) {
        let button = MenuButton(defaultTextureName: "Btn_Play.png", pressedTextureName: "Btn_Play_Down.png", touchMethod: callbutton)
        button.position = CGPoint(x: 200, y: 200)
        self.addChild(button)
        
        self.setupScene()
    }
    
    // perform scene setup
    func setupScene(){
        self.backgroundColor = .white
    }
    
    func callbutton(){
        print("button pressed")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

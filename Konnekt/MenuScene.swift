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
        
        //label
        let label = SKLabelNode(fontNamed: "Quicksand Bold")
        label.fontSize = 36
        label.fontColor = UIColor.init(red: 204.0 / 255.0,
                                       green: 214.0 / 255.0,
                                       blue: 222.0 / 255.0,
                                       alpha: 1.0)
        label.text = "Play"
        label.position = CGPoint(x: 500, y: 500)
        
        self.addChild(label)
    }
    
    func callbutton(){
        print("button pressed")
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

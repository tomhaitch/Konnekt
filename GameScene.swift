//
//  GameScene.swift
//  Konnekt
//
//  Created by Tom on 11/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Main scene for gameplay


import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let textColor = UIColor.init(red: 204.0 / 255.0,        // default text color for game
                                 green: 214.0 / 255.0,
                                 blue: 222.0 / 255.0,
                                 alpha: 1.0)
    
    private let gameState = GameState.sharedInstance        // game state singleton reference
    private var gameScore: GameScore!                       // score for current game 
    private let holdArea: PieceHold = PieceHold()           // peice hold area
    private let rotationIndicator = PieceRotationIndicator()    // indicator for piece rotation
    
    override func didMove(to view: SKView) {
        self.setupScene()   // setup the scene
        self.beginGame()    // begin gameplay
    }
    
    // perform scene setup
    // nodes created from bottom to top of screen
    func setupScene(){
        self.backgroundColor = .white
        
        //piece hold area
        holdArea.anchorPoint = .zero
        holdArea.position = CGPoint(x: 0, y: 88)
        self.addChild(holdArea)
        
        //piece rotation indicator
        rotationIndicator.position = CGPoint(x: self.size.width / 2.0, y: 187)
        self.addChild(rotationIndicator)
        rotationIndicator.startIndicating()
        
        //score
        // if game is already in progress fetch the game score
        // from game state if not create a new one
        if gameState.isGameInProgress {
            self.gameScore = gameState.currentScore
        }
        else {
            self.gameScore = GameScore(score: 0)
            gameState.currentScore = self.gameScore // create and set new score object
        }
        
        // Menu Button
        let menuButton = MenuButton(defaultTextureName: "Btn_Menu.png", pressedTextureName: "Btn_Menu_Down.png", touchMethod: menuButtonPressed)
        menuButton.position = CGPoint(x: 91, y: 1236)
        self.addChild(menuButton)
        
        // Menu label
        let menuLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        menuLabel.fontSize = 20
        menuLabel.fontColor = textColor
        menuLabel.text = "Menu"
        
        menuLabel.verticalAlignmentMode = .baseline
        menuLabel.horizontalAlignmentMode = .right
        menuLabel.position = CGPoint(x: 123, y: 1189)
        
        self.addChild(menuLabel)
    }
    
    func beginGame(){
        gameState.isPaused = false      // unpause
        gameState.isGameInProgress = true   // set game in progress flag
        
    }
    
    // button press handlers
    func menuButtonPressed(){
        
        //pause the current game
        gameState.isPaused = true
        
        //create scene, initialise it and present it
        let menuScene = MenuScene.init(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        self.scene?.view?.presentScene(menuScene)
    }
}

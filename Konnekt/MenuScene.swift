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
    
    let textColor = UIColor.init(red: 204.0 / 255.0,
                                 green: 214.0 / 255.0,
                                 blue: 222.0 / 255.0,
                                 alpha: 1.0)
    let shareTextColor = UIColor.init(red: 153.0 / 255.0,
                                     green: 193.0 / 255.0,
                                     blue: 222.0 / 255.0,
                                     alpha: 1.0)
    
    private let gameState = GameState.sharedInstance
    
    private var previousGameImages: [UIImage] = []      // array of previous game images
    
    override func didMove(to view: SKView) {
        
        self.setupScene()
    }
    
    // perform scene setup
    func setupScene(){
        self.backgroundColor = .white
        
        //play resume button
        let playBtn = MenuButton(defaultTextureName: "Btn_Play.png", pressedTextureName: "Btn_Play_Down.png", touchMethod: playButtonPressed)
        playBtn.position = CGPoint(x: 256, y: 216)
        self.addChild(playBtn)
        
        //play resume label
        let playLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        playLabel.fontSize = 36
        playLabel.fontColor = textColor
        if gameState.isGameInProgress {
            playLabel.text = "Resume"
        }
        else{
            playLabel.text = "Play"
        }
        
        playLabel.verticalAlignmentMode = .baseline
        playLabel.horizontalAlignmentMode = .right
        playLabel.position = CGPoint(x: 331, y: 112)
        
        self.addChild(playLabel)
        
        //share button
        let shareBtn = MenuButton(defaultTextureName: "Btn_Share.png", pressedTextureName: "Btn_Share_Down.png", touchMethod: shareButtonPressed)
        shareBtn.position = CGPoint(x: 497, y: 216)
        self.addChild(shareBtn)
        
        //share label
        let shareLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        shareLabel.fontSize = 36
        shareLabel.fontColor = shareTextColor
        shareLabel.text = "Share"
        
        shareLabel.verticalAlignmentMode = .baseline
        shareLabel.horizontalAlignmentMode = .right
        shareLabel.position = CGPoint(x: 572, y: 112)
        
        self.addChild(shareLabel)
        
        //swipe for more label
        let swipeLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        swipeLabel.fontSize = 40
        swipeLabel.fontColor = textColor
        swipeLabel.text = "<<   Swipe for more   >>"
        
        swipeLabel.verticalAlignmentMode = .baseline
        swipeLabel.horizontalAlignmentMode = .center
        swipeLabel.position = CGPoint(x: self.size.width / 2.0, y: 390)
        
        self.addChild(swipeLabel)
        
        // swiping view for previous games
        let swipeView = SwipeView(size: CGSize(width: self.size.width,
                                               height: 674))
        
        swipeView.position = CGPoint(x: self.size.width / 2.0,
                                     y: 830)
        
        self.addChild(swipeView)
        
        
        var gms: GameScore
        gms = gameState.currentScore
        
        swipeView.addView(contentNode: createPreviousScoreCard(fromGameScore: gms))
        swipeView.addView(contentNode: createPreviousScoreCard(fromGameScore: gms))
        swipeView.addView(contentNode: createPreviousScoreCard(fromGameScore: gms))
        swipeView.addView(contentNode: createPreviousScoreCard(fromGameScore: gms))
        swipeView.addView(contentNode: createPreviousScoreCard(fromGameScore: gms))
        
        // back button to return to game if necessary
        if gameState.isPaused {
            
            //back button
            let backBtn = MenuButton(defaultTextureName: "Btn_Back.png", pressedTextureName: "Btn_Back_Down.png", touchMethod: backButtonPressed)
            backBtn.position = CGPoint(x: 91, y: 1236)
            self.addChild(backBtn)
            
            //back label
            let backLabel = SKLabelNode(fontNamed: "Quicksand Bold")
            backLabel.fontSize = 20
            backLabel.fontColor = textColor
            backLabel.text = "Back"
            
            backLabel.verticalAlignmentMode = .baseline
            backLabel.horizontalAlignmentMode = .right
            backLabel.position = CGPoint(x: 123, y: 1189)
            
            self.addChild(backLabel)
            
        }
    }
    
    // called by game scene when new image of gameboard has been created
    func gameBoardImageCreated(image: UIImage) {
        
    }
    
    
    // Btn Call Handlers
    
    func playButtonPressed(){
        // load game scene, initalise and present it
        let gameScene = GameScene.init(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.scene?.view?.presentScene(gameScene)
    }
    
    func shareButtonPressed(){
        
    }
    
    func backButtonPressed(){
        // load game scene, initalise and present it
        let gameScene = GameScene.init(size: self.size)
        gameScene.scaleMode = .aspectFill
        
        self.scene?.view?.presentScene(gameScene)
    }
    
    // create card for previous score
    // returns usable SKNode for swipe view
    func createPreviousScoreCard(fromGameScore: GameScore) -> SKNode {
        let parentNode = SKNode()
        
        //screenshot
        let playSS = SKSpriteNode(imageNamed: "Play_Screenshot.png")
        playSS.anchorPoint = CGPoint(x: 0.5, y: 0)
        playSS.position = CGPoint(x: self.size.width / 2.0,
                                  y: 0)
        
        parentNode.addChild(playSS)
        
        //paused label
        let pausedLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        pausedLabel.fontSize = 42
        pausedLabel.fontColor = textColor
        pausedLabel.text = "(Paused)"
        
        pausedLabel.verticalAlignmentMode = .baseline
        pausedLabel.horizontalAlignmentMode = .center
        pausedLabel.position = CGPoint(x: self.size.width / 2.0,
                                       y: 580)
        
        if self.gameState.isPaused {            // only add paused label for a paused game
            parentNode.addChild(pausedLabel)
        }
        
        //score label
        let scoreLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        scoreLabel.fontSize = 90
        scoreLabel.fontColor = UIColor.init(red: 91.0 / 255.0,
                                            green: 100.0 / 255.0,
                                            blue: 107.0 / 255.0,
                                            alpha: 1.0)
        scoreLabel.text = String(fromGameScore.score)
        
        scoreLabel.verticalAlignmentMode = .baseline
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.size.width / 2.0,
                                       y: 641)
        
        parentNode.addChild(scoreLabel)
        
        
        return parentNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

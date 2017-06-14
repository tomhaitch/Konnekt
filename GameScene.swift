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
    
    private let gamePieceSpawnLocation =
                        CGPoint(x: 375, y: 187)             // location to spawn new game pieces
    
    private let gameState = GameState.sharedInstance        // game state singleton reference
    private var gameScore: GameScore!                       // score for current game 
    private let holdArea: PieceHold = PieceHold()           // peice hold area
    private let rotationIndicator =
                                PieceRotationIndicator()    // indicator for piece rotation
    private let gameBoard = GameBoard()                     // game board play area
    private let scoreIndicator =
                SKLabelNode(fontNamed: "Quicksand Bold")    // label to indicate
                                                                          // current score
    
    private var inPlayGamePiece: PlayablePiece?             // the game piece current in play
                                                            // (moveable)
    private var isCurrentlyDraggingPiece = false            // flag for moving piece when touched
    private var touchOffsetFromCenter: CGPoint = .zero      // the offset between the touch and
                                                            // the center of the piece, for dragging accuracy
    
    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true    //enable touch, not multitouch
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
        
        // create the gameboard, the gameboard is responsible
        // for choosing which pieces to generate next, so
        // needs to be created first
        gameBoard.position = CGPoint(x: 57, y: 385)
        self.addChild(gameBoard)
        
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
        
        // score label
        let scoreLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        scoreLabel.fontColor = textColor
        scoreLabel.fontSize = 32
        scoreLabel.text = "Score"
        
        scoreLabel.verticalAlignmentMode = .baseline
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 685, y: 1090)
        self.addChild(scoreLabel)
        
        // score indicator
        scoreIndicator.fontColor = UIColor.init(red: 91.0 / 255.0,
                                                green: 100.0 / 255.0,
                                                blue: 107.0 / 255.0,
                                                alpha: 1.0)
        scoreIndicator.fontSize = 90
        scoreIndicator.text = String(self.gameScore.score)
        
        scoreIndicator.verticalAlignmentMode = .baseline
        scoreIndicator.horizontalAlignmentMode = .right
        scoreIndicator.position = CGPoint(x: 685, y: 1134)
        self.addChild(scoreIndicator)
        
        
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
        
        // spawn the first piece
        let piece = PlayablePiece(withLeftPieceType: .One, andRightPieceType: .Three)
        self.movePlayablePieceToSpawnLocation(piece: piece)
        
        self.inPlayGamePiece = piece
        
        self.addChild(piece)
    }
    
    // set the playable piece location to the spawn position
    private func movePlayablePieceToSpawnLocation(piece: PlayablePiece){
        piece.position = self.gamePieceSpawnLocation
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
    
    //touch handling, no multitouch so only ever one touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //check if touch is within pieces
        let location = touches.first!.location(in: self)     // get touch location
        
        if inPlayGamePiece!.contains(location){     // check if touched the pieces
                
            self.isCurrentlyDraggingPiece = true    // set piece dragging flag
            self.touchOffsetFromCenter = location - self.inPlayGamePiece!.position
            print(touchOffsetFromCenter)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if currently moving piece flag set, move the in play piece
        if isCurrentlyDraggingPiece{
            let location = touches.first!.location(in: self)    // get touch location
            
            //set inplay piece position accordingly
            inPlayGamePiece?.position = location - touchOffsetFromCenter
        }
    }
    
    // end the touch phase, change flags back and if over game board position
    // using gameboards methods, otherwise return to original position
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let location = touches.first!.location(in: self)    // get touch location
        
        if self.gameBoard.contains(location){       // check if fallen within the gameboard
            
        }
        else {                                      // outside gameboard, reset position
            self.movePlayablePieceToSpawnLocation(piece: self.inPlayGamePiece!)
        }
        
        self.isCurrentlyDraggingPiece = false   // reset the flag
        
    }
    
}

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
    internal let rotationIndicator =
                                PieceRotationIndicator()    // indicator for piece rotation
    private var gameBoard: GameBoard!                      // game board play area
    internal let scoreIndicator =
                SKLabelNode(fontNamed: "Quicksand Bold")    // label to indicate
                                                                          // current score
    
    private var inPlayGamePiece: PlayablePiece?             // the game piece current in play
                                                            // (moveable)
    private var touchBeganLocation: CGPoint? = .zero         // where the touch began, used to check if
                                                            // dragging or rotating
    private var isCurrentlyDraggingPiece = false            // flag for moving piece when touched
    private var touchOffsetFromCenter: CGPoint = .zero      // the offset between the touch and
                                                            // the center of the piece, for dragging accuracy
    
    internal var currentPieceTypeIsDual: Bool = false      // what type of piece is currently in play
    
    private var gameOverModal: SKSpriteNode!                // the modal to display for game over, initally 
                                                            // offscreen
    private var gameOverScoreLabel: SKLabelNode!             // the final score label node
    
    private var isGameOver = false                          // is the game over, used for touch detection
    
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
        gameBoard = GameBoard(sceneDelegate: self)
        gameBoard.position = CGPoint(x: 57, y: 385)
        self.addChild(gameBoard)
        
        //score
        // if game is already in progress fetch the game score
        // from game state if not create a new one
        if gameState.isGameInProgress {
            self.gameScore = gameState.currentScore
            self.gameScore.scoreDelegate = self             // set the score delegate to self
        }
        else {
            self.gameScore = GameScore(score: 0, delegate: self)
            gameState.currentScore = self.gameScore // create and set new score object
        }
        
        // pass the score object to the game board
        self.gameBoard.gameScore = self.gameScore
        self.gameBoard.gameState = self.gameState
        
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
        let menuButton = MenuButton(defaultTextureName: "Btn_Menu.png",
                                    pressedTextureName: "Btn_Menu_Down.png",
                                    touchMethod: menuButtonPressed)
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
        
        // create the game over modal
        self.createGameOverModal()
        
    }
    
    func createGameOverModal(){
        
        
        //create the modal background
        self.gameOverModal = SKSpriteNode(imageNamed: "Modal_Game_Over.png")
        self.gameOverModal.position = CGPoint(x: self.scene!.size.width / 2.0,
                                              y: -1000)
        
        // create the final score
        self.gameOverScoreLabel = SKLabelNode(fontNamed: "Quicksand Bold")
        self.gameOverScoreLabel.fontColor = UIColor.init(red: 91.0 / 255.0,
                                                green: 100.0 / 255.0,
                                                blue: 107.0 / 255.0,
                                                alpha: 1.0)
        self.gameOverScoreLabel.fontSize = 100
        self.gameOverScoreLabel.text = String(self.gameScore.score)
        
        self.gameOverScoreLabel.verticalAlignmentMode = .baseline
        self.gameOverScoreLabel.horizontalAlignmentMode = .center
        self.gameOverScoreLabel.position = CGPoint(x: 0, y: 0)
        
        gameOverModal.addChild(self.gameOverScoreLabel)
        
        // create the menu button
        let gameOverMenuButton = MenuButton(defaultTextureName: "Btn_Game_Over_Menu.png",
                                            pressedTextureName: "Btn_Game_Over_Menu.png",
                                            touchMethod: gameOverMenuButtonPressed)
        gameOverMenuButton.anchorPoint = CGPoint(x: 0.5, y: 0)
        gameOverMenuButton.position = CGPoint(x: 0, y: -275)
        
        gameOverModal.addChild(gameOverMenuButton)
        
        gameOverModal.zPosition = 2
        
        self.addChild(self.gameOverModal)
    }
    
    func beginGame(){
        gameState.isPaused = false      // unpause
        gameState.isGameInProgress = true   // set game in progress flag
        
        // spawn the first piece
        self.createNewPlayablePiece()
    }
    
    // spawn a new playable piece, call game board to ask what piece
    // to create
    private func createNewPlayablePiece() {
        
        // what to spawn
        let piece = self.gameBoard.nextPieceToSpawn()
        
        // check if there is space for this piece
        var isDual = true
        if piece.Piece2 == nil {
            isDual = false
        }
        if self.gameBoard.isSpaceAvailable(isDualPiece: isDual) == false {
            
            // no space game over
            self.gameState.isGameInProgress = false
            self.isGameOver = true
            
            self.gameOverScoreLabel.text = String(self.gameScore.score)
            
            let action = SKAction.move(to: CGPoint(x: 375, y: 667),
                                       duration: 1.25)
            let fade = SKAction.colorize(with: UIColor.gray, colorBlendFactor: 1.0, duration: 1.0)
            
            let fadeSprite = SKSpriteNode(texture: nil, color: UIColor.clear, size: self.scene!.size)
            fadeSprite.position = CGPoint(x: self.scene!.size.width / 2.0,
                                          y: self.scene!.size.height / 2.0)
            
            fadeSprite.zPosition = 1
            self.addChild(fadeSprite)
            
            self.gameOverModal.run(action)
            fadeSprite.run(fade)
            
            return
        }
        
        // set the inPlayPiece to the newest piece
        self.inPlayGamePiece = piece
        self.addChild(piece)
        
        // move to spawn location
        self.movePlayablePieceToSpawnLocation(piece: piece)
    }
    
    // set the playable piece location to the spawn position
    private func movePlayablePieceToSpawnLocation(piece: PlayablePiece){
        piece.position = self.gamePieceSpawnLocation
    }
    
    // called to present the menu scene and pass created uiimage of
    // the gameboard
    private func menuScenePresent(){
        
        //create scene, initialise it and present it
        let menuScene = MenuScene.init(size: self.size)
        menuScene.scaleMode = .aspectFill
        
        menuScene.gameBoardImageCreated(image: self.gameBoard.createGameBoardUIImage())
        
        self.scene?.view?.presentScene(menuScene)
    }
    
    // button press handlers
    func menuButtonPressed(){
        
        //pause the current game
        gameState.isPaused = true
        
        //save the current gameboard
        //self.gameBoard.saveGameBoard()
        
        // present the menu scene
        self.menuScenePresent()
    }
    
    func gameOverMenuButtonPressed(){
        
        // set the gamestate flags
        gameState.isPaused = false
        gameState.isGameInProgress = false
        
        // present the menu scene
        self.menuScenePresent()
    }
    
    //touch handling, no multitouch so only ever one touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // is game over?
        if self.isGameOver == false {
        
            // store the touch location to check if rotate or drag in
            // touches ended method
            self.touchBeganLocation = touches.first!.location(in: self)
        
            // check if touch is within pieces
            if inPlayGamePiece!.contains(self.touchBeganLocation!){     // check if touched the pieces
                
                self.isCurrentlyDraggingPiece = true    // set piece dragging flag
                self.touchOffsetFromCenter = self.touchBeganLocation!
                                         - self.inPlayGamePiece!.position
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // is game over?
        if self.isGameOver == false {
        
            //if currently moving piece flag set, move the in play piece
            if isCurrentlyDraggingPiece{
                let location = touches.first!.location(in: self)    // get touch location
            
                //set inplay piece position accordingly
                inPlayGamePiece?.position = location - touchOffsetFromCenter
            }
        }
    }
    
    // end the touch phase, change flags back and if over game board position
    // using gameboards methods, otherwise return to original position
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let location = touches.first!.location(in: self)    // get touch location
        
        // is game over?
        if self.isGameOver == false {
        
            // only rotate if its a dual piece
            if self.currentPieceTypeIsDual {
                if self.touchBeganLocation!.isWithinTolerance(of: location,  // check if touches are within tolerance
                                                    xTolerance: 10, yTolerance: 10) {   // for rotating not dragging
                    // rotate piece
                    self.inPlayGamePiece?.rotatePiece()
            
                }
            }
        
            if self.gameBoard.contains(inPlayGamePiece!.position){       // check if fallen within the gameboard
            
                if self.gameBoard.pieceDropped(piece: inPlayGamePiece!) { // call board to calculate where dropped
                                                                       // and if not accepted by board reset position
                
                    // remove the current inPlayGamePiece as its been added to the board
                    self.inPlayGamePiece!.removeFromParent()
                    self.inPlayGamePiece = nil
                
                    // piece accepted create next piece
                    self.createNewPlayablePiece()
                }
                else {                                  // reset position
                    self.movePlayablePieceToSpawnLocation(piece: self.inPlayGamePiece!)
                }
            }
            else {                                      // outside gameboard, reset position
                self.movePlayablePieceToSpawnLocation(piece: self.inPlayGamePiece!)
            }
        
            self.isCurrentlyDraggingPiece = false   // reset the flag
        
        }
        
        else{                   // only allow touching of the modal
            
            }
    }
    
}


// protocol delegate to change the score labels
extension GameScene: GameScoreDidChange {

    // change the score label
    func scroeDidChange(newScore: Int) {
        self.scoreIndicator.text = String(newScore)
    }
}

// protocol delegate from the game board
extension GameScene: GameBoardSceneProtocol {
    
    // what type of piece has just been spawned
    func nextGamePieceGenerated(isDual: Bool) {
        
        // set the flag
        self.currentPieceTypeIsDual = isDual
        
        // hide the rotation indicator if a single piece
        if isDual {
            self.rotationIndicator.isHidden = false
        }
        else {
            self.rotationIndicator.isHidden = true
        }
    }
}

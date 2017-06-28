//
//  GameBoardView.swift
//  Konnekt
//
//  Created by Tom on 28/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// class for the game board view, contains display code
// logic seperate in the controller


import Foundation
import SpriteKit

class GameBoardView: SKNode {
    
    private var gameBoardSprite: SKSpriteNode!              // the board background
    private var gamePieces: [OnBoardGamePiece] = []         // array of pieces on the board
    
    override init() {

        super.init()
        
        // create the game board
        self.createGameBoard()

    }
    
    // create the gameboard
    private func createGameBoard(){
        self.gameBoardSprite = SKSpriteNode(imageNamed: "Game_Board.png")
        self.gameBoardSprite.anchorPoint = .zero
        self.gameBoardSprite.position = .zero
        
        self.addChild(self.gameBoardSprite)
        
        // fill the array with empty pieces
        
    }
    
    // add a piece to the board at the specified coordinates
    func addPieceToBoard(piece: OnBoardGamePiece, atCoordinates: CGPoint) {
        
        // calculate the array position for the new piece
        let arrayPos = calculatePieceGridPosition(fromCoordinates: atCoordinates)
        
        
        // add the piece to be displayed, setting display position
        piece.position = calculatePrecisePiecePosition(fromBoardCoordinates: atCoordinates)
        piece.boardCoordinates = atCoordinates
        self.addChild(piece)
        
        // add piece to array
        self.gamePieces[arrayPos] = piece
        
    }
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

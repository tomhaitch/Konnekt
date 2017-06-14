//
//  GameBoard.swift
//  Konnekt
//
//  Created by Tom on 13/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

//  class responsible for creating and managing
//  the gameboard

import Foundation
import SpriteKit

class GameBoard: SKNode{
    
    private var gameBoardSprite: SKSpriteNode!          // sprite background for board
    private var gamePieces: [GamePiece] = []            // array of pieces on the board
                                                        // single dimension, from bottom left
                                                        // to top right
    
    
    // used to calculate positions and slot drops
    private let boardSlotHorizontalLeading = 19.0         // distance between edge of board
                                                        // and first slot edge
                                                        // minus the horizontal gap
    private let boardSlotVerticalLeading = 20.0           // distance between bottom of board
                                                        // and first slot bottom
                                                        // minus the vertical gap
    private let boardSlotsHorizontalGap = 8.0             // horizontal gap between slots
    private let boardSlotsVerticalGap = 8.0                // vertical gap between slots
    private let slotSize =                              // size of the slots
                    CGSize(width: 110, height: 110)
    
    override init() {
        
        super.init()
        
        self.createGameBoard()
    }
    
    // create the gameboard
    private func createGameBoard(){
        self.gameBoardSprite = SKSpriteNode(imageNamed: "Game_Board.png")
        self.gameBoardSprite.anchorPoint = .zero
        self.gameBoardSprite.position = .zero
        
        self.addChild(self.gameBoardSprite)
        
        
        //TESTING CODE TO BE REMOVED
        let a = self.calculatePieceBoardCoordinates(fromGridPosition: 21)
        let b = self.calculatePrecisePiecePosition(fromBoardCoordinates: a)
        print(a)
        print(b)
        
        let p = GamePiece(pieceType: .Four)
        p.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        p.position = b
        self.addChild(p)
    }
    
    //calculate where playable piece has been dropped coordinates
    func pieceDroppedAt(location: CGPoint, piece: PlayablePiece){
        
        // calculate by using the center point of the playable piece
        // checking if in left or right side of slot and
        // placing accordingly
        
    }
    
    // calculate the board coordinates of the piece from grid position
    private func calculatePieceBoardCoordinates(fromGridPosition: Int) -> CGPoint{
        
        // calculate yPos fromGridPos / 5 rounded up
        var yPos = Int(ceil(Double(fromGridPosition) / 5.0))
        if yPos == 0 { yPos = 1 } // calcuation fails for fromGridPosition 0
        
        // calculate xPos, array pos - (5 * YCoord)
        let xPos: Int
        if fromGridPosition <= 4{
            xPos = fromGridPosition
        }
        else{
            xPos = fromGridPosition - (5 * (yPos - 1))
        }
        
        // 5 rows of 5 slots, calculate row/colum coord from pos in array
        let coord = CGPoint(x: xPos + 1,     // use ceil to round up
                            y: yPos)
        
        return coord
    }
    
    // calculate the precise position for a piece using its board
    // coordinates
    private func calculatePrecisePiecePosition(fromBoardCoordinates: CGPoint) -> CGPoint {
        
        // use leading spaces and gaps to calculate x pos
        // lots of casting to CGFloats to enable calculation
        let xPos = CGFloat(self.boardSlotHorizontalLeading) +
                        (fromBoardCoordinates.x * CGFloat(self.boardSlotsHorizontalGap)) +
                        CGFloat(self.slotSize.width / 2) +
                        ((fromBoardCoordinates.x - 1) * CGFloat(self.slotSize.width))
        
        // use leading spaces and gaps to calculate y pos
        let yPos = CGFloat(self.boardSlotVerticalLeading) +
                        (fromBoardCoordinates.y * CGFloat(self.boardSlotsVerticalGap)) +
                        CGFloat(self.slotSize.height / 2) +
                        ((fromBoardCoordinates.y - 1) * CGFloat(self.slotSize.height))
        
        return CGPoint(x: xPos, y: yPos)
        
    }
    
    // required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

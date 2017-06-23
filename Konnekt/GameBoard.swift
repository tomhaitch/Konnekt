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
import GameplayKit

class GameBoard: SKNode{
    
    private let gameSceneDelegate: GameBoardSceneProtocol  // the game scene delegate
    
    private var gameBoardSprite: SKSpriteNode!          // sprite background for board
    private var gamePieces: [OnBoardGamePiece] = []            // array of pieces on the board
                                                        // single dimension, from bottom left
                                                        // to top right, filled with empty slots
                                                        // at start
    
    var gameScore: GameScore? = nil             // the game score object set from the gamescene
    var gameState: GameState = GameState.sharedInstance             // the current game state
    
    
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
    
    
    private let slotDetectionSize =
                    CGSize(width: 70, height: 70)       // size of the slot to use for dectecting
                                                        // if a piece has fallen within slot
    
    private var boardSlotRects: [CGRect] = []      // array to hold all the posible positions of
                                                        // board slots. CGRects to calculate if drop
                                                        // is within a board slot
    
    private var piecesUnlocked: [Bool] =                // set each time a new piece type arrives used
                    [true, true, false, false, false, false]    // to help generate new pieces
    
    private let pieceSpawnRate: [Int] =                 // how often to spawn each piece
                    [10, 10, 8, 6, 4, 1]
    
    // piece spawning percentages 
    private let singlePieceSpawnRate = 40               // percentage of time a single piece is spawned
    private let random = GKRandomDistribution.init(lowestValue: 0, highestValue: 100) // random number generator
    
    init(sceneDelegate: GameBoardSceneProtocol) {
        
        gameSceneDelegate = sceneDelegate
        
        super.init()
        
        self.createGameBoard()
    }
    
    // create the gameboard
    private func createGameBoard(){
        self.gameBoardSprite = SKSpriteNode(imageNamed: "Game_Board.png")
        self.gameBoardSprite.anchorPoint = .zero
        self.gameBoardSprite.position = .zero
        
        self.addChild(self.gameBoardSprite)
        
        var counter = 0
        
        // calculate the position of every available board slot
        for y in 1 ... 5 {
            for x in 1 ... 5 {
                var position = self.calculatePrecisePiecePosition(           // use coord method to create
                                        fromBoardCoordinates:               // position array
                                            CGPoint(x: x, y: y))
                
                position.x -= 35          //origin is
                position.y -= 35         // bottom left so minus 40 to calc
                
                
                
                let rect = CGRect(origin: position, size: self.slotDetectionSize)   // create the rect to use for
                                                                                    // detection
                
                self.boardSlotRects.append(rect)                            // add to array
                
                // create the empty game pieces to fill the board array as holders
                // if a game is already in progress load the pieces from the game state
                if !self.gameState.isGameInProgress {
                    let piece = OnBoardGamePiece()
                    piece.boardCoordinates = CGPoint(x: x, y: y)
                    self.gamePieces.append(piece)
                }
                else {
                    let piece = self.gameState.currentGameBoardPieces[counter]
                    piece.removeFromParent()
                    self.gamePieces.append(piece)
                    self.addChild(piece)
                }
                
                counter += 1
            }
        }
        
        // set the new board into the game state
        self.gameState.currentGameBoardPieces = self.gamePieces
        
    }
    
    // called to save the game board into game state
    func saveGameBoard(){
        self.gameState.currentGameBoardPieces = self.gamePieces
        
        let tex = self.scene?.view?.texture(from: self)
        let img = UIImage(cgImage: (tex?.cgImage())!)

    }
    
    // called to create a UIImage from the gameboard
    func createGameBoardUIImage() -> UIImage {
        
        // create a texture from self and the turn into ui image
        let texture = self.scene!.view!.texture(from: self)
        
        return UIImage(cgImage: (texture?.cgImage())!)
    }
    
    
    // calculate the board coordinates of the piece from grid position
    private func calculatePieceBoardCoordinates(fromGridPosition: Int) -> CGPoint{
        
        // calculate grid coordinates using division with remainders
        //  grid position / 5 = y coord
        //  grid position modulo 5 = x coord (the remainder)
        let yPos = Int(fromGridPosition / 5)
        let xPos = fromGridPosition % 5
        
        // coordinate space starts 1x1, make coords correct and create CGPoint
        let coord = CGPoint(x: xPos + 1,
                            y: yPos + 1)
        
        return coord
    }
    
    // calculate the grid array position from a coord
    private func calculatePieceGridPosition(fromCoordinates: CGPoint) -> Int {
        
        if fromCoordinates.x < 1 || fromCoordinates.x > 5 ||
            fromCoordinates.y < 1 || fromCoordinates.y > 5 {
            return -1
        }
        
        return Int(((fromCoordinates.y - 1) * 5) + (fromCoordinates.x - 1))
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
    
    // checks if a board slot is empty of filled
    private func isSlotEmpty(slotIndex: Int) -> Bool {
        if self.gamePieces[slotIndex].pieceType == .Empty {
            return true
        }
        else {
            return false
        }
    }
    
    // add a piece to the board in a free slot
    private func addPieceToBoard(piece: GamePiece, atSlot: Int){
        
        // create and position the new piece
        let pieceToAdd = OnBoardGamePiece(pieceType: piece.pieceType)
        pieceToAdd.boardGridPosition = atSlot
        
        // get the coords and then position of the slot to fill
        let coord = self.calculatePieceBoardCoordinates(fromGridPosition: atSlot)
        let position = self.calculatePrecisePiecePosition(fromBoardCoordinates: coord)
        
        // set position
        pieceToAdd.position = position
        // set piecetoadds coords
        pieceToAdd.boardCoordinates = coord
        
        // swap gamePiece array slot to this new piece and add the child to 
        // be displayed
        self.gamePieces[atSlot] = pieceToAdd
        self.addChild(pieceToAdd)

        // check for matching adjacent pieces
        let matchingPieces = self.checkForMatchingPieces(placedPiece: pieceToAdd)
        
        // reomve the pieces from the board if more than 2 match
        if matchingPieces.count > 2 {
            self.removeMatchingPieces(matches: matchingPieces)
        }

    }
    
    // checks whether any of the surrounding pieces match the one
    // that has just been placed
    // set the adjacent array in the new piece accordingly
    func checkForMatchingPieces(placedPiece: OnBoardGamePiece) -> [OnBoardGamePiece] {
        
        var matchingPieces: [OnBoardGamePiece] =
                            []        // any matching pieces,
                                                                 // used to check for tripples
                                                                // add placedpiece initally
        
        if placedPiece.boardCoordinates.x != 1 {        // check the piece to the left
            let gridPos = self.calculatePieceGridPosition(
                                        fromCoordinates: placedPiece.boardCoordinates.left())
            
            // check for match
            if self.gamePieces[gridPos].pieceType == placedPiece.pieceType {
                placedPiece.matchingAdjacentPiecePlaced(matchingPiece:
                                        self.gamePieces[gridPos], adjacentLocation: .Left)
                
                // inform matching piece of new piece adjacency
                self.gamePieces[gridPos].matchingAdjacentPiecePlaced(matchingPiece: placedPiece,
                                                                     adjacentLocation: .Right)
                
                matchingPieces.append(self.gamePieces[gridPos])
                // check matches for any adjacent matched and add to the array also
                matchingPieces.append(contentsOf:
                                        self.gamePieces[gridPos].checkForMatchingAdjacent())
            }
        }
        
        if placedPiece.boardCoordinates.y != 5 {        // check the piece above
            let gridPos = self.calculatePieceGridPosition(
                                        fromCoordinates: placedPiece.boardCoordinates.above())
            
            // check for match
            if self.gamePieces[gridPos].pieceType == placedPiece.pieceType {
                placedPiece.matchingAdjacentPiecePlaced(matchingPiece:
                                        self.gamePieces[gridPos], adjacentLocation: .Above)
                
                // inform matching piece of new piece adjacency
                self.gamePieces[gridPos].matchingAdjacentPiecePlaced(matchingPiece: placedPiece,
                                                                     adjacentLocation: .Below)
                
                matchingPieces.append(self.gamePieces[gridPos])
                // check matches for any adjacent matched and add to the array also
                matchingPieces.append(contentsOf:
                                        self.gamePieces[gridPos].checkForMatchingAdjacent())
            }
            
        }
        
        if placedPiece.boardCoordinates.x != 5 {        // check to piece to the right
            let gridPos = self.calculatePieceGridPosition(
                                        fromCoordinates: placedPiece.boardCoordinates.right())
            
            // check for match
            if self.gamePieces[gridPos].pieceType == placedPiece.pieceType {
                placedPiece.matchingAdjacentPiecePlaced(matchingPiece:
                                        self.gamePieces[gridPos], adjacentLocation: .Right)
                
                // inform matching piece of new piece adjacency
                self.gamePieces[gridPos].matchingAdjacentPiecePlaced(matchingPiece: placedPiece,
                                                                     adjacentLocation: .Left)
                
                matchingPieces.append(self.gamePieces[gridPos])
                // check matches for any adjacent matched and add to the array also
                matchingPieces.append(contentsOf:
                                        self.gamePieces[gridPos].checkForMatchingAdjacent())
            }
        }

        if placedPiece.boardCoordinates.y != 1 {        // check the piece below
            let gridPos = self.calculatePieceGridPosition(
                                        fromCoordinates: placedPiece.boardCoordinates.below())
            
            // check for match
            if self.gamePieces[gridPos].pieceType == placedPiece.pieceType {
                placedPiece.matchingAdjacentPiecePlaced(matchingPiece:
                                        self.gamePieces[gridPos], adjacentLocation: .Below)
                
                // inform matching piece of new piece adjacency
                self.gamePieces[gridPos].matchingAdjacentPiecePlaced(matchingPiece: placedPiece,
                                                                     adjacentLocation: .Above)
                
                matchingPieces.append(self.gamePieces[gridPos])
                // check matches for any adjacent matched and add to the array also
                matchingPieces.append(contentsOf:
                                        self.gamePieces[gridPos].checkForMatchingAdjacent())
            }
        }
        
        return matchingPieces
    }
    
    // removes any matching pieces from the game board, clears the sprite
    // and informs all intersted parties of the changes
    func removeMatchingPieces(matches: [OnBoardGamePiece]) {
        
        // array of coordinates to calculate the central position
        var coordinates: [CGPoint] = []
        
        // loop through the pieces
        for piece in matches {
            
            // add coord to array
            coordinates.append(piece.boardCoordinates)
            
            // remove the piece from the game board array
            let newPiece = OnBoardGamePiece()
            newPiece.boardCoordinates = piece.boardCoordinates
            self.gamePieces[piece.boardGridPosition] = newPiece
            
            // remove the sprite
            piece.removeFromParent()
        
        }
        
        // set the flag in the array for the next piece type
        self.piecesUnlocked[matches.first!.pieceType.rawValue] = true
        
        // calculate the central position to spawn next piece
        let spawnPoint = self.calculateCentralCoordinate(fromCoordinates: coordinates)
        
        // get the grid position from the coordinate
        let gridPoint = self.calculatePieceGridPosition(fromCoordinates: spawnPoint)
        
        // create the next piece up at the central coordinate
        let newPiece = OnBoardGamePiece(pieceType: PieceType(
                                    rawValue: matches.first!.pieceType.rawValue + 1)!)
        
        newPiece.boardCoordinates = spawnPoint
        
        self.addPieceToBoard(piece: newPiece, atSlot: gridPoint)
        
        
        // increase the score based on piece match type
        self.gameScore!.increaseForMatchedPieces(matchedPiece: matches.first!)
    }
    
    // calculate the central coordinate of a group of matched pieces
    func calculateCentralCoordinate(fromCoordinates: [CGPoint]) -> CGPoint {
        
        // loop through the array and create a mean average for x and y 
        // coordinates
        var xCoord: CGFloat = 0
        var yCoord: CGFloat = 0
        var counter = 0
        
        for coord in fromCoordinates {
            xCoord += coord.x
            yCoord += coord.y
            counter += 1
        }
        
        xCoord /= CGFloat(counter)
        yCoord /= CGFloat(counter)
        
        return CGPoint(x: Int(xCoord.rounded()),
                       y: Int(yCoord.rounded()))
    }
    
    // game board is responsible for calculating what piece type to
    // spawn next, work out and return
    func nextPieceToSpawn() -> PlayablePiece {
        
        // calculate how many of the pieces are avaialble
        var availablePieces: [PieceType] = []
        for i in 0 ..< self.piecesUnlocked.count {
            if self.piecesUnlocked[i] {
                for _ in 0 ..< self.pieceSpawnRate[i] {
                    availablePieces.append(PieceType(rawValue: i + 1)!)
                }
            }
        }
        
        let randNum = self.random.nextInt(upperBound: availablePieces.count)   // generate a random number to seed
        let secondRand = self.random.nextInt(upperBound: availablePieces.count) // generate a second number to used for
                                                                                // dual pieces
        
        if  randNum <= ((availablePieces.count / self.singlePieceSpawnRate) * 100) {       // generate a single piece
            
            self.gameSceneDelegate.nextGamePieceGenerated(isDual: false)
            return PlayablePiece(withPieceType: availablePieces[randNum])
        }
        else{                                           // generate a dual piece
            self.gameSceneDelegate.nextGamePieceGenerated(isDual: true)
            return PlayablePiece(leftPiece: availablePieces[randNum],
                                            rightPiece: availablePieces[secondRand])
        }
    }
    
    
    // checks whether there is enough space to drop a piece
    func isSpaceAvailable(isDualPiece: Bool) -> Bool {
        
        // if single loop through game pieces and look for an empty slot
        if !isDualPiece {
            for piece in self.gamePieces {
                if piece.pieceType == .Empty {
                    return true
                }
                else {
                    return false
                }
            }
        }
        // if dual piece loop through check for empty and adjacent empty
        else {
            for piece in self.gamePieces {
                if piece.pieceType == .Empty {
                    var posArray: [Int] = []
                    
                    // check the pieces around this one to find an empty slot
                    // calculate the grid pos and then add to array
                    let leftCoord = piece.boardCoordinates.left()
                    posArray.append(self.calculatePieceGridPosition(
                                                    fromCoordinates: leftCoord))
                    
                    let aboveCoord = piece.boardCoordinates.above()
                    posArray.append(self.calculatePieceGridPosition(
                        fromCoordinates: aboveCoord))
                    
                    let rightCoord = piece.boardCoordinates.right()
                    posArray.append(self.calculatePieceGridPosition(
                        fromCoordinates: rightCoord))
                    
                    let belowCoord = piece.boardCoordinates.below()
                    posArray.append(self.calculatePieceGridPosition(
                        fromCoordinates: belowCoord))
                    
                    
                    for i in posArray {
                        if i >= 0 && i < 25 {
                            
                            if self.gamePieces[i].pieceType == .Empty{
                                return true
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    // calculate the grid position from the point dropped on board
    // returns a bool based if piece falls within board slot
    func pieceDropped(piece: PlayablePiece) -> Bool{
        
        // create local space position from global position of piece
        var localPosition = CGPoint(x: piece.position.x - 57,
                                    y: piece.position.y - 385)
        
        // check if single or dual piece and calculate accordingly
        if piece.type == .Single {              // single
            
            //check if piece falls within any of the rects
            for i in 0 ..< self.boardSlotRects.count {
                if self.boardSlotRects[i].contains(localPosition) {
                    
                    // check if the slot is empty
                    if self.isSlotEmpty(slotIndex: i) {
                        
                        // yes add the piece to the board
                        self.addPieceToBoard(piece: piece.Piece1, atSlot: i)
                        
                        // added to board so return true
                        return true
                    }
                }
            }
        }
            
        else if piece.type == .Dual {           // dual
            
            var nextSlotIndex = 0           // index of the slot to check for the other piece
                                            // set depending on the direction of the piece
            
            var secondPiecePosition: CGPoint = .zero    // the location to check for the next piece
                                                        // in the playable piece pair
            
            // calculate the position of the first piece using offsets 
            // from the local position calculated above and the playable
            // piece direction
            switch piece.currentDirection {
            case .Left:
                localPosition.x -= 59
                nextSlotIndex = 1               // next piece is to the right, check that slot
                secondPiecePosition = CGPoint(x: localPosition.x + 118,     // position to check
                                              y: localPosition.y)
                break
            case .Up:
                localPosition.y += 59
                nextSlotIndex = -5              // next piece is directly below
                secondPiecePosition = CGPoint(x: localPosition.x,     // position to check
                    y: localPosition.y - 118)
                break
            case .Right:
                localPosition.x += 59
                nextSlotIndex = -1              // next piece is to the left
                secondPiecePosition = CGPoint(x: localPosition.x - 118,     // position to check
                    y: localPosition.y)
                break
            case .Down:
                localPosition.y -= 59
                nextSlotIndex = 5               // next piece is above
                secondPiecePosition = CGPoint(x: localPosition.x,     // position to check
                    y: localPosition.y + 118)
                break
            }
            
            
            //check if piece falls within any of the rects
            for i in 0 ..< self.boardSlotRects.count {
                if self.boardSlotRects[i].contains(localPosition) {
                    
                    // first piece matches check slot for the second piece
                    if self.boardSlotRects[i + nextSlotIndex].contains(secondPiecePosition){
                        
                        // both piece are in valid slots
                        // check if slots are occupied or not
                        if isSlotEmpty(slotIndex: i) &&
                                                isSlotEmpty(slotIndex: (i + nextSlotIndex)) {
                            
                            
                            if piece.currentDirection == .Left ||                   // piece 1 and 2 swap depending
                                            piece.currentDirection == .Right {       // on rotation, ensure added in correct
                                                                                    // order
                                // add the two pieces to the board
                                self.addPieceToBoard(piece: piece.Piece1, atSlot: i)
                                self.addPieceToBoard(piece: piece.Piece2, atSlot: (i + nextSlotIndex))
                            }
                            else if piece.currentDirection == .Up ||
                                            piece.currentDirection == .Down {
                                
                                // add the two pieces to the board
                                self.addPieceToBoard(piece: piece.Piece1, atSlot: i)
                                self.addPieceToBoard(piece: piece.Piece2, atSlot: (i + nextSlotIndex))
                            }
                         
                            // added to board so return true
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    // required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// protocol for dealing with game scene messages
protocol GameBoardSceneProtocol {
    
    // inform of next piece generated, is it single or dual
    func nextGamePieceGenerated(isDual: Bool)
    
}

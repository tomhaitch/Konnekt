//
//  GameBoardHelper.swift
//  Konnekt
//
//  Created by Tom on 28/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.


//  contains helper methods for placing and calculating pieces
//  on the game board

import Foundation
import SpriteKit

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

// calculate the board coordinates of the piece from grid position
func calculatePieceBoardCoordinates(fromGridPosition: Int) -> CGPoint{
    
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
func calculatePieceGridPosition(fromCoordinates: CGPoint) -> Int {
    
    if fromCoordinates.x < 1 || fromCoordinates.x > 5 ||
        fromCoordinates.y < 1 || fromCoordinates.y > 5 {
        return -1
    }
    
    return Int(((fromCoordinates.y - 1) * 5) + (fromCoordinates.x - 1))
}

// calculate the precise position for a piece using its board
// coordinates
func calculatePrecisePiecePosition(fromBoardCoordinates: CGPoint) -> CGPoint {
    
    // use leading spaces and gaps to calculate x pos
    // lots of casting to CGFloats to enable calculation
    let xPos = CGFloat(boardSlotHorizontalLeading) +
        (fromBoardCoordinates.x * CGFloat(boardSlotsHorizontalGap)) +
        CGFloat(slotSize.width / 2) +
        ((fromBoardCoordinates.x - 1) * CGFloat(slotSize.width))
    
    // use leading spaces and gaps to calculate y pos
    let yPos = CGFloat(boardSlotVerticalLeading) +
        (fromBoardCoordinates.y * CGFloat(boardSlotsVerticalGap)) +
        CGFloat(slotSize.height / 2) +
        ((fromBoardCoordinates.y - 1) * CGFloat(slotSize.height))
    
    return CGPoint(x: xPos, y: yPos)
    
}

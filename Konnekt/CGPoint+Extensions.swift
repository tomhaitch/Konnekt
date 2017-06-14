//
//  CGPointExtension.swift
//  Konnekt
//
//  Created by Tom on 13/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Extend CGPoint to allow minusing

import Foundation
import SpriteKit

public extension CGPoint {
    
    // Adds two CGPoint values and returns the result as a new CGPoint
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    // Subtracts two CGPoint values and returns the result as a new CGPoint
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}

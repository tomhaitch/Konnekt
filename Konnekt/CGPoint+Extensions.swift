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
    
    // check if two CGPoints are within a tolerance
    // e.g within 5px of X and Y
    public func isWithinTolerance(of: CGPoint, xTolerance: CGFloat, yTolerance: CGFloat) -> Bool{
        var minus = self - of
        if minus.x < 0 { minus.x *= -1 }        //remove negative to ensure conditional works
        if minus.y < 0 { minus.y *= -1 }
        
        //check if values are within tolerance
        if minus.x <= xTolerance && minus.y <= yTolerance {
            return true
        }
        else {
            return false
        }
    }
    
    
    // get cgpoint that is one to the left
    public func left() -> CGPoint {
        return CGPoint(x: self.x - 1, y: self.y)
    }
    
    // get cgpoint that is one above
    public func above() -> CGPoint {
        return CGPoint(x: self.x, y: self.y + 1)
    }
    
    // get cgpoint that is one to the right
    public func right() -> CGPoint {
        return CGPoint(x: self.x + 1, y: self.y)
    }
    
    // get cgpoint that is one below
    public func below() -> CGPoint {
        return CGPoint(x: self.x, y: self.y - 1)
    }
}

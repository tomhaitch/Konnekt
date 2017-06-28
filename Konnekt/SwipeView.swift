//
//  SwipeView.swift
//  Konnekt
//
//  Created by Tom on 10/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

// Swipe view class for Konnekt

import Foundation
import SpriteKit

class SwipeView: SKNode {
    
    private var views: [SKSpriteNode] = []
    private var size: CGSize!
    private var currentDisplayedView = 0
    
    private var isSliding: Bool = false
    private var originTouchPosition: CGPoint = .zero
    private var lastTouchPosition: CGPoint = .zero
    
    private var originPosition: CGPoint = .zero
    
     init(size: CGSize) {
        
        self.size = size
        super.init()
        
        self.isUserInteractionEnabled = true    //enable touch detection
    }
    
    // add view to the view controller
    func addView(contentNode: SKNode){
        let viewNode = SKSpriteNode.init(texture: nil, color: .clear, size: self.size)
        viewNode.anchorPoint = .zero
        
        //HACKY
        viewNode.position.x -= viewNode.size.width / 2.0
        viewNode.position.y -= viewNode.size.height / 2.0
        
        viewNode.position.x += CGFloat(views.count) * self.size.width
        
        viewNode.addChild(contentNode)
        
        self.addChild(viewNode)
        views.append(viewNode)
    }
    
    // touches began, store position, begin sliding
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        originTouchPosition = self.position
        
        // set the flag
        self.isSliding = true
        
        // store the position in origin and last touch positon
        self.originTouchPosition = touches.first!.location(in: self)
        self.lastTouchPosition = touches.first!.location(in: self)
        
    }
    
    // touches moved, if sliding move the view accordingly
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isSliding {
            let moveByX = lastTouchPosition.x - touches.first!.location(in: self).x
            
            self.position.x -= moveByX
        }
    }
    
    // touches ended, if sliding and over 50% of the way move the next view to 
    // center, if not lock back to original
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if originTouchPosition.x - touches.first!.location(in: self).x > self.size.width / 2.0 {
            self.position = self.originPosition
            self.position.x += 375.0
        }
    }
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

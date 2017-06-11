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
    
    
    //required by swift
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

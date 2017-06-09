//
//  GameViewController.swift
//  Konnekt
//
//  Created by Tom on 07/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let skView = SKView()
    let scene = MenuScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView.frame = view.frame
        view.addSubview(skView)
        
        // Set scene size to iphone 6/7 size
        scene.size = CGSize(width: 750, height: 1334)
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        // Present the scene
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = false
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

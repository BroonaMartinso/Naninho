//
//  BouncyBallViewController.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit
import SpriteKit

class BouncyBallViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "BouncyBall") {
                // Set the scale mode to scale to fit the window
                scene.size = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.8)
                scene.scaleMode = .aspectFit

                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

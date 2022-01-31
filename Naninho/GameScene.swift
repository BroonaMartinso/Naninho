//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    private var bola: SKSpriteNode!
    private var spike: Spike!
    
    override func didMove(to view: SKView) {
        bola = childNode(withName: "bola") as? SKSpriteNode
        spike = Spike (Model: childNode(withName: "spike")!, Parent: self, Raio: bola.frame.width/2)

    }
        
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spike.radial(quantidade: 7)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

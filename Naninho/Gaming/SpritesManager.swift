//
//  SpritesManager.swift
//  Naninho
//
//  Created by Marco Zulian on 10/02/22.
//

import Foundation
import SpriteKit

class SpritesManager {
    
    private var balls: [Bola] = []
    private var spikes: [Spike] = []
    private var parent: SKNode
    private var ballReference: SKSpriteNode
    
    init(parent: SKNode, ball: SKSpriteNode) {
        self.parent = parent
        self.ballReference = ball
    }
    
    func iniciarJogo(com qtdBolas: Int) {
        for bola in 0 ..< qtdBolas {
        
        }
    }
    
//    func generateNewBall() {
//        let newBallNode = ballReference as! SKSpriteNode
//        newBallNode.size = CGSize(width: screenWidth * 0.3, height: screenWidth * 0.3)
//        newBallNode.position = CGPoint(x: 0, y: 200)
//        newBallNode.texture = SKTexture(imageNamed: "feliz")
//        addChild(newBallNode)
//        let newBall = Bola(Ball: newBallNode, Parent: self)
//        newBall.delegate = self
//        let newSpike = Spike(Parent: self, Ball: newBallNode)
//        
//        newBall.pula(velocidade: 300)
//        newSpike.radial(quantidade: 5)
//    }
}

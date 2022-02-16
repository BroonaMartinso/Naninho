//
//  Naninho.swift
//  Naninho
//
//  Created by Marco Zulian on 16/02/22.
//

import Foundation
import SpriteKit

class Naninho {
    
    var representation: SKSpriteNode
    private var ball: Bola2
    private var spike: Spike2
    var isDone: Bool {
        spike.isDone
    }
    
    init(ball: Bola2, spike: Spike2) {
        self.representation = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
        self.ball = ball
        self.spike = spike
        
        representation.addChild(ball.bola)
    }
    
    func startGame(with n: Int, atPos pos: CGPoint, andSpeed speed: Double) {
        spike.radial(quantidade: n)
        
        representation.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        representation.physicsBody?.affectedByGravity = false
        representation.physicsBody?.contactTestBitMask = 0b0001
        representation.physicsBody?.categoryBitMask = 0b0001
        representation.physicsBody?.collisionBitMask = 0b0001
        representation.physicsBody?.linearDamping = 0
        representation.physicsBody?.angularDamping = 0
        representation.physicsBody?.friction = 0
        representation.physicsBody?.restitution = 1
        representation.position = pos
        
        pula(velocidade: speed)
    }
    
    private func pula(velocidade: Double){
        let velocidadex = Double.random (in: -1 ... 1)
        let velocidadey = sqrt(1-pow(velocidadex, 2))
        
        representation.physicsBody?.velocity.dx = velocidade * velocidadex
        representation.physicsBody?.velocity.dy = velocidade * velocidadey
//        for ch in representation.children {
//            ch.physicsBody?.velocity.dx = velocidade * velocidadex
//            ch.physicsBody?.velocity.dy = velocidade * velocidadey
//        }
    }
    
    func update(deltaTime: TimeInterval) {
        bate()
        ball.update(deltaTime: deltaTime)
        spike.update(deltaTime: deltaTime)
    }
    
    private func bate() {
        if representation.frame.minX <= BouncyBallScene.leftBound
        {representation.physicsBody?.velocity.dx = abs((representation.physicsBody?.velocity.dx)!)
            return
        }
        
        else if representation.frame.maxX >= BouncyBallScene.rightBound
        {representation.physicsBody?.velocity.dx = -abs((representation.physicsBody?.velocity.dx)!)
            return
        }
        
        else if representation.frame.minY <= BouncyBallScene.bottomBound
        {representation.physicsBody?.velocity.dy = abs((representation.physicsBody?.velocity.dy)!)
            return
        }
        
        else if representation.frame.maxY >= BouncyBallScene.topBound
        {representation.physicsBody?.velocity.dy = -abs((representation.physicsBody?.velocity.dy)!)
            return
        }
    }
    
    func handleTapPosition(atPos pos: CGPoint) {
        spike.jogo(click: pos)
    }
}

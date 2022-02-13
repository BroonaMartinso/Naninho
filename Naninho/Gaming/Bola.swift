//
//  Bola.swift
//  Naninho
//
//  Created by Bruna Oliveira on 01/02/22.
//

import Foundation
import SpriteKit

class Bola {
    var bola: SKSpriteNode
    var bolaParent: SKNode
    var delegate: BallDelegate?
    var velocityCache: CGVector?
    
    init(Ball: SKSpriteNode, Parent: SKNode){
        bola = Ball
        bolaParent = Parent
    }
    
    func startGame(completion: @escaping () -> Void = {}) {
        bola.physicsBody?.affectedByGravity = false
        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        bola.run(SKAction.moveTo(y: 0, duration: 1)) {
            self.bola.texture = SKTexture(image: UIImage(named: "expandir")!)
            self.bola.run(SKAction.sequence(
                [
                    SKAction.scale(by: 0.5, duration: 0.2),
                    SKAction.repeat(
                        SKAction.sequence([
                            SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06),
                            SKAction.rotate(byAngle: Double.pi/5, duration: 0.12),
                            SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06),
                        ]), count: 3),
                    SKAction.scale(by: 2, duration: 0.0)
                ])
            ) {
                self.bola.texture = SKTexture(image: UIImage(named: "Naninho")!)
                self.pula(velocidade: LevelHandler.shared.levelSpeed)
                completion()
                //TODO: Start game
            }
        }
    }
    
    func pula(velocidade: Double){
        let velocidadex = Double.random (in: -1 ... 1)
        let velocidadey = sqrt(1-pow(velocidadex, 2))
        
        bola.physicsBody?.velocity.dx = velocidade * velocidadex
        bola.physicsBody?.velocity.dy = velocidade * velocidadey
        
        velocityCache = bola.physicsBody?.velocity
    }
    
    func pause() {
        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func resume() {
        if let velocityCache = velocityCache {
            bola.physicsBody?.velocity = velocityCache
        } else {
            pula(velocidade: LevelHandler.shared.levelSpeed)
        }
    }
    
    private func bate (){
        if bola.frame.minX <= bolaParent.frame.minX 
        {bola.physicsBody?.velocity.dx = abs((bola.physicsBody?.velocity.dx)!)
            return
        }
        
        else if bola.frame.maxX >= bolaParent.frame.maxX
        {bola.physicsBody?.velocity.dx = -abs((bola.physicsBody?.velocity.dx)!)
            return
        }
        
        else if bola.frame.minY <= bolaParent.frame.minY
        {bola.physicsBody?.velocity.dy = abs((bola.physicsBody?.velocity.dy)!)
            return
        }
        
        else if bola.frame.maxY >= BouncyBallScene.topBound
        {bola.physicsBody?.velocity.dy = -abs((bola.physicsBody?.velocity.dy)!)
            return
        }
    }
    
    func reset() {
        bola.position = CGPoint(x: 0, y: 0)
        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func update(deltaTime: TimeInterval) {
        bate()
        if bola.physicsBody?.velocity != CGVector(dx: 0, dy: 0) {
            velocityCache = bola.physicsBody?.velocity
        }
    }
    
    func handleTapDuringGame(atPos pos: CGPoint) {
        if bola.contains(pos){
            delegate?.handleWrongTap()
            return
        }
    }
    
    func bravo(voltar : Bool = true){
        bola.texture = SKTexture (imageNamed: "Bravo")
        if voltar {
            bola.run(SKAction.wait(forDuration: 1), completion: {self.bola.texture = SKTexture (imageNamed: "feliz")})
        }
    }
    
    func handleTapDuringMenu(atPos pos: CGPoint) {
        if bola.contains(pos) {
            bola.texture = SKTexture(imageNamed: "Naninho")
            bola.run(SKAction.repeat(
                SKAction.sequence(
                    [SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06),
                     SKAction.rotate(byAngle: Double.pi/5, duration: 0.12),
                     SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06)]
                ), count: 4)) {
                    self.bola.texture = SKTexture(imageNamed: "feliz")
                }
        }
    }
}

protocol BallDelegate {
    func handleWrongTap()
}

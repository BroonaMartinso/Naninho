//
//  Bola.swift
//  Naninho
//
//  Created by Bruna Oliveira on 01/02/22.
//

import Foundation
import SpriteKit

class Bola2 {
    var bola: SKSpriteNode
    var velocityCache: CGVector?
    
    init(bola: SKSpriteNode){
        self.bola = bola
    }
    
    func startGame(completion: @escaping () -> Void = {}) {
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
    
    private func bate() {
//        if bola.frame.minX <= bolaParent.frame.minX
//        {bola.physicsBody?.velocity.dx = abs((bola.physicsBody?.velocity.dx)!)
//            return
//        }
//        
//        else if bola.frame.maxX >= bolaParent.frame.maxX
//        {bola.physicsBody?.velocity.dx = -abs((bola.physicsBody?.velocity.dx)!)
//            return
//        }
//        
//        else if bola.frame.minY <= bolaParent.frame.minY
//        {bola.physicsBody?.velocity.dy = abs((bola.physicsBody?.velocity.dy)!)
//            return
//        }
//        
//        else if bola.frame.maxY >= BouncyBallScene.topBound
//        {bola.physicsBody?.velocity.dy = -abs((bola.physicsBody?.velocity.dy)!)
//            return
//        }
    }
    
    func reset() {
        bola.position = CGPoint(x: 0, y: 0)
        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    func update(deltaTime: TimeInterval) {
//        bate()
        if bola.physicsBody?.velocity != CGVector(dx: 0, dy: 0) {
            velocityCache = bola.physicsBody?.velocity
        }
    }
    
    func handleTapDuringGame(atPos pos: CGPoint) {
        if bola.contains(pos){
            bravo()
//            delegate?.handleWrongTap()
//            return
        }
    }
    
    func bravo(voltar : Bool = true){
        bola.texture = SKTexture (imageNamed: "Bravo")
        if voltar {
            bola.run(SKAction.wait(forDuration: 1), completion: {self.bola.texture = SKTexture (imageNamed: "feliz")})
        }
    }
    
//    func handleTapDuringMenu(atPos pos: CGPoint) {
//        if bola.contains(pos) {
//            bolaParent.isUserInteractionEnabled = false
//            bola.texture = SKTexture(imageNamed: "Naninho")
//            bola.run(SKAction.repeat(
//                SKAction.sequence(
//                    [SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06),
//                     SKAction.rotate(byAngle: Double.pi/5, duration: 0.12),
//                     SKAction.rotate(byAngle: -Double.pi/10, duration: 0.06)]
//                ), count: 4)) {
//                    self.bola.texture = SKTexture(imageNamed: "feliz")
//                    self.bolaParent.isUserInteractionEnabled = true
//                }
//        }
//    }
}

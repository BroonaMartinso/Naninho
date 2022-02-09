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
    
    init( Ball: SKSpriteNode, Parent: SKNode){
        bola = Ball
        bolaParent = Parent
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
        
        else if bola.frame.maxY >= GameScene.topBound
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
    
    func jogo(click:CGPoint) {
        if bola.contains(click){
            delegate?.handleWrongTap()
            bravo()
            return
        }
    }
    func bravo(voltar : Bool = true){
        bola.texture = SKTexture (imageNamed: "Bravo")
        if voltar {
            bola.run(SKAction.wait(forDuration: 1), completion: {self.bola.texture = SKTexture (imageNamed: "feliz")})
        }
    }
}

protocol BallDelegate {
    func handleWrongTap()
}

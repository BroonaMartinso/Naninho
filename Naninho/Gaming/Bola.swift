//
//  Bola.swift
//  Naninho
//
//  Created by Bruna Oliveira on 01/02/22.
//

import Foundation
import SpriteKit

class Bola {
    var bola: SKNode
    var bolaParent: SKNode
    var delegate: BallDelegate?
    
    init( Ball: SKNode, Parent: SKNode){
        bola = Ball
        bolaParent = Parent
    }
    
    func pula(velocidade: Double){
        let velocidadex = Double.random (in: -1 ... 1)
        let velocidadey = sqrt(1-pow(velocidadex, 2))
        
        bola.physicsBody?.velocity.dx = velocidade * velocidadex
        bola.physicsBody?.velocity.dy = velocidade * velocidadey
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
        
        else if bola.frame.maxY >= bolaParent.frame.maxY
        {bola.physicsBody?.velocity.dy = -abs((bola.physicsBody?.velocity.dy)!)
            return
        }
    }
    
    func update(deltaTime: TimeInterval) {
        bate()
    }
    
    func jogo(click:CGPoint) {
        if bola.contains(click){
            delegate?.handleWrongTap()
            return
        }
    }
    
}

protocol BallDelegate {
    func handleWrongTap()
}

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
    
    init( Ball: SKNode, Parent: SKNode){
        bola = Ball
        bolaParent = Parent
    }
    
    func pula(){
        let velocidadex = Double.random (in: -200 ... 200)
        let velocidadey = Double.random (in: -200 ... 200)
        
        bola.physicsBody?.velocity.dx = velocidadex
        bola.physicsBody?.velocity.dy = velocidadey
    }
    
    func bate (){
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
                print("perdeu")
                return
            }
    }
}

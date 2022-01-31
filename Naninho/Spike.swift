//
//  spike.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//
import Foundation
import SpriteKit
class Spike {
    
    var spikeModel: SKNode
    var spikeParent: SKNode
    var radius: CGFloat
    var spikeArray : [SKNode] = []
    var rotation : TimeInterval = 0
    
    init (Model: SKNode, Parent: SKNode, Raio: CGFloat) {
        self.spikeModel = Model
        self.spikeParent = Parent
        self.radius = Raio
    }
    
//    func update(deltaTime: TimeInterval) {
//        rotation += deltaTime/10*360
//    }
    
    func radial (quantidade : Int){
        let passo = 360/quantidade
        
        for i in 1...quantidade {
            
            //Copia
            let new = spikeModel.copy() as! SKNode
            
            let angulo = CGFloat (passo*i)
            
            //Posiciona
            new.position.y = radius*(cos(angulo))
            new.position.x = radius*(sin(angulo))
            
//           ROTAÇÃO
            new.zRotation = -angulo
            
            spikeArray.append(new)
            //Adiciona
            spikeParent.addChild(new)
            
        }
    }
}


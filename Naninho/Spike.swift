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
    var spikeArray: [SKNode] = []
    var rotation: CGFloat = 0
    
    init (Model: SKNode, Parent: SKNode, Raio: CGFloat) {
        self.spikeModel = Model
        self.spikeParent = Parent
        self.radius = Raio
    }
    
    func update(deltaTime: TimeInterval) {
        rotation = CGFloat(deltaTime)/5*2*Double.pi
        
        for spike in spikeArray {
            spike.zRotation -= rotation
            spike.position.y = radius * cos(-spike.zRotation)
            spike.position.x = radius * sin(-spike.zRotation)
        }
    }
    
    func radial (quantidade : Int){
        let passo = 360/quantidade
        print(passo)
        
        for i in 0...quantidade {
            
            //Copia
            let new = spikeModel.copy() as! SKNode
            
            let angulo = CGFloat (passo*i)
            print(angulo)
            
            //Posiciona
            new.position.y = radius*(cos(angulo * Double.pi / 180))
            new.position.x = radius*(sin(angulo * Double.pi / 180))
            
//           ROTAÇÃO
            new.zRotation = -angulo * Double.pi / 180
            
            spikeArray.append(new)
            //Adiciona
            spikeParent.addChild(new)
        
        }
    }
}


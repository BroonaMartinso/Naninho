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
    var radius: CGFloat {bola.frame.width/2}
    var spikeArray: [SKNode] = []
    var rotation: CGFloat = 0
    var bola: SKNode
    var delegate: SpikeDelegate?
    
    init (Model: SKNode, Parent: SKNode, Ball: SKNode) {
        self.spikeModel = Model
        self.spikeParent = Parent
        self.bola = Ball
    }
    
    func update(deltaTime: TimeInterval) {
        rotation = CGFloat(deltaTime)/5*2*Double.pi
        
        for spike in spikeArray {
            spike.zRotation -= rotation
            spike.position.y = bola.frame.midY+radius * cos(-spike.zRotation)
            spike.position.x = bola.frame.midX+radius * sin(-spike.zRotation)
        }
        bate()
    }
    
    func radial(quantidade: Int){
        let passo = 360 / quantidade
        let passoRadianos = Double(passo) * Double.pi / 180
        print(passo)
        
        let ladoSpike = radius * sqrt(2 * (1 - cos(passoRadianos)))
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 0, y:-radius), radius: radius, startAngle: 0, endAngle: passoRadianos, clockwise: true)
        path.addLine(to:
                        CGPoint(
                            x: radius+ladoSpike*cos(Double.pi/6+passoRadianos/2),
                            y: -radius+ladoSpike*sin(Double.pi/6+passoRadianos/2)
                        )
        )
        path.addLine(to: CGPoint(x: radius, y: -radius))
        
        for i in 1...quantidade {
            
            //Copia
//            let new = spikeModel.copy() as! SKNode
            let new = SKShapeNode(path: path.cgPath)
            
            let angulo = CGFloat (passo*i)
            print(angulo)
            
            //Posiciona
            new.position.y = bola.frame.midY+radius*(cos(angulo * Double.pi / 180))
            new.position.x = bola.frame.midX+radius*(sin(angulo * Double.pi / 180))
            
            //Rotação
            new.zRotation = -angulo * Double.pi / 180
            
            spikeArray.append(new)
            //Adiciona
            spikeParent.addChild(new)
            
        }
    }
    
    private func bate() {
        for spike in spikeArray {
            if spike.frame.minX <= spikeParent.frame.minX {
                bola.physicsBody?.velocity.dx = abs((bola.physicsBody?.velocity.dx)!)
                return
            }
            
            else if spike.frame.maxX >= spikeParent.frame.maxX {
                bola.physicsBody?.velocity.dx = -abs((bola.physicsBody?.velocity.dx)!)
                return
            }
            
            else if spike.frame.minY <= spikeParent.frame.minY {
                bola.physicsBody?.velocity.dy = abs((bola.physicsBody?.velocity.dy)!)
                return
            }
            
            else if spike.frame.maxY >= spikeParent.frame.maxY {
                bola.physicsBody?.velocity.dy = -abs((bola.physicsBody?.velocity.dy)!)
                return
            }
        }
    }
    
    func jogo(click: CGPoint) {
        for spike in spikeArray {
            if spike.contains(click){
                spike.removeFromParent()
                spikeArray.remove(at: spikeArray.firstIndex(of: spike)!)
                
                if spikeArray.isEmpty {
                    if let delegate = delegate {
                        delegate.renderVictory()
                    }
                }
                
                return
                
            }
        }
    }
    
}

protocol SpikeDelegate {
    func renderVictory()
}

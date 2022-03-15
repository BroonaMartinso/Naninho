//
//  spike.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//
import Foundation
import SpriteKit
class Spike {
    
    var spikeParent: ScreenStateHandler
    var radius: CGFloat { bola.frame.width/2 }
    var spikeArray: [SKShapeNode] = []
    var rotation: CGFloat = 0
    var bola: SKNode
    var streakCount: Int = 0
    var lastCorrectTap: TimeInterval = 0
    var coins = 0
    var timeNeededForAFullCircle: Double?
    
    init (Parent: ScreenStateHandler, Ball: SKNode) {
        self.spikeParent = Parent
        self.bola = Ball
    }
    
    func update(deltaTime: TimeInterval) {
        // Se a bola não está se movimentando, o jogo está pausado e os spikes não devem rotacionar
        if bola.physicsBody?.velocity.dy == 0 {
            return
        }
        
        // TODO: Fix Rotation
        if let timeNeededForAFullCircle = timeNeededForAFullCircle {
            rotation = CGFloat(deltaTime)/timeNeededForAFullCircle*2*Double.pi
        }
        
        for spike in spikeArray {
            spike.zRotation -= rotation
            spike.position.y = bola.frame.midY+radius * cos(-spike.zRotation)
            spike.position.x = bola.frame.midX+radius * sin(-spike.zRotation)
        }
        bate()
        
        lastCorrectTap -= deltaTime
        if lastCorrectTap <= 0 {
            streakCount = 0
        }
    }
    
    func radial(quantidade: Int, timeForAFullCircle: Double){
        coins = 0
        timeNeededForAFullCircle = timeForAFullCircle
        removeAllspikes()
        let passo: Double = 360 / Double(quantidade)
        let passoRadianos = passo * Double.pi / 180
        print(passo)
        
        let ladoSpike = radius * sqrt(2 * (1 - cos(passoRadianos)))
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 0, y:-radius),
                    radius: radius,
                    startAngle: 0,
                    endAngle: passoRadianos,
                    clockwise: true)
        
        path.addLine(to:
                        CGPoint(
                            x: radius+ladoSpike*cos(Double.pi/6+passoRadianos/2),
                            y: -radius+ladoSpike*sin(Double.pi/6+passoRadianos/2)
                        ))
        
        path.addLine(to: CGPoint(x: radius, y: -radius))
        path.close()
        
        for i in 1...quantidade {
            
            //Copia
//            let new = spikeModel.copy() as! SKNode
            let new = SKShapeNode(path: path.cgPath)
            new.fillColor = UIColor(named: "verde")!
            new.strokeColor = UIColor(named: "verde")!
            new.physicsBody = SKPhysicsBody()
            new.physicsBody?.affectedByGravity = false
            new.physicsBody?.allowsRotation = false
            new.physicsBody?.linearDamping = 0
            new.physicsBody?.angularDamping = 0
            new.physicsBody?.friction = 0
            new.physicsBody?.restitution = 0
            
            let angulo = CGFloat(passo*Double(i))
            print(angulo)
            
            //Posiciona
            new.position.y = bola.frame.midY+radius*(cos(angulo * Double.pi / 180))
            new.position.x = bola.frame.midX+radius*(sin(angulo * Double.pi / 180))
            
            //Rotação
            new.zRotation = -angulo * Double.pi / 180
            
            
            //Adiciona
            spikeArray.append(new)
            spikeParent.addChild(new)
            
        }
    }
    
    func removeAllspikes() {
        for spike in spikeArray {
            spike.removeFromParent()
        }
        
        spikeArray = []
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
            
            else if spike.frame.maxY >= BouncyBallScene.topBound {
                bola.physicsBody?.velocity.dy = -abs((bola.physicsBody?.velocity.dy)!)
                return
            }
        }
    }
    
    func jogo(click: CGPoint) -> Bool {
        for spike in spikeArray {
            if spike.contains(click){
                spikeArray.remove(at: spikeArray.firstIndex(of: spike)!)
                queda(spike: spike)
                if spikeArray.isEmpty {
                    spikeParent.perform(transition: .gameToWin)
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    return true
                }
                
                streakCount += 1
                lastCorrectTap = TimeInterval(5 - streakCount)
                if streakCount == 1 {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                } else if streakCount == 2 {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                } else if streakCount >= 3 {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
                
                coins += streakCount
                return true
            }
        }
        
        return false
    }
    
    func madspike () {
        for spike in spikeArray {
            spike.fillColor = UIColor(named: "red")!
            spike.strokeColor = UIColor(named: "red")!
            spike.run(SKAction.wait(forDuration: 1), completion: {spike.fillColor = UIColor(named: "verde")!
                spike.strokeColor = UIColor(named: "verde")!})
        }
    }

    private func queda (spike : SKShapeNode) {
        
        spike.physicsBody?.affectedByGravity = true
        spike.run(SKAction.wait(forDuration: 3), completion: {
            spike.removeFromParent()
        })

    }
}

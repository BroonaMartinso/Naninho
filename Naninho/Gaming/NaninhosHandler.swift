//
//  NaninhosHandler.swift
//  Naninho
//
//  Created by Marco Zulian on 16/02/22.
//

import Foundation
import SpriteKit

class NaninhosHandler {
    
    var naninhoReference: SKSpriteNode
    var parent: SKNode
    var spikes: [Spike2] = []
    var naninhos: [Naninho] = []
    
    init(reference: SKSpriteNode, parent: SKNode) {
        self.naninhoReference = reference
        self.parent = parent
    }
    
    func startGame(with n: Int) {
        let speed = LevelHandler.shared.levelSpeed
//        let speed = 20.0
        
        for i in 0..<n {
            let naninho = createNaninho(atPos: CGPoint(x: 0, y: 0))
            parent.addChild(naninho.representation)
            naninho.startGame(with: 3, atPos: CGPoint(x: 0, y: -160 + 300 * i), andSpeed: speed)
            
            naninhos.append(naninho)
        }
    }
    
    private func createNaninho(atPos pos: CGPoint) -> Naninho {
        let copy = naninhoReference.copy() as! SKSpriteNode
//        copy.physicsBody?.affectedByGravity = false
        copy.physicsBody = nil
        copy.position = pos
        
        let ball = Bola2(bola: copy)
        let spike = Spike2(ball: copy)
        
        let naninho = Naninho(ball: ball, spike: spike)
        spike.parent = naninho.representation
        return naninho
    }
    
    func handleTapDuringGame(atPos pos: CGPoint) {
        for naninho in naninhos {
            naninho.handleTapPosition(atPos: pos)
        }
    }
    
    func update(deltaTime: TimeInterval) {
        for naninho in naninhos {
            naninho.update(deltaTime: deltaTime)
        }
    }
}

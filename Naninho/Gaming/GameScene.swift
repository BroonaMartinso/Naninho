//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, spikeDelegate {
    func rendervictory() {
        backgroundColor = .green
        childNode(withName: "vitoria")!.alpha = 1
        status = .final
    }
    
   
    private var bola: Bola!
    private var spike: Spike!
    private var lastUpdate: TimeInterval = 0
    var status:Status = .intro
    
    
    override func didMove(to view: SKView) {
        bola = Bola (Ball: childNode(withName: "bola")!, Parent: self)
        spike = Spike (Model: childNode(withName: "spike")!, Parent: self,Ball: bola.bola)
        spike.delegate = self
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            spike.radial(quantidade: 3)
            bola.pula()
            status = .play
        
        case .play:
            for t in touches {spike.jogo(click: t.location(in: self))}
            for t in touches {bola.jogo(click: t.location(in: self))}

        case .final:
            backgroundColor = .black
            status = .intro
            childNode(withName: "vitoria")!.alpha = 0
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        spike.update(deltaTime: deltaTime)
        bola.update(deltaTime: deltaTime)
    }
}
enum Status{
   case intro
    case play
    case final
}

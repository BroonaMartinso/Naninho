//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SpikeDelegate {
    private var bola: Bola!
    private var spike: Spike!
    private var lastUpdate: TimeInterval = 0
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    var status: Status = .intro
    
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        
        getScreenSize()
        setupBall()
        setupSpike()
    }
    
    func getScreenSize() {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        screenWidth = safeFrame.width
        screenHeight = safeFrame.height
    }
    
    func setupBall() {
        let ballNode = childNode(withName: "bola") as! SKSpriteNode
        ballNode.size = CGSize(width: screenWidth * 0.3, height: screenWidth * 0.3)
        bola = Bola (Ball: ballNode, Parent: self)
    }
    
    func setupSpike() {
        let spikeNode = childNode(withName: "spike") as! SKSpriteNode
        let spikeHeight = screenWidth * 0.2
        let spikeAspectRatio = spikeNode.frame.width / spikeNode.frame.height
        
        spikeNode.size = CGSize(width: spikeHeight * spikeAspectRatio, height: spikeHeight)
        spike = Spike (Model: spikeNode, Parent: self,Ball: bola.bola)
        spike.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .intro:
            spike.radial(quantidade: 8)
            bola.pula()
            status = .play
        
        case .play:
            for t in touches { bola.jogo(click: t.location(in: self)) }
            for t in touches { spike.jogo(click: t.location(in: self)) }

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
    
    func renderVictory() {
        backgroundColor = .green
        childNode(withName: "vitoria")!.alpha = 1
        status = .final
    }
}

enum Status{
    case intro
    case play
    case final
}
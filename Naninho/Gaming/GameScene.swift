//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SpikeDelegate, BallDelegate, TouchableSpriteNodeDelegate {
    private var menu: Menu!
    private var winMenu: WinMenu!
    private var loseMenu: LoseMenu!
    private var bola: Bola!
    private var spike: Spike!
    private var lastUpdate: TimeInterval = 0
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    private var levelTime: TimeInterval = 0
    var status: Status = .intro
    
    
    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        backgroundColor = UIColor(named: "bege")!
    
        getScreenSize()
        menu = Menu(screenWidth: screenWidth, screenHeight: screenHeight, parent: self)
        winMenu = WinMenu(screenWidth: screenWidth, screenHeight: screenHeight, parent: self)
        loseMenu = LoseMenu(screenWidth: screenWidth, screenHeight: screenHeight, parent: self)
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
        bola.delegate = self
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
            break
        case .transition:
            break
        case .play:
            for t in touches { bola.jogo(click: t.location(in: self)) }
            for t in touches { spike.jogo(click: t.location(in: self)) }
        case .final:
            break
        }
    }
    
    private func startGame() {
        spike.radial(quantidade: LevelHandler.shared.numberOfSpikes)
        bola.pula(velocidade: LevelHandler.shared.levelSpeed)
        bola.bola.removeAllActions()
        status = .play
        levelTime = 60
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        bola.update(deltaTime: deltaTime)
        spike.update(deltaTime: deltaTime)
        
        if status == .play {
            levelTime -= deltaTime
            menu.update(remainingTime: levelTime)
            if levelTime <= 0 {
                perform(transition: .gameToLose)
            }
        }
    }
    
    func renderVictory() {
        backgroundColor = UIColor(named: "verde")!
        childNode(withName: "vitoria")!.alpha = 1
        status = .final
    }
    
    func perform(transition: Transition) {
        switch transition {
        case .introToGame:
            status = .transition
            bola.bola.run(SKAction.repeatForever(SKAction.rotate(byAngle: -2*Double.pi, duration: 1)))
            menu.slide() {
                self.startGame()
            }
        case .endScreenToIntro:
            break
        case .gameToWin:
            backgroundColor = UIColor(named: "verde")!
            childNode(withName: "vitoria")!.alpha = 1
            status = .final
            winMenu.appear()
        case .gameToLose:
            backgroundColor = UIColor(named: "red")!
            childNode(withName: "derrota")!.alpha = 1
            status = .final
            loseMenu.appear()
        case .toNextLevel:
            LevelHandler.nextLevel()
            fallthrough
        case .repeatLevel:
            backgroundColor = UIColor(named: "bege")!
            childNode(withName: "vitoria")!.alpha = 0
            childNode(withName: "derrota")!.alpha = 0
            winMenu.disappear()
            loseMenu.disappear()
            startGame()
        }
    }
    
    func handleWrongTap() {
        levelTime -= 5
        if levelTime <= 0 {
            perform(transition: .gameToLose)
        }
    }
}

enum Status{
    case intro
    case transition
    case play
    case final
}

typealias ScreenStateHandler = SKScene & TouchableSpriteNodeDelegate

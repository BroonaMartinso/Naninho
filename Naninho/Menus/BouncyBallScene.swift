//
//  BouncyBallViewController.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit
import SpriteKit

class BouncyBallScene: SKScene, TouchableSpriteNodeDelegate, BallDelegate {
    private var ball: Bola!
    private var spike: Spike!
    private var pausePopup: Menu!
    private var topBar: Menu!
    private var timeBar: SKNode!
    private var bar: SKSpriteNode!
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    static var topBound: CGFloat!
    
    private var lastUpdate: TimeInterval = 0
    private var levelTime: TimeInterval = 0
    
    private var status: Status = .intro
    var del: BouncyBallSceneDelegate?
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill
        backgroundColor = UIColor(named: "bege")!

//        ball = childNode(withName: "ball") as? SKSpriteNode
        pausePopup = PausePopup(representation: childNode(withName: "Pause")!, respondableState: .pause)
        topBar = TopBar(representation: childNode(withName: "topBar")!, respondableState: .play)
        
        timeBar = childNode(withName: "timeBar")
        let barOutline = childNode(withName: "//timeBar/outline") as? SKShapeNode
        barOutline?.fillColor = UIColor(named: "black")!
        bar = childNode(withName: "//timeBar/bar") as? SKSpriteNode
        bar.color = UIColor(named: "black")!
        
        getScreenSize()
        setupBall()
        setupSpike()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .intro {
            for t in touches { ball.handleTapDuringMenu(atPos: t.location(in: self)) }
        } else if status == .play {
            for t in touches {
                if let transition = topBar.handleTap(atPos: t.location(in: topBar.representation)) {
                    perform(transition: transition)
                    return
                }
                if !spike.jogo(click: t.location(in: self)) {
                    ball.handleTapDuringGame(atPos: t.location(in: self))
                }
            }
        } else if status == .pause {
            for t in touches {
                if let transition = pausePopup.handleTap(atPos: t.location(in: pausePopup.representation)) {
                    perform(transition: transition)
                }
            }
        }
    }
    
    func getScreenSize() {
        screenWidth = scene?.frame.width
        screenHeight = scene?.frame.height
        BouncyBallScene.topBound = bar.frame.minY
    }
    
    func startGame() {
        status = .transition
        let shadow = childNode(withName: "shadow")!
        shadow.removeAllActions()
        shadow.alpha = 0
        
        let floor = childNode(withName: "floor")!
        floor.position.y = -screenHeight - 240
        
        ball.startGame {
            self.spike.radial(quantidade: LevelHandler.shared.numberOfSpikes)
            self.status = .play
            self.topBar.appear()
            self.timeBar.alpha = 1
            self.bar.alpha = 1
            self.levelTime = LevelHandler.shared.timeToCompleteCurrLevel
        }
    }
    
    func resetScene() {
        scene?.physicsWorld.gravity.dy = -2.5
        
        let floor = childNode(withName: "floor")!
        floor.position.y = -240
        
        spike.removeAllspikes()
        
        ball.bola.position = CGPoint(x: 0, y: 160)
        ball.bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.bola.texture = SKTexture(imageNamed: "bola")
        ball.bola.physicsBody?.affectedByGravity = true
        
        topBar.representation.alpha = 0
        timeBar.alpha = 0
        
        status = .intro
    }
    
    func prepareForNextGame() {
        ball.bola.position = CGPoint(x: 0, y: 0)
        spike.removeAllspikes()
    }

    func setupBall() {
        let ballNode = childNode(withName: "ball") as! SKSpriteNode
        ballNode.size = CGSize(width: screenWidth * 0.3, height: screenWidth * 0.3)
        ball = Bola (Ball: ballNode, Parent: self)
        ball.delegate = self
    }

    func setupSpike() {
        spike = Spike (Parent: self, Ball: ball.bola)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        spike.update(deltaTime: deltaTime)
        ball.update(deltaTime: deltaTime)
        
        if status == .play {
            levelTime -= deltaTime
            updateTimeBar()
            if levelTime <= 0 {
                perform(transition: .gameToLose)
            }
        }
    }
    
    func updateTimeBar() {
        bar.size.width = screenWidth * levelTime / LevelHandler.shared.timeToCompleteCurrLevel
        bar.position.x = (-screenWidth+bar.size.width) / 2
    }
    
    private func animateBarColor() {
        bar.color = UIColor(named: "red")!
        bar.tilt(byAngle: Double.pi/18)
        bar.run(SKAction.wait(forDuration: 0.2)) { self.bar.color = UIColor(named: "black")! }
    }
    
    func handleWrongTap() {
        levelTime -= 5
        animateBarColor()
        if levelTime <= 0 {
            perform(transition: .gameToLose)
        } else {
            spike.madspike()
            ball.bravo()
        }
    }
    
    func perform(transition: Transition) {
        if transition == .gameToPause {
            pausePopup.slideVertically(distance: screenHeight)
            ball.pause()
            status = .pause
        } else if transition == .pauseToReplay {
            spike.removeAllspikes()
            startGame()
            pausePopup.slideVertically(distance: -screenHeight)
        } else if transition == .pauseToContinue {
            ball.resume()
            status = .play
            pausePopup.slideVertically(distance: -screenHeight)
        } else if transition == .pauseToMainMenu {
            pausePopup.slideVertically(distance: -screenHeight)
            if let delegate = self.del {
                delegate.goToMenu()
            }
            self.status = .intro
        } else if transition == .gameToLose {
            status = .lose
            animateGameEnd(withResult: .lose)
        } else if transition == .gameToWin {
            status = .win
            LevelHandler.shared.nextLevel(timeRemaining: levelTime)
            animateGameEnd(withResult: .win)
        }
            
    }
    
    func animateGameEnd(withResult result: EndGameStatus) {
        isUserInteractionEnabled = false
        ball.bola.removeAllActions()
        ball.bola.texture = SKTexture(imageNamed: result == .win ? "bolaVerde" : "bolaVermelha")
        topBar.representation.isHidden = true
        timeBar.isHidden = true
        ball.bola.run(SKAction.scale(by: 30, duration: 0.4)) {
            if let delegate = self.del {
                if result == .win {
                    delegate.win()
                } else if result == .lose {
                    delegate.lose()
                }
            }
            self.ball.bola.run(SKAction.wait(forDuration: 0.5)) {
                self.ball.bola.run(SKAction.scale(by: 1/30, duration: 0))
                self.topBar.representation.isHidden = false
                self.timeBar.isHidden = false
                self.isUserInteractionEnabled = true
            }
        }
    }

}

enum Status{
    case intro
    case levelSelect
    case transition
    case play
    case pause
    case win
    case lose
}

protocol BouncyBallSceneDelegate {
    func win()
    func lose()
    func goToMenu()
}

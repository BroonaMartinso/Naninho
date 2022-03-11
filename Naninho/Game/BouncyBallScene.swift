//
//  BouncyBallViewController.swift
//  Naninho
//
//  Created by Marco Zulian on 11/02/22.
//

import Foundation
import UIKit
import SpriteKit
import FirebaseAnalytics

class BouncyBallScene: SKScene, TouchableSpriteNodeDelegate, BallDelegate, LevelPresenting {
    private var ball: Bola!
    private var spike: Spike!
    private var pausePopup: PausePopup!
    private var topBar: TopBar!
    private var timeBar: SKNode!
    private var bar: SKSpriteNode!
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    private var hasShownRewardAd: Bool = false
    private var configuration: LevelConfiguration!
    static var topBound: CGFloat!
    
    weak var gameViewController: GameViewController?
    var router: PopUpRouting?
    
    private var lastUpdate: TimeInterval = 0
    private var levelTime: TimeInterval = 0 {
        didSet {
            if levelTime <= 0 {
                handleTimeEnd()
            }
        }
    }
    
    private var status: Status = .intro
    weak var del: BouncyBallSceneDelegate?
    var shouldPauseWhenGoingToBg: Bool {
        status == .play
    }
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill
        backgroundColor = UIColor(named: "bege")!

//        ball = childNode(withName: "ball") as? SKSpriteNode
        pausePopup = PausePopup(representation: childNode(withName: "Pause")!, respondableState: .pause)
        pausePopup.delegate = self
        
        topBar = TopBar(representation: childNode(withName: "topBar")!, respondableState: .play)
        topBar.delegate = self
        
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
                topBar.handleTap(atPos: t.location(in: topBar.representation))
                if !spike.jogo(click: t.location(in: self)) {
                    ball.handleTapDuringGame(atPos: t.location(in: self))
                }
            }
        } else if status == .pause {
            for t in touches {
                pausePopup.handleTap(atPos: t.location(in: pausePopup.representation))
            }
        }
    }
    
    func getScreenSize() {
        screenWidth = scene?.frame.width
        screenHeight = scene?.frame.height
        BouncyBallScene.topBound = bar.frame.minY
    }
    
    func startLevel(with configuration: LevelConfiguration) {
        self.configuration = configuration
        hasShownRewardAd = false
        status = .transition
        let shadow = childNode(withName: "shadow")!
        shadow.removeAllActions()
        shadow.alpha = 0
        
        let floor = childNode(withName: "floor")!
        floor.position.y = -screenHeight - 240
        
        ball.startGame(withSpeed: configuration.speed) {
            self.spike.radial(quantidade: configuration.numberOfSpikes,
                              timeForAFullCircle: configuration.timeNeededForAFullCircle)
            self.status = .play
            self.topBar.appear()
            self.timeBar.alpha = 1
            self.bar.alpha = 1
            // TODO: Adicionar
            if configuration.speed == 0 {
                self.childNode(withName: "tutorialText")!.alpha = 1
            }
            self.levelTime = configuration.time
        }
        
        Analytics.logEvent("comecou", parameters: ["level": configuration.level as NSObject])
        AppDelegate.game = self
    }
    
    func showEndScreen(for result: LevelEndStatus) {
        let endVC = EndGameMenu(gameResult: result.status, level: result.level, stars: result.stars)
        gameViewController?.showEndVC(endVC)
    }
    
    func resetScene() {
        scene?.physicsWorld.gravity.dy = -2.5
        
        let floor = childNode(withName: "floor")!
        floor.position.y = -240
        
        childNode(withName: "tutorialText")!.alpha = 0
        
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
        ball.bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
        }
    }
    
    func updateTimeBar() {
        bar.size.width = screenWidth * levelTime / configuration.time
        bar.position.x = (-screenWidth+bar.size.width) / 2
    }
    
    private func animateBarColor() {
        bar.color = UIColor(named: "red")!
        bar.tilt(byAngle: Double.pi/18)
        bar.run(SKAction.wait(forDuration: 0.2)) { self.bar.color = UIColor(named: "black")! }
    }
    
    func handleWrongTap() {
        levelTime -= configuration.timePenalty
        animateBarColor()
        if levelTime >= 0 {
            spike.madspike()
            ball.bravo()
        }
    }
    
    func setTime(_ time: TimeInterval) {
        levelTime = time
        router?.hide()
        hasShownRewardAd = true
        pause()
    }
    
    func dontAddTime() {
        router?.hide()
        handleTimeEnd()
    }
    
    func perform(transition: Transition) {
        if transition == .gameToWin {
            status = .pause
//            LevelHandler.shared.nextLevel(timeRemaining: levelTime)
//            if let stars = LevelHandler.shared.completedLevels[LevelHandler.shared.currentLevel-1] {
//                Analytics.logEvent("ganhou", parameters:
//                                    ["level": configuration.level as NSObject,
//                                     "estrelas": stars as NSObject])
//            }
            animateGameEnd()
        }
            
    }
    
    func animateGameEnd() {
        isUserInteractionEnabled = false
        ball.bola.removeAllActions()
        ball.bola.texture = SKTexture(imageNamed: levelTime >= 0 ? "bolaVerde" : "bolaVermelha")
        topBar.representation.isHidden = true
        timeBar.isHidden = true
        childNode(withName: "tutorialText")!.alpha = 0
        ball.bola.run(SKAction.scale(by: 30, duration: 0.4)) {
            if let delegate = self.del {
                delegate.endGame(timeRemaining: self.levelTime)
            }
            self.ball.bola.run(SKAction.wait(forDuration: 0.5)) {
                self.ball.bola.run(SKAction.scale(by: 1/30, duration: 0))
                self.topBar.representation.isHidden = false
                self.timeBar.isHidden = false
                self.isUserInteractionEnabled = true
            }
        }
    }

    func handleTimeEnd() {
        if !hasShownRewardAd {
            router?.show()
            status = .showingAd
            hasShownRewardAd = true
        } else {
            Analytics.logEvent("perdeu", parameters: ["level": configuration.level as NSObject])
            animateGameEnd()
        }
    }
}

extension BouncyBallScene: PauseHandlerDelegate {
    func pause() {
        pausePopup.slideVertically(distance: screenHeight)
        ball.pause()
        status = .pause
    }
    
    func goToMenu() {
        pausePopup.slideVertically(distance: -screenHeight)
        if let delegate = self.del {
            delegate.goToMenu()
        }
        self.status = .intro
    }
    
    func resume() {
        ball.resume()
        status = .play
        pausePopup.slideVertically(distance: -screenHeight)
    }
    
    func replay() {
        spike.removeAllspikes()
        startLevel(with: self.configuration)
        pausePopup.slideVertically(distance: -screenHeight)
        Analytics.logEvent("restart", parameters: ["level": configuration.level as NSObject])
    }
}

enum Status {
    case intro
    case transition
    case play
    case pause
    case showingAd
}

protocol BouncyBallSceneDelegate: AnyObject {
    func goToMenu()
    func endGame(timeRemaining: Double)
}

protocol PauseHandlerDelegate {
    func pause()
    func goToMenu()
    func resume()
    func replay()
}

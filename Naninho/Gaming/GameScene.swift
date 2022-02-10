//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//
/*
 Eventos
 - Começou o nível -> level_start
 - Perdeu o nível -> level_end
 - Reiniciou o jogo -> level_restart
 - Pulou -> player_jump (posicao no eixo y quando pulou)
 Analytics.logEvent("player_jump", parameters: [
 "player_height": node.position.y as NSNumber
 ])
 
 Analytics.setUserProperty(value, forName: name)
 
 Propriedade
 - Tempo que "durou" na última vez que jogou
 */

import SpriteKit
import GameplayKit
import GameKit
//import FirebaseAnalytics

class GameScene: SKScene, BallDelegate, TouchableSpriteNodeDelegate, TopBarMenuDelegate, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)

    }
//    private var menu: Menu!
    private var menus: [Menu] = []
    private var mainMenu: Menu!
    private var winMenu: Menu!
    private var loseMenu: Menu!
    private var levelPopup: Menu!
    private var pausePopup: Menu!
    private var timeBar: SKNode!
    private var bar: SKSpriteNode!
    private var topBar: TopBar!
    private var bola: Bola!
    private var spike: Spike!
    private var lastUpdate: TimeInterval = 0
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    static var topBound: CGFloat!
    private var levelTime: TimeInterval = 0
    private var isSoundOn: Bool = true
    var status: Status = .intro
    
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFit
        backgroundColor = UIColor(named: "bege")!

        mainMenu = MainMenu(representation: childNode(withName: "mainMenu")!, respondableState: .intro)
        winMenu = WinMenu(representation: childNode(withName: "winMenu")!, respondableState: .win)
        loseMenu = LoseMenu(representation: childNode(withName: "loseMenu")!, respondableState: .lose)
        levelPopup = LevelPopup(representation: childNode(withName: "LEVEL")!, respondableState: .levelSelect)
        pausePopup = PausePopup(representation: childNode(withName: "Pause")!, respondableState: .pause)
        topBar = TopBar(representation: childNode(withName: "topBar")!, respondableState: .play)
        menus = [mainMenu, winMenu, loseMenu, levelPopup, pausePopup, topBar]
        
        timeBar = childNode(withName: "timeBar")
        let barOutline = childNode(withName: "//timeBar/outline") as? SKShapeNode
        barOutline?.fillColor = UIColor(named: "black")!
        bar = childNode(withName: "//timeBar/bar") as? SKSpriteNode
        bar.color = UIColor(named: "black")!
        
        
        getScreenSize()
        setupBall()
        setupSpike()
    }
    
    func getScreenSize() {
        screenWidth = scene?.frame.width
        screenHeight = scene?.frame.height
        GameScene.topBound = bar.frame.minY
    }
    
    func setupBall() {
        let ballNode = childNode(withName: "bola") as! SKSpriteNode
        ballNode.size = CGSize(width: screenWidth * 0.3, height: screenWidth * 0.3)
        bola = Bola (Ball: ballNode, Parent: self)
        bola.delegate = self
    }
    
    func setupSpike() {
        spike = Spike (Parent: self, Ball: bola.bola)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status != .pause {
            for t in touches {
                if let transition = topBar.handleTap(atPos: t.location(in: self)) {
                    perform(transition: transition)
                }
            }
        }
        
        if status == .play {
            for t in touches { bola.jogo(click: t.location(in: self)) }
            for t in touches { spike.jogo(click: t.location(in: self)) }
        }
        
        for menu in menus {
            if status == menu.respondableState {
                for t in touches {
                    if let transition = menu.handleTap(atPos: t.location(in: menu.representation)) {
                        perform(transition: transition)
                    }
                }
            }
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
        
        if status == .play {
            levelTime -= deltaTime
            updateTimeBar()
            if levelTime <= 0 {
                perform(transition: .gameToLose)
            }
        }
    }
    
    func perform(transition: Transition) {
        switch transition {
        case .introToGame:
            status = .transition
            timeBar.slideHorizontally(distance: -screenWidth)
            topBar.slideHorizontally(distance: -screenWidth)
            mainMenu.slideHorizontally(distance: -screenWidth) {
                self.startGame()
//                self.generateNewBall()
                self.status = .play
            }
        case .endScreenToIntro:
            timeBar.position.x = screenWidth
            topBar.setPosition(x: screenWidth)
            mainMenu.setPosition(x: 0)
            winMenu.disappear()
            loseMenu.disappear()
            bola.reset()
            status = .intro
        case .gameToWin:
            LevelHandler.nextLevel(timeRemaining: levelTime)
            status = .win
            winMenu.appear()
        case .gameToLose:
            status = .lose
            loseMenu.appear()
            bola.bravo(voltar: false)
        case .toLevelSelect:
            let controller = self.view?.window?.rootViewController as? GameViewController
            controller?.present(LevelMenu(), animated: false)
//            levelPopup.slideVertically(distance: screenHeight)
//            status = .levelSelect
        case .winToNextLevel:
            winMenu.disappear()
            startGame()
        case .repeatLevel:
            LevelHandler.setLevel(to: LevelHandler.shared.currentLevel - 1)
            winMenu.disappear()
            loseMenu.disappear()
            startGame()
        case .dismissLevelPopup:
            levelPopup.slideVertically(distance: -screenHeight)
            status = .intro
        case .pauseToMainMenu:
            spike.removeAllspikes()
            bola.reset()
            topBar.setPosition(x: screenWidth)
            timeBar.position.x = screenWidth
            mainMenu.setPosition(x: 0)
            status = .intro
            pausePopup.slideVertically(distance: -screenHeight)
        case .pauseToContinue:
            bola.resume()
            status = .play
            pausePopup.slideVertically(distance: -screenHeight)
        case .pauseToReplay:
            startGame()
            pausePopup.slideVertically(distance: -screenHeight)
        case .gameToPause:
            pausePopup.slideVertically(distance: screenHeight)
            bola.pause()
            status = .pause
        case .introRanking:
            let GameCenterVC = GKGameCenterViewController(leaderboardID: GameViewController.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
               GameCenterVC.gameCenterDelegate = self
            let controller = self.view?.window?.rootViewController as? GameViewController
            controller?.present (GameCenterVC, animated: true, completion: nil)
//            self.ViewController(GameCenterVC, animated: true, completion: nil)
        }
    }
    
    private func startGame() {
        spike.radial(quantidade: LevelHandler.shared.numberOfSpikes)
        bola.pula(velocidade: LevelHandler.shared.levelSpeed)
        status = .play
        levelTime = 60
        childNode(withName: "tap")?.alpha = LevelHandler.shared.currentLevel == 0 ? 1 : 0
    }
    
    internal func handleWrongTap() {
        levelTime -= 5
        animateBarColor()
        if levelTime <= 0 {
            perform(transition: .gameToLose)
            
        }
        spike.madspike()
    }
    
    private func animateBarColor() {
        bar.color = UIColor(named: "red")!
        bar.tilt(byAngle: Double.pi/18)
        bar.run(SKAction.wait(forDuration: 0.2)) { self.bar.color = UIColor(named: "black")! }
    }
    
    internal func soundButtonTapped() {
        isSoundOn.toggle()
        topBar.refreshSoundButtonAppearence(forStatus: status, isSoundOn: isSoundOn)
    }
    
    func updateTimeBar() {
        bar.size.width = screenWidth * levelTime / LevelHandler.shared.timeToCompleteCurrLevel
        bar.position.x = (-screenWidth+bar.size.width) / 2
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

typealias ScreenStateHandler = SKScene & TouchableSpriteNodeDelegate

extension SKNode {
    func slideVertically(distance: CGFloat) {
        self.run(SKAction.sequence(
            [SKAction.moveBy(x: 0, y: distance * 1.1, duration: 0.2),
             SKAction.moveBy(x: 0, y: -distance * 0.1, duration: 0.05)]))
    }
    
    func slideHorizontally(distance: CGFloat, completion: @escaping ()->Void = {}) {
        self.run(SKAction.moveBy(x: distance, y: 0, duration: 1)) {
            completion()
        }
    }
    
    func tilt(byAngle angle: Double, completion: @escaping ()->Void = {}) {
        self.run(SKAction.sequence([
            SKAction.rotate(byAngle: angle / 2, duration: 0.05),
            SKAction.rotate(byAngle: -angle, duration: 0.05),
            SKAction.rotate(byAngle: angle / 2, duration: 0.05)
        ]))
    }
}

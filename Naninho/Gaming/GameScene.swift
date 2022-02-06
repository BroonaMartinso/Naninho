//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, BallDelegate, TouchableSpriteNodeDelegate, LevelChangeListener {
    
//    private var menu: Menu!
    private var mainMenu: SKNode!
    private var winMenu: SKNode!
    private var loseMenu: SKNode!
    private var levelPopup: SKNode!
    private var pausePopup: SKNode!
    private var timeBar: SKNode!
    private var bar: SKSpriteNode!
    private var topBar: SKNode!
    private var soundButton: SKSpriteNode!
    private var soundButtonDarkImage: UIImage!
    private var soundButtonRedImage: UIImage!
    private var soundButtonOnClearImage: UIImage!
    private var soundButtonOffClearImage: UIImage!
    private var bola: Bola!
    private var spike: Spike!
    private var levelIndicatorLabelMainMenu: SKLabelNode!
    private var levelIndicatorLabelWinMenu: SKLabelNode!
    private var lastUpdate: TimeInterval = 0
    private var screenWidth: CGFloat!
    private var screenHeight: CGFloat!
    static var topBound: CGFloat!
    private var levelTime: TimeInterval = 0
    private var isSoundOn: Bool = true
    var status: Status = .intro
    
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill
        backgroundColor = UIColor(named: "bege")!

        mainMenu = childNode(withName: "mainMenu")
        levelIndicatorLabelMainMenu = childNode(withName: "//mainMenu//Botão Direita/level") as? SKLabelNode

        winMenu = childNode(withName: "winMenu")
        levelIndicatorLabelWinMenu = childNode(withName: "//winMenu//Botão Direita B/levelb") as? SKLabelNode
        let winBg = childNode(withName: "//winMenu/bg") as? SKSpriteNode
        winBg?.color = UIColor(named: "verde")!
        
        loseMenu = childNode(withName: "loseMenu")
        let loseBg = childNode(withName: "//loseMenu/bg") as? SKSpriteNode
        loseBg?.color = UIColor(named: "red")!
        
        levelPopup = childNode(withName: "LEVEL")
        pausePopup = childNode(withName: "Pause")
        
        timeBar = childNode(withName: "timeBar")
        let barOutline = childNode(withName: "//timeBar/outline") as? SKShapeNode
        barOutline?.fillColor = UIColor(named: "black")!
        bar = childNode(withName: "//timeBar/bar") as? SKSpriteNode
        bar.color = UIColor(named: "black")!
        
        topBar = childNode(withName: "topBar")
        soundButton = childNode(withName: "//topBar/som") as? SKSpriteNode
        soundButtonDarkImage = UIImage(systemName: "speaker.wave.2.circle.fill")!.withTintColor(UIColor(named: "black")!)
        soundButtonRedImage = UIImage(systemName: "speaker.slash.circle.fill")!.withTintColor(UIColor(named: "red")!)
        soundButtonOnClearImage = UIImage(systemName: "speaker.wave.2.circle.fill")!.withTintColor(UIColor(named: "bege")!)
        soundButtonOffClearImage = UIImage(systemName: "speaker.slash.circle.fill")!.withTintColor(UIColor(named: "bege")!)
        refreshSoundButtonAppearence()
        
        let pauseButton = childNode(withName: "//topBar/pause") as? SKSpriteNode
        let pauseImage = UIImage(systemName: "pause.circle.fill")!
        pauseImage.withTintColor(UIColor(named: "black")!)
        pauseButton?.texture = SKTexture(image: pauseImage)
        
        getScreenSize()
        updateLevelLabels(with: LevelHandler.shared.currentLevel)
        LevelHandler.shared.addListener(self)
        setupBall()
        setupSpike()
    }
    
    func getScreenSize() {
//        let window = UIApplication.shared.windows[0]
//        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
//        screenWidth = safeFrame.width
//        screenHeight = safeFrame.height
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
            for t in touches { handleTopBarTap(atPos: t.location(in: self)) }
        }
        
        switch status {
        case .intro:
            for t in touches { handleMainMenuTap(atPos: t.location(in: self)) }
        case .levelSelect:
            for t in touches { handleLevelPopupTap(atPos: t.location(in: levelPopup)) }
        case .transition:
            break
        case .pause:
            for t in touches { handlePausePopupTap(atPos: t.location(in: pausePopup)) }
        case .play:
            for t in touches { bola.jogo(click: t.location(in: self)) }
            for t in touches { spike.jogo(click: t.location(in: self)) }
        case .win:
            for t in touches { handleWinMenuTap(atPos: t.location(in: self)) }
        case .lose:
            for t in touches { handleLoseMenuTap(atPos: t.location(in: self)) }
        }
    }
    
    func handleTopBarTap(atPos pos: CGPoint) {
        if soundButton.contains(pos) {
            isSoundOn.toggle()
            refreshSoundButtonAppearence()
        }
        else if childNode(withName: "//topBar/pause")!.contains(pos) {
            pausePopup.slideVertically(distance: screenHeight)
            bola.pause()
            status = .pause
        }
    }
    
    func refreshSoundButtonAppearence() {
        if status == .lose || status == .win {
            soundButton.texture = SKTexture(image: isSoundOn ? soundButtonOnClearImage : soundButtonOffClearImage)
        } else {
            soundButton.texture = SKTexture(image: isSoundOn ? soundButtonDarkImage : soundButtonRedImage)
        }
    }
    
    func handleMainMenuTap(atPos pos: CGPoint) {
        if childNode(withName: "//mainMenu/Botão Esquerda")!.contains(pos) {
            levelPopup.slideVertically(distance: screenHeight)
            status = .levelSelect
        }
        else if childNode(withName: "//mainMenu/Botão Direita")!.contains(pos) {
            timeBar.slideHorizontally(distance: -screenWidth)
            topBar.slideHorizontally(distance: -screenWidth)
            mainMenu.slideHorizontally(distance: -screenWidth) { self.startGame() }
        }
    }
    
    func handleLevelPopupTap(atPos pos: CGPoint) {
        if childNode(withName: "//LEVEL/ok")!.contains(pos) {
            levelPopup.slideVertically(distance: -screenHeight)
            status = .intro
        } else if childNode(withName: "//LEVEL/fechar")!.contains(pos) {
            levelPopup.slideVertically(distance: -screenHeight)
            status = .intro
        }
    }
    
    func handlePausePopupTap(atPos pos: CGPoint) {
        if childNode(withName: "//Pause/Inicio")!.contains(pos) {
            spike.removeAllspikes()
            bola.reset()
            topBar.position.x = screenWidth
            timeBar.position.x = screenWidth
            mainMenu.position.x = 0
            status = .intro
            pausePopup.slideVertically(distance: -screenHeight)
        } else if childNode(withName: "//Pause/Continuar")!.contains(pos) {
            bola.resume()
            status = .play
            pausePopup.slideVertically(distance: -screenHeight)
        } else if childNode(withName: "//Pause/Reiniciar")!.contains(pos) {
            startGame()
            pausePopup.slideVertically(distance: -screenHeight)
        }
    }
    
    func handleWinMenuTap(atPos pos: CGPoint) {
        if childNode(withName: "//winMenu/Botão Direita B")!.contains(pos) {
            winMenu.alpha = 0
            startGame()
        }
        else if childNode(withName: "//winMenu/Botão Esquerda B")!.contains(pos) {
            LevelHandler.setLevel(to: LevelHandler.shared.currentLevel - 1)
            winMenu.alpha = 0
            startGame()
        }
        else if childNode(withName: "//winMenu/voltar")!.contains(pos) {
            timeBar.position.x = screenWidth
            topBar.position.x = screenWidth
            mainMenu.position.x = 0
            winMenu.alpha = 0
            bola.reset()
            status = .intro
        }
    }
    
    func handleLoseMenuTap(atPos pos: CGPoint) {
        if childNode(withName: "//loseMenu/Botão Esquerda B")!.contains(pos) {
            loseMenu.alpha = 0
            startGame()
        }
        else if childNode(withName: "//winMenu/voltar")!.contains(pos) {
            timeBar.position.x = screenWidth
            topBar.position.x = screenWidth
            mainMenu.position.x = 0
            winMenu.alpha = 0
            bola.reset()
            status = .intro
        }
    }
    
    private func startGame() {
        spike.radial(quantidade: LevelHandler.shared.numberOfSpikes)
        bola.pula(velocidade: LevelHandler.shared.levelSpeed)
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
        
        spike.update(deltaTime: deltaTime)
        bola.update(deltaTime: deltaTime)
        
        if status == .play {
            levelTime -= deltaTime
//            updateTimeBar()
            if levelTime <= 0 {
                perform(transition: .gameToLose)
            }
        }
    }
    
    func updateTimeBar() {
        bar.size.width = screenWidth * levelTime / LevelHandler.shared.timeToCompleteCurrLevel
        bar.position.x = (screenWidth + bar.size.width) / 2
    }
    
    func perform(transition: Transition) {
        switch transition {
        case .introToGame:
            status = .transition
            bola.bola.run(SKAction.repeatForever(SKAction.rotate(byAngle: -2*Double.pi, duration: 1)))
        case .endScreenToIntro:
            break
        case .gameToWin:
            LevelHandler.nextLevel()
            status = .win
            winMenu.alpha = 1
        case .gameToLose:
            status = .lose
            loseMenu.alpha = 1
        }
    }
    
    func handleWrongTap() {
        levelTime -= 5
        if levelTime <= 0 {
            perform(transition: .gameToLose)
        }
    }
    
    func handleLevelChange(to newLevel: Int) {
        updateLevelLabels(with: newLevel)
    }
    
    func updateLevelLabels(with newLevel: Int) {
        levelIndicatorLabelMainMenu.text = "LEVEL \(newLevel)"
        levelIndicatorLabelWinMenu.text = "LEVEL \(newLevel)"
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
}

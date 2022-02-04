//
//  Menu.swift
//  Naninho
//
//  Created by Marco Zulian on 03/02/22.
//

import Foundation
import SpriteKit

class Menu {
    
    private var screenWidth: CGFloat
    private var screenHeight: CGFloat
    private var parent: ScreenStateHandler
    private var menu: SKSpriteNode
    private var timeBar: SKSpriteNode = SKSpriteNode()
    
    init(screenWidth: CGFloat, screenHeight: CGFloat, parent: ScreenStateHandler) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.parent = parent
                
        menu = SKSpriteNode()
        menu.size = CGSize(width: screenWidth, height: screenHeight)

//        menu.color = .red
        parent.addChild(menu)
        
        setupButtons()
    }
    
    func setupButtons() {
        
        let play = TouchableSpriteNode(imageNamed: "play")
        play.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        play.position.x = screenWidth * 0.225
        play.position.y = -screenHeight * 0.25
        play.name = "play"
        play.delegate = parent
        play.transition = .introToGame
        play.isUserInteractionEnabled = true
        menu.addChild(play)
   
        let select = TouchableSpriteNode(imageNamed: "select")
        select.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        select.position.x = -screenWidth * 0.225
        select.position.y = -screenHeight * 0.25
        menu.addChild(select)
        
        let pause = TouchableSpriteNode()
        let pauseImage = UIImage(systemName: "pause.circle.fill")!
        pause.size = CGSize(width: 40, height: 40)
        pause.position.x = screenWidth * 1.4
        pause.position.y = screenHeight * 0.4
        pause.texture = SKTexture(image: pauseImage)
        menu.addChild(pause)
        
        let contourTimeBar = SKShapeNode(rectOf: CGSize(width: screenWidth, height: screenHeight * 0.01))
        contourTimeBar.strokeColor = UIColor(named: "black")!
        contourTimeBar.fillColor = .clear
        contourTimeBar.position = CGPoint(x: screenWidth, y: screenHeight * 0.495)
        menu.addChild(contourTimeBar)
        
        timeBar.size = CGSize(width: screenWidth, height: screenHeight * 0.01)
        timeBar.color = UIColor(named: "black")!
//        timeBar.strokeColor = .clear
//        timeBar.fillColor = UIColor(named: "black")!
        timeBar.position = CGPoint(x: screenWidth, y: screenHeight * 0.495)
        menu.addChild(timeBar)
        
        menu.zPosition = 1
    }
    
    func slide(_ completion: @escaping ()->Void) {
        let leaveAction = SKAction.move(by: CGVector(dx: -screenWidth, dy: 0), duration: 1)
        menu.run(leaveAction) {
            completion()
        }
    }
    
    func update(remainingTime: TimeInterval) {
        let width = screenWidth * remainingTime / LevelHandler.shared.timeToCompleteCurrLevel
        timeBar.size = CGSize(width: width, height: screenHeight * 0.01)
        timeBar.position = CGPoint(x: (screenWidth + width)/2, y: screenHeight * 0.495)
    }
    
}


enum Transition {
    case introToGame
    case endScreenToIntro
    case toNextLevel
    case gameToWin
    case repeatLevel
    case gameToLose
}

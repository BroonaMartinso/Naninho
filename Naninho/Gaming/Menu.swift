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
        
        let timeBar = SKShapeNode(rectOf: CGSize(width: screenWidth, height: screenHeight * 0.01))
        timeBar.strokeColor = .clear
        timeBar.fillColor = UIColor(named: "black")!
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
}


enum Transition {
    case introToGame
    case endScreenToIntro
    case toNextLevel
    case gameToWin
    case repeatLevel
}

//class Button {
//    var representation: SKSpriteNode
//    var transition: Transition
//
//    init(representation: SKSpriteNode, transition: Transition) {
//        self.representation = representation
//        self.transition = transition
//    }
//
//    func checkTap(atPos pos: CGPoint) -> Transition? {
//        return representation.contains(pos) ? transition : nil
//    }
//}

//protocol MenuProtocol {
//    var buttons: [Button] { get }
//    func handleTap(atPos pos: CGPoint) -> Transition?
//}
//
//extension MenuProtocol {
//    func handleTap(atPos pos: CGPoint) -> Transition? {
//        for button in buttons {
//            if let transition = button.checkTap(atPos: pos) {
//                return transition
//            }
//        }
//
//        return nil
//    }
//}

class TouchableSpriteNode : SKSpriteNode
{
    
    var transition: Transition?
    var delegate: ScreenStateHandler?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = delegate, let transition = transition {
            delegate.perform(transition: transition)
        }
    }
}

protocol TouchableSpriteNodeDelegate {
    func perform(transition: Transition)
}

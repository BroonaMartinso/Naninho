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
        menu.size = CGSize(width: screenWidth, height: 0.4 * screenHeight)
        menu.position.y = -screenHeight*0.3

//        menu.color = .red
        parent.addChild(menu)
        
        setupButtons()
    }
    
    func setupButtons() {
        
//        let playButton = SKShapeNode(rect: CGRect(x: 0, y: 0, width: screenWidth * 0.4, height: screenWidth * 0.4), cornerRadius: 20)
//        playButton.strokeColor = UIColor(named: "black")!
        
//        let play = SKSpriteNode()
        let play = TouchableSpriteNode(imageNamed: "play")
//        play.texture = SKTexture(imageNamed: "play")
        play.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        play.position.x = screenWidth * 0.225
        play.position.y = screenWidth * 0.15
        play.name = "play"
        play.delegate = parent
        play.transition = .introToGame
        play.isUserInteractionEnabled = true
        menu.addChild(play)
   
        let select = TouchableSpriteNode(imageNamed: "select")
//        select.texture = SKTexture(imageNamed: "select")
        select.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        select.position.x = -screenWidth * 0.225
        select.position.y = screenWidth * 0.15
        menu.addChild(select)
        
//        playButton.size = CGSize(width: screenWidth * 0.4, height: screenHeight * 0.4)
        
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

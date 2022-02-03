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
    private var parent: SKNode
    private var menu: SKSpriteNode
    
    init(screenWidth: CGFloat, screenHeight: CGFloat, parent: SKNode) {
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.parent = parent
        
        menu = SKSpriteNode()
        menu.size = CGSize(width: screenWidth, height: 0.4 * screenHeight)
        menu.position.y = -screenHeight*0.3

        menu.color = .red
        parent.addChild(menu)
        
        setupButtons()
    }
    
    func setupButtons() {
        
//        let playButton = SKShapeNode(rect: CGRect(x: 0, y: 0, width: screenWidth * 0.4, height: screenWidth * 0.4), cornerRadius: 20)
//        playButton.strokeColor = UIColor(named: "black")!
        
        let play = SKSpriteNode()
        play.texture = SKTexture(imageNamed: "play")
        play.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        play.position.x = screenWidth * 0.225
        play.position.y = screenWidth * 0.15
        menu.addChild(play)
        
        let select = SKSpriteNode()
        select.texture = SKTexture(imageNamed: "select")
        select.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        select.position.x = -screenWidth * 0.225
        select.position.y = screenWidth * 0.15
        menu.addChild(select)
        
//        playButton.size = CGSize(width: screenWidth * 0.4, height: screenHeight * 0.4)
        
    }
    
    func transition(_ completion: @escaping ()->Void) {
        let leaveAction = SKAction.move(by: CGVector(dx: -screenWidth, dy: 0), duration: 1)
        menu.run(leaveAction) {
            completion()
        }
    }
    
}



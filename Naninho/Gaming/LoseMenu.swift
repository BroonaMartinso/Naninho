//
//  WinMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 03/02/22.
//

import Foundation
import SpriteKit

class LoseMenu {
    
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


//        menu.color = UIColor(named: "verde")!
        parent.addChild(menu)
        menu.alpha = 0
        setupButtons()
    }
    
    func setupButtons() {
   
        let select = TouchableSpriteNode(imageNamed: "jogarNovamente")
//        select.texture = SKTexture(imageNamed: "select")
        select.size = CGSize(width: screenWidth * 0.4, height: screenWidth * 0.4)
        select.position.x = 0
        select.position.y = -screenHeight * 0.25
        select.delegate = parent
        select.transition = .repeatLevel
        select.isUserInteractionEnabled = true
        menu.addChild(select)
        
        menu.zPosition = 1
    }
    
    func appear() {
        menu.alpha = 1
    }
    
    func disappear() {
        menu.alpha = 0
    }
    
}

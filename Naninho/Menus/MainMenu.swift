//
//  MainMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class MainMenu: Menu, LevelChangeListener {
    var representation: SKNode
    var respondableState: Status
    private var levelIndicatorLabel: SKLabelNode
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
        levelIndicatorLabel = representation.childNode(withName: "//mainMenu//Botão Direita/level") as! SKLabelNode
        levelIndicatorLabel.text = "LEVEL \(LevelHandler.shared.currentLevel)"
        
        LevelHandler.shared.addListener(self)
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "Botão Esquerda")!.contains(pos) {
            return .toLevelSelect
        }
        else if representation.childNode(withName: "Botão Direita")!.contains(pos) {
            return .introToGame

        }
        
        else if representation.childNode(withName: "ranking")!.contains(pos)
        { return .introRanking
            
        }
        return nil
    }
    
    func handleLevelChange(to newLevel: Int) {
        levelIndicatorLabel.text = "LEVEL \(newLevel)"
    }
}

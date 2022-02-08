//
//  WinMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class WinMenu: Menu, LevelChangeListener {
    var representation: SKNode
    private var levelIndicatorLabel: SKLabelNode
    
    init(representation: SKNode) {
        self.representation = representation
        levelIndicatorLabel = representation.childNode(withName: "//Botão Direita B/levelb") as! SKLabelNode
        levelIndicatorLabel.text = "LEVEL \(LevelHandler.shared.currentLevel)"
        
        let winBg = representation.childNode(withName: "bg") as? SKSpriteNode
        winBg?.color = UIColor(named: "verde")!
        
        LevelHandler.shared.addListener(self)
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "Botão Direita B")!.contains(pos) {
            return .winToNextLevel
        }
        else if representation.childNode(withName: "//winMenu/Botão Esquerda B")!.contains(pos) {
            return .repeatLevel
        }
        else if representation.childNode(withName: "//winMenu/voltar")!.contains(pos) {
            return .endScreenToIntro
        }
        
        return nil
    }
    
    func handleLevelChange(to newLevel: Int) {
        levelIndicatorLabel.text = "LEVEL \(newLevel)"
    }
    
}

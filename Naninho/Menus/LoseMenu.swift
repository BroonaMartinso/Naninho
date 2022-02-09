//
//  LoseMenu.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class LoseMenu: Menu {
    var representation: SKNode
    var respondableState: Status
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
        
        let loseBg = representation.childNode(withName: "bg") as? SKSpriteNode
        loseBg?.color = UIColor(named: "red")!
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "Botão Esquerda B")!.contains(pos) {
            return .repeatLevel
        }
        else if representation.childNode(withName: "voltar")!.contains(pos) {
            return .endScreenToIntro
        }
        
        return nil
    }
}

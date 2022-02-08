//
//  PausePopup.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class PausePopup: Menu {
    var representation: SKNode
    
    init(representation: SKNode) {
        self.representation = representation
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "Inicio")!.contains(pos) {
            return .pauseToMainMenu
        } else if representation.childNode(withName: "Continuar")!.contains(pos) {
            return .pauseToContinue
        } else if representation.childNode(withName: "Reiniciar")!.contains(pos) {
            return .pauseToReplay
        }
        
        return nil
    }
    
    
}

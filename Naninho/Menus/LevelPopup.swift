//
//  LevelPopup.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class LevelPopup: Menu {
    var representation: SKNode
    
    init(representation: SKNode) {
        self.representation = representation
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "ok")!.contains(pos) {
            return .dismissLevelPopup
        } else if representation.childNode(withName: "fechar")!.contains(pos) {
            return .dismissLevelPopup
        }
        
        return nil
    }
    
    
}

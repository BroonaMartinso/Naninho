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
    var respondableState: Status
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
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

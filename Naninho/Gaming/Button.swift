//
//  Button.swift
//  Naninho
//
//  Created by Marco Zulian on 03/02/22.
//

import Foundation
import SpriteKit

class Button {
    var representation: SKSpriteNode
    var transition: Transition
    
    init(representation: SKSpriteNode, transition: Transition) {
        self.representation = representation
        self.transition = transition
    }
    
    func checkTap(atPos pos: CGPoint) -> Transition? {
        return representation.contains(pos) ? transition : nil
    }
}

//
//  MenuProtocol.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

protocol Menu {
    var representation: SKNode { get }
    func handleTap(atPos pos: CGPoint) -> Transition?
}

extension Menu {
    func slideVertically(distance: CGFloat) {
        self.representation.slideVertically(distance: distance)
    }
    
    func slideHorizontally(distance: CGFloat, completion: @escaping ()->Void = {}) {
        self.representation.slideHorizontally(distance: distance) {
            completion()
        }

    }
    
    func setPosition(x pos: CGFloat) {
        self.representation.position.x = pos
    }
    
    func appear() {
        self.representation.alpha = 1
    }
    
    func disappear() {
        self.representation.alpha = 0
    }
}

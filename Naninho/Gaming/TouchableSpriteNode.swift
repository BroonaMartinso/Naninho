//
//  TouchableSpriteNode.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation
import SpriteKit

class TouchableSpriteNode : SKSpriteNode
{
    var transition: Transition?
    var delegate: ScreenStateHandler?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let delegate = delegate, let transition = transition {
            delegate.perform(transition: transition)
        }
    }
}

protocol TouchableSpriteNodeDelegate {
    func perform(transition: Transition)
}

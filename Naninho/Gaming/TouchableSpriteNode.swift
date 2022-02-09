//
//  TouchableSpriteNode.swift
//  Naninho
//
//  Created by Marco Zulian on 04/02/22.
//

import Foundation
import SpriteKit

protocol TouchableSpriteNodeDelegate {
    func perform(transition: Transition)
}

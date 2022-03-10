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
    var respondableState: Status
    var delegate: PauseHandlerDelegate?
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
    }
    
    func handleTap(atPos pos: CGPoint) {
        if representation.childNode(withName: "Inicio")!.contains(pos) {
            if let delegate = delegate {
                delegate.goToMenu()
            }
        } else if representation.childNode(withName: "Continuar")!.contains(pos) {
            if let delegate = delegate {
                delegate.resume()
            }
        } else if representation.childNode(withName: "Reiniciar")!.contains(pos) {
            if let delegate = delegate {
                delegate.replay()
            }
        }
    }
}

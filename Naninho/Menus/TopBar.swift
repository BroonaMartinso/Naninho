//
//  TopBar.swift
//  Naninho
//
//  Created by Marco Zulian on 08/02/22.
//

import Foundation
import SpriteKit

class TopBar: Menu {
    var representation: SKNode
    var respondableState: Status
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
        
        let pauseButton = representation.childNode(withName: "pause") as? SKSpriteNode
        let pauseImage = UIImage(systemName: "pause.circle.fill")!
        pauseImage.withTintColor(UIColor(named: "black")!)
        pauseButton?.texture = SKTexture(image: pauseImage)
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if representation.childNode(withName: "pause")!.contains(pos) {
            return .gameToPause
        }
        
        return nil
    }
}

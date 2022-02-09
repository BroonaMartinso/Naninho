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
    private var soundButton: SKSpriteNode!
    private var soundButtonDarkImage: UIImage!
    private var soundButtonRedImage: UIImage!
    private var soundButtonOnClearImage: UIImage!
    private var soundButtonOffClearImage: UIImage!
    weak var delegate: TopBarMenuDelegate?
    
    init(representation: SKNode, respondableState: Status) {
        self.representation = representation
        self.respondableState = respondableState
        
        soundButton = representation.childNode(withName: "som") as? SKSpriteNode
        soundButtonDarkImage = UIImage(systemName: "speaker.wave.2.circle.fill")!.withTintColor(UIColor(named: "black")!)
        soundButtonRedImage = UIImage(systemName: "speaker.slash.circle.fill")!.withTintColor(UIColor(named: "red")!)
        soundButtonOnClearImage = UIImage(systemName: "speaker.wave.2.circle.fill")!.withTintColor(UIColor(named: "bege")!)
        soundButtonOffClearImage = UIImage(systemName: "speaker.slash.circle.fill")!.withTintColor(UIColor(named: "bege")!)
        
        let pauseButton = representation.childNode(withName: "pause") as? SKSpriteNode
        let pauseImage = UIImage(systemName: "pause.circle.fill")!
        pauseImage.withTintColor(UIColor(named: "black")!)
        pauseButton?.texture = SKTexture(image: pauseImage)
    }
    
    func handleTap(atPos pos: CGPoint) -> Transition? {
        if soundButton.contains(pos) {
            delegate?.soundButtonTapped()
        }
        else if representation.childNode(withName: "pause")!.contains(pos) {
            return .gameToPause
        }
        
        return nil
    }
    
    func refreshSoundButtonAppearence(forStatus status: Status, isSoundOn: Bool) {
        if status == .lose || status == .win {
            soundButton.texture = SKTexture(image: isSoundOn ? soundButtonOnClearImage : soundButtonOffClearImage)
        } else {
            soundButton.texture = SKTexture(image: isSoundOn ? soundButtonDarkImage : soundButtonRedImage)
        }
    }

    
}

protocol TopBarMenuDelegate: AnyObject {
    func soundButtonTapped()
}

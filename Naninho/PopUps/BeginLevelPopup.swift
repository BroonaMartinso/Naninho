import Foundation
import UIKit

class BeginLevelPopup: PopUpView, LevelChangeListener, PopUp {
    
    private var starsImage = UIImageView()
    weak var delegate: BeginLevelPopupDelegate?
    
    private var level: Int = 0 {
        didSet {
            configureLevelLabel()
        }
    }
    
    private var stars: Int = 0 {
        didSet {
            configureStars()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "verde")
        
        layer.cornerRadius = 25
        
        configureAcceptButton(with: "let's gooo!")
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
//        LevelHandler.shared.addListener(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func declineButtonTapped() {
        if let delegate = delegate {
            delegate.handleDenial()
        }
    }
    
    @objc
    func acceptButtonTapped() {
        if let delegate = delegate {
            delegate.handleAcceptance()
        }
    }
    
    func configureLevelLabel() {
        if level == 0 {
            configureTitle(with: "TUTORIAL")
        } else {
            configureTitle(with: "LEVEL \(level)")
        }
    }
    
    func configureStars() {
        starsImage.image = UIImage(named: "\(stars)star")
        configureSubtitle(with: starsImage)
    }
    
    func handleLevelChange(to newLevel: Int, stars: Int) {
        level = newLevel
        self.stars = stars
    }
}

protocol BeginLevelPopupDelegate: AnyObject {
    func handleAcceptance()
    func handleDenial()
}

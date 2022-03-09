//
//  GetMoreTimePopup.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import UIKit
import AVFAudio

class GetMoreTimePopup: PopUpView, PopUp {
    
    weak var delegate: GetMoreTimePopupDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "verde")
        
        layer.cornerRadius = 25
        
        configureTitle(with: "Watch a short video to receive more 30s", fontSize: 18)
        configureAcceptButton(with: "let's gooo!")
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func declineButtonTapped() {
        if let delegate = delegate {
            delegate.dontPlayVideo()
        }
    }
    
    @objc
    func acceptButtonTapped() {
        if let delegate = delegate {
            delegate.playVideo()
        }
    }
}

protocol GetMoreTimePopupDelegate: AnyObject {
    func playVideo()
    func dontPlayVideo()
}

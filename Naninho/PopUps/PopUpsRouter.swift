//
//  PopUpsRouter.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import UIKit

class PopUpsRouter: PopUpRouting {
    
    private weak var source: UIViewController?
    private var constraint: NSLayoutConstraint?
    
    init(source: UIViewController, constraint: NSLayoutConstraint) {
        self.source = source
        self.constraint = constraint
    }
    
    func show() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.constraint?.constant = 0
            self.source?.view.layoutIfNeeded()
        }
    }
    
    func hide() {
        if let constraint = constraint,
           let source = source{
            UIView.animate(withDuration: 0.3, delay: 0) {
                constraint.constant = source.view.frame.height
                source.view.layoutIfNeeded()
            }
        }
    }
}

//
//  PopUpProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 03/03/22.
//

import Foundation
import UIKit

protocol PopUpPresenting {
    func preparePopUp(forLevel level: Int, andStars stars: Int)
}

protocol PopUpRouting {
    func show()
    func hide()
}

protocol PopUp {}

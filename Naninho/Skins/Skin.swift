//
//  Skin.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation

class Skin {
    
    var imageName: String = "feliz"
    var isObtained: Bool = true
    var price: Int = 0
    
    init(imageName: String, isObtained: Bool = true, price: Int = 0) {
        self.imageName = imageName
        self.isObtained = isObtained
        self.price = price
    }
}

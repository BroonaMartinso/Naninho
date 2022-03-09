//
//  SkinManager.swift
//  Naninho
//
//  Created by Marco Zulian on 08/03/22.
//

import Foundation

struct SkinRepository {
    
    static var skins: [Skin] =
        [
            Skin(imageName: "feliz"),
            Skin(imageName: "Naninho", isObtained: false, price: 100)
        ]
}

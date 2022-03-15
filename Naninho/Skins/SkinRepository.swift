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
            Skin(imageName: "Naninho"),
            Skin(imageName: "Claudio", isObtained: false, price: 150),
            Skin(imageName: "Gabbo", isObtained: false, price: 150),
            Skin(imageName: "Garff", isObtained: false, price: 150),
            Skin(imageName: "Larry", isObtained: false, price: 150),
            Skin(imageName: "Ned", isObtained: false, price: 150),
            Skin(imageName: "Rob", isObtained: false, price: 150)
        ]
}

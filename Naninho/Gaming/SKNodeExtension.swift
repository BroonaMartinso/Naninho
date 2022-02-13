//
//  GameScene.swift
//  Naninho
//
//  Created by Bruna Oliveira on 31/01/22.
//
/*
 Eventos
 - Começou o nível -> level_start
 - Perdeu o nível -> level_end
 - Reiniciou o jogo -> level_restart
 - Pulou -> player_jump (posicao no eixo y quando pulou)
 Analytics.logEvent("player_jump", parameters: [
 "player_height": node.position.y as NSNumber
 ])
 
 Analytics.setUserProperty(value, forName: name)
 
 Propriedade
 - Tempo que "durou" na última vez que jogou
 */

import SpriteKit
//import FirebaseAnalytics

extension SKNode {
    //TODO: Limpar código, não precisa de duas extensões, provavelmente
    func slideVertically(distance: CGFloat, completion: @escaping ()->Void = {}) {
        self.run(SKAction.sequence(
            [SKAction.moveBy(x: 0, y: distance * 1.1, duration: 0.2),
             SKAction.moveBy(x: 0, y: -distance * 0.1, duration: 0.05)])) {
                 completion()
             }
    }
    
    func slideHorizontally(distance: CGFloat, completion: @escaping ()->Void = {}) {
        self.run(SKAction.moveBy(x: distance, y: 0, duration: 1)) {
            completion()
        }
    }
    
    func tilt(byAngle angle: Double, completion: @escaping ()->Void = {}) {
        self.run(SKAction.sequence([
            SKAction.rotate(byAngle: angle / 2, duration: 0.05),
            SKAction.rotate(byAngle: -angle, duration: 0.05),
            SKAction.rotate(byAngle: angle / 2, duration: 0.05)
        ]))
    }
}

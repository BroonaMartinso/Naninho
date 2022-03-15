//
//  Naninho.swift
//  Naninho
//
//  Created by Marco Zulian on 11/03/22.
//

import SpriteKit

protocol NaninhoProtocol {
    
    var name: String { get }
    var representation: SKSpriteNode { get }
    var spikes: [SpikeProtocol] { get }
    
    func bounce()
    func interact()
    func happy()
    func mad()
    func pause()
    func resume()
    
    func startGame(with: LevelConfiguration, _ completion: @escaping () -> Void)
    func growSpikes(amount: Int)
    func handleTap(atPos pos: CGPoint, status: NaninhoStatus)
    func resetStatus()
    func update(deltaTime: Double)
}

protocol SpikeProtocol {
    var representation: SKNode { get }
    func fall()
}

extension NaninhoProtocol {
    func handleTap(atPos pos: CGPoint, status: NaninhoStatus) {
        for spike in spikes {
            if spike.representation.contains(pos) {
                spike.fall()
                return
            }
        }
        
        if representation.contains(pos) {
            switch status {
            case .inMenu:
                interact()
            case .inGame:
                mad()
            }
        }
    }
}

enum NaninhoStatus {
    case inMenu
    case inGame
}


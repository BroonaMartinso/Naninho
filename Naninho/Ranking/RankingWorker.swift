//
//  RankingWorker.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GameKit
import UIKit

class RankingWorker: RankingWorking {
    
    init() {
        authenticateLocalPlayer()
    }
    
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in }
    }
    
    func getLeaderboardWith(id: String) -> GKGameCenterViewController? {
        return GKGameCenterViewController(leaderboardID: id, playerScope: .global, timeScope: .allTime)
    }
    
    func setRecord(value: Int, toLeaderbordWithId id: String) {
        GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [id], completionHandler: {error in})
    }
    
}

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
        if #available(iOS 14.0, *) {
            return GKGameCenterViewController(leaderboardID: id, playerScope: .global, timeScope: .allTime)
        } else {
            let vc = GKGameCenterViewController()
            vc.viewState = .leaderboards
            vc.leaderboardIdentifier = id
            return vc
        }
    }
    
    func setRecord(value: Int, toLeaderbordWithId id: String) {
        if #available(iOS 14.0, *) {
            GKLeaderboard.submitScore(value, context:0, player: GKLocalPlayer.local, leaderboardIDs: [id], completionHandler: {error in})
        } else {
            let reportedScore = GKScore(leaderboardIdentifier: id)
            reportedScore.value = Int64(value)
            GKScore.report([reportedScore]) {error in}
        }
    }
}

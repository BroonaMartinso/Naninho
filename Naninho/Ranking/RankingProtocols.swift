//
//  RankingProtocols.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GameKit

protocol RankingInteracting: AnyObject {
    func handleRankingButtonTapped()
    func handleStarsButtonTapped()
    func registerLevelRecord()
    func registerStarRecord()
    func updateRecords()
}

protocol RankingPresenting: AnyObject {
    func showRanking(GameCenterVC: GKGameCenterViewController)
}

protocol RankingWorking: AnyObject {
    func getLeaderboardWith(id: String) -> GKGameCenterViewController?
    func setRecord(value: Int, toLeaderbordWithId id: String)
}

protocol RankingViewControlling: AnyObject {
    func showRanking(_ vc: GKGameCenterViewController)
}

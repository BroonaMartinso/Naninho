//
//  RankingInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GameKit

class RankingInteractor: RankingInteracting {
    enum GameViewControllerLeaderboards: String {
        case MAIOR_NIVEL = "maiorNivel"
        case MAIS_ESTRELAS = "maisEstrelas"
    }
    
    private var presenter: RankingPresenting?
    private var worker: RankingWorking?
    
    init(presenter: RankingPresenting, worker: RankingWorking) {
        self.presenter = presenter
        self.worker = worker
    }
    
    init(worker: RankingWorker) {
        self.worker = worker
    }
    
    func handleRankingButtonTapped() {
        if let ranking = worker?.getLeaderboardWith(id: GameViewControllerLeaderboards.MAIOR_NIVEL.rawValue) {
            presenter?.showRanking(GameCenterVC: ranking)
        }
    }
    
    func handleStarsButtonTapped() {
        if let starsRankng = worker?.getLeaderboardWith(id: GameViewControllerLeaderboards.MAIS_ESTRELAS.rawValue) {
            presenter?.showRanking(GameCenterVC: starsRankng)
        }
    }
    
    internal func registerLevelRecord(_ record: Int) {
//        let maxLevel = LevelInteractor.shared.maxLevel
        worker?.setRecord(value: record, toLeaderbordWithId: GameViewControllerLeaderboards.MAIOR_NIVEL.rawValue)
    }
    
    internal func registerStarRecord(_ record: Int) {
//        let totalStars = LevelInteractor.shared.obtainedStars
        worker?.setRecord(value: record, toLeaderbordWithId: GameViewControllerLeaderboards.MAIS_ESTRELAS.rawValue)
    }
    
    func updateRecords(levelRecord: Int, starsRecord: Int) {
        registerLevelRecord(levelRecord)
        registerStarRecord(starsRecord)
    }
}

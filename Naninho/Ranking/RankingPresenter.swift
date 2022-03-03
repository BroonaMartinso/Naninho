//
//  RankingPresenter.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import GameKit

class RankingPresenter: RankingPresenting {
    
    private weak var viewController: RankingViewControlling?
    
    init(viewController: RankingViewControlling) {
        self.viewController = viewController
    }
    
    func showRanking(GameCenterVC: GKGameCenterViewController) {
        viewController?.showRanking(GameCenterVC)
    }
}

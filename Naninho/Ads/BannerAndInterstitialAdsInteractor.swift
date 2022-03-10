//
//  AdsInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class BannerAndInterstitialAdsInteractor: NSObject, NonRewardingAdsInteracting, GADFullScreenContentDelegate {
    
    private var presenter: AdsPresenting?
    private var worker: AdsWorking?
    private var currentAdCase: IntersticialAdsCases = .replay
    
    init(presenter: AdsPresenting, worker: AdsWorking) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func insertBanner(withSize size: CGSize) {
        if let banner = worker?.getBanner(withSize: size) {
            presenter?.presentBanner(banner)
        }
    }
    
    //TODO: Rever implementação de hide e show
    func hideBanner() {
        worker?.hideBanner()
    }
    
    func showBanner() {
        worker?.showBanner()
    }
    
    func showInterstitial(for adCase: IntersticialAdsCases) {
        if let interstitial = worker?.getInterstitial() {
            self.currentAdCase = adCase
            interstitial.fullScreenContentDelegate = self
            presenter?.presentIntestitial(interstitial)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        self.worker?.requestInterstitial()
        self.presenter?.endInterstitial(for: self.currentAdCase)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.worker?.requestInterstitial()
        self.presenter?.endInterstitial(for: self.currentAdCase)
    }
}


enum IntersticialAdsCases {
    case replay
    case win
}

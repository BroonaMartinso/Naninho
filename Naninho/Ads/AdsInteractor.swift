//
//  AdsInteractor.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdsInteractor: NSObject, AdsInteracting, GADFullScreenContentDelegate {
    
    private var presenter: AdsPresenting?
    private var worker: AdsWorking?
    
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
    
    func showInterstitial() {
        if let interstitial = worker?.getInterstitial() {
            interstitial.fullScreenContentDelegate = self
            presenter?.presentIntestitial(interstitial)
        }
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        worker?.requestInterstitial()
    }
}

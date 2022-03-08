//
//  AdsRouter.swift
//  Naninho
//
//  Created by Marco Zulian on 02/03/22.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdsRouter: AdsRouting {
    private weak var source: UIViewController?
    
    init(vc: UIViewController) {
        self.source = vc
    }
    
    func insertBanner(_ bannerView: GADBannerView) {
        if let source = source {
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            source.view.addSubview(bannerView)
            source.view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: source.bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: source.view,
                                    attribute: .trailing,
                                    multiplier: 1,
                                    constant: -source.view.frame.width * 0.025)
                ])
        }
    }
    
    func presentIntestitial(_ intestitial: GADInterstitialAd) {
        if let source = source {
            intestitial.present(fromRootViewController: source)
        }
    }
    
}
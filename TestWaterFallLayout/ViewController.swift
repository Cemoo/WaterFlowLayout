//
//  ViewController.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 23.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import MoPub
import Alamofire
import WaterfallLayout

class ViewController: UIViewController, MPCollectionViewAdPlacerDelegate {
    
    var items = [Item]()
    
    @IBOutlet weak var colView: UICollectionView!
    private var collectionViewAdPlacer: MPCollectionViewAdPlacer!
    var positioning = MPClientAdPositioning()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColView()
        fetchData()
        configAd()
        loadNative()
    }
    
    fileprivate func setupColView() {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        //layout.headerHeight = 50.0
        //colView.collectionViewLayout = layout
        colView.setCollectionViewLayout(layout, animated: true)
        //colView.register(...)
        colView.dataSource = self
        colView.delegate = self
        
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        colView.register(nibCell, forCellWithReuseIdentifier: "cell")
        
        let nibNative = UINib(nibName: "NativeAdColViewCell", bundle: nil)
        colView.register(nibNative, forCellWithReuseIdentifier: "native")
        
//        let layout = MyLayout()
//        layout.delegate = self
//        colView.setCollectionViewLayout(layout, animated: false)
//        colView.isScrollEnabled = true
//        colView.bounces = true
//        layout.numberOfColumns = 2
        
        
    }
    
    
    fileprivate func configAd() {
        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: "76a3fefaced247959582d2d2df6f4757")
        MoPub.sharedInstance().initializeSdk(with: config, completion: nil)
    }
    
}


extension ViewController {
    
    func loadNative() {
        var settings = MPStaticNativeAdRendererSettings()
        settings.renderingViewClass = NativeAdColViewCell.self
        settings.viewSizeHandler = { (maxWidth: CGFloat) in
            return CGSize(width: CGFloat(self.view.frame.size.width), height: 50.0)
        }
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = settings.renderingViewClass
        videoSettings.viewSizeHandler = settings.viewSizeHandler
        
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfiguration(with: videoSettings)
        let nativeAdConfig = MPStaticNativeAdRenderer.rendererConfiguration(with: settings)
        
        //        nativeAdConfig?.supportedCustomEvents = ["FlurryNativeCustomEvent", "FacebookNativeCustomEvent", "MPGoogleAdMobNativeCustomEvent", "MPMoPubNativeCustomEvent"]
        //
        //        positioning.enableRepeatingPositions(withInterval: 2)
        collectionViewAdPlacer = MPCollectionViewAdPlacer(collectionView: colView,
                                                          viewController: self,
                                                          adPositioning: positioning,
                                                          rendererConfigurations: [nativeAdConfig as Any, videoConfiguration as Any])
        
        collectionViewAdPlacer.delegate = self
        
        let targeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = [kAdMainImageKey,kAdCTATextKey, kAdTextKey, kAdTitleKey]
        collectionViewAdPlacer.loadAds(forAdUnitID: "76a3fefaced247959582d2d2df6f4757", targeting: targeting)
    }
    
    private func calculateHeightForNativeAdCell() -> CGSize {
        let contentSizeWidth = colView!.contentSize.width
        
        let cellWidth: CGFloat
        cellWidth = (contentSizeWidth - 6) / 1.0 //24 = 3 * 8 spacing
        
        let horizontalSizeClass = self.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.traitCollection.verticalSizeClass
        
        var height = cellWidth
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            height = cellWidth * 0.9
        }
        
        return CGSize(width: cellWidth, height: height)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 == 1 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = self.colView.mp_dequeueReusableCell(withReuseIdentifier: "native", for: indexPath) as! NativeAdColViewCell
            return cell
        } else {
            let cell = colView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
            
            cell.url = self.items[indexPath.row].thumbUrl ?? ""
            cell.setImage()
            
            cell.backgroundColor = UIColor.red
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: self.colView.frame.size.width, height: 80)
        }
        return CGSize(width: self.colView.frame.size.width, height: 50)
    }
    
    
}


extension ViewController: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return CGSize(width: 20, height: 30)
            case 1:
                return CGSize(width: 20, height: 40)
            case 2:
                return CGSize(width: 20, height: 20)
            default:
                return CGSize(width: 20, height: 40)
            }
        } else {
            return WaterfallLayout.automaticSize
        }

    }

    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        switch section {
        case 0: return .waterfall(column: 2)
        case 1: return  .flow(column: 1)
        default:
            return .flow(column: 1)
        }

    }

}


//extension ViewController: MyLayoutDelegate {
//    func collectionView(colView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let random = arc4random_uniform(4) + 1
//        return CGFloat(random * 200)
//    }
//}

extension ViewController {
    
    func fetchData() {
        let url: URL = URL(string: "http://server.sprueche-app.de/phpScripts/items.php?hl=de&type=100&amount=5")!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.data {
                do {
                    print(String.init(data: data, encoding: .utf8))
                    let items = try JSONDecoder().decode(MyData.self, from: data)
                    self.items = items.items!
                    if self.items.count > 0 {
                        self.colView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                    self.items = []
                }
            }
        }
    }
}

























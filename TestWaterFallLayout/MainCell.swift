//
//  MainCell.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 24.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import WaterfallLayout
import MoPub

class MainCell: UITableViewCell {

    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var adView: UIView!
    private var collectionViewAdPlacer: MPCollectionViewAdPlacer!
    var positioning = MPClientAdPositioning()
     var items = [Item]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        colView.setCollectionViewLayout(layout, animated: true)
        
        colView.dataSource = self
        colView.delegate = self
        
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        colView.register(nibCell, forCellWithReuseIdentifier: "cell")
        
        let nibNative = UINib(nibName: "NativeAdColViewCell", bundle: nil)
        colView.register(nibNative, forCellWithReuseIdentifier: "native")
        
        
        self.selectionStyle = .none
    }


    

}

extension MainCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.url = self.items[indexPath.row].thumbUrl ?? ""
        cell.setImage()
        
        cell.backgroundColor = UIColor.red
        return cell
    }
}


extension MainCell: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: 20, height: 30)
        case 1:
            return CGSize(width: 20, height: 40)
        case 2:
            return CGSize(width: 20, height: 20)
        case 3:
            return CGSize(width: 20, height: 30)
        case 4:
            return CGSize(width: 20, height: 20)
        case 5:
            return CGSize(width: 20, height: 20)
        case 6:
            return CGSize(width: 20, height: 45)
        default:
            return CGSize(width: 20, height: 20)
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

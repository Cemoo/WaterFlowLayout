//
//  NativeAdColViewCell.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 23.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
import MoPub

class NativeAdColViewCell: UICollectionViewCell, MPNativeAdRendering {
   
    override func awakeFromNib() {
        self.backgroundColor = UIColor.orange
    }
}

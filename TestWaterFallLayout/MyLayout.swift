//
//  MyLayout.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 23.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import UIKit
protocol MyLayoutDelegate {
    func collectionView(colView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class MyLayout: UICollectionViewLayout {
    var delegate: MyLayoutDelegate!
    var numberOfColumns = 1
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    
    private var width: CGFloat  {
        get {
            return (collectionView?.frame.size.width)!
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        if cache.isEmpty {
            let colWidth = width / CGFloat(numberOfColumns)
            var xOffsets = [CGFloat]()
            
          //  self.collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0  )
            self.collectionView?.isScrollEnabled = true
            for col in 0..<numberOfColumns {
                xOffsets.append(CGFloat(col)*colWidth)
            }
            
            var yOffset = [CGFloat].init(repeating: 0, count: numberOfColumns)
            var column = 0
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPAth = IndexPath(item: item, section: 0)
                let height = delegate.collectionView(colView: collectionView!, heightForItemAtIndexPath: indexPAth)
                
                let frame = CGRect(x: xOffsets[column], y: yOffset[column], width: colWidth, height: height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPAth)
                attributes.frame = frame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height).maxY)
                yOffset[column] = yOffset[column] + height
                column = column >= (numberOfColumns - 1) ? 0 : column+1
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = [UICollectionViewLayoutAttributes]()
        for atts in cache {
            if atts.frame.intersects(rect) {
                layoutAttrs.append(atts)
            }
        }
        
        return layoutAttrs
    }
    
    
    
    
    
    
    
    
}

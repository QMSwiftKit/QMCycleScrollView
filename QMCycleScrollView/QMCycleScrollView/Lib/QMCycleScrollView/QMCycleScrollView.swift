//
//  QMCycleScrollView.swift
//  QMCycleScrollView
//
//  Created by QingMingZhang on 16/9/20.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit


@objc protocol QMCycleScrollViewDataSource: NSObjectProtocol {
    func cycleScrollView(cycleScrollView: QMCycleScrollView, viewForItemAtIndex index: Int) -> UICollectionViewCell
    func numberOfItemsInCycleScrollView(cycleScrollView: QMCycleScrollView) -> Int
}


@objc protocol QMCycleScrollViewDelegate: NSObjectProtocol {
    optional func cycleScrollView(cycleScrollView: QMCycleScrollView, didSelectItemAtIndex index: Int)
}


class QMCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var delegate: QMCycleScrollViewDelegate? = nil
    var dataSource: QMCycleScrollViewDataSource? = nil
    
    var sc: UIScrollView = {
        let c = UIScrollView()
//        c.autoresizesSubviews
        return c
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.pagingEnabled = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.registerNib(UINib(nibName: "QMCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kQMCollectionViewCellReuseIdentifier)
        
        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Horizontal // 默认横向滚动
        
        return flowLayout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if dataSource != nil {
            return dataSource!.cycleScrollView(self, viewForItemAtIndex: indexPath.item)
        }
        else {
            
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("", forIndexPath: indexPath)
        return cell
    }
}

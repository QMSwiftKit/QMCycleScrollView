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

@IBDesignable
class QMCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var delegate: QMCycleScrollViewDelegate? = nil
    var dataSource: QMCycleScrollViewDataSource? = nil
    
    // MARK: - 属性
    /// 滚动方向 (默认:横向滚动)
    var scrollDirection: UICollectionViewScrollDirection = .Horizontal {
        didSet {
            flowLayout.scrollDirection = scrollDirection
        }
    }
    
    /// 自动滚动间隔时间
    var autoScrollTimeInterval: NSTimeInterval = 1.0
    
    /// 是否无限循环
    var infiniteLoop: Bool = true
    
    /// 是否自动滚动
    var autoScroll: Bool = true {
        willSet(newValue) {
            
        }
        didSet {
            self.configureTimer()
        }
    }
    
    /// 当前的cell的index
    var currentIndex: Int = 0
    
    private var timer: NSTimer? = nil
    
    // 设置timer
    private func configureTimer() {
        print("start")
        print(#function)
        let timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(self.autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        self.timer = timer
        print(#function)
        print("end")
    }
    
    // 清掉timer
    private func invalidateTimer()  {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    /// 原始总数
    private var originalTotalItemsCount = 0
    /// 原始总数的倍数
    private var totalItemsCount = 0
    /**
     自动滚动
     */
    func automaticScroll() {
        if totalItemsCount == 0 {
            return
        }
        
        let targetIndex: Int = currentIndex + 1
        self.scrollToIndex(targetIndex)
    }
    
    /**
     滚动到第targetIndex
     
     - parameter targetIndex: 目标cell下标
     */
    func scrollToIndex(targetIndex: Int) {
        
        // 滚动到最后一个
        if targetIndex >= totalItemsCount {
            currentIndex = totalItemsCount / 2
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: totalItemsCount / 2, inSection: 0), atScrollPosition: .None, animated: false)
        }
        else {
            currentIndex = targetIndex
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: targetIndex, inSection: 0), atScrollPosition: .None, animated: true)
        }
    }
    
    var sc: UIScrollView = {
        let c = UIScrollView()
        return c
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.pagingEnabled = true
        
//        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false // 设置启动NSLayoutConstraint
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")

        return collectionView
    }()
    
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal // 默认横向滚动
        
        return flowLayout
    }()
    
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    // MARK: - 注册cell
    func registerClass(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.registerClass(cellClass, forCellWithReuseIdentifier: identifier)
    }
    func registerNib(nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - 重用cell
    func dequeueReusableCellWithReuseIdentifier(identifier: String, forIndex index: Int) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: NSIndexPath(forItem: index, inSection: 0))
    }
    
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print(#function)
//        flowLayout.itemSize = self.bounds.size
//        self.configureTimer()
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.configureTimer()
        self.configureSubviews()
    }
    
//    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
//        print(#function)
//        print(self.bounds.size)
//        return super.awakeAfterUsingCoder(aDecoder)
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.autoresizingMask = .None
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flowLayout.itemSize = self.bounds.size
        self.layoutCollectionView()
    }
    
    func viewWillLayoutSubviews() {
        
    }
    
    
    private func configureCollectionLayout() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = self.scrollDirection // 默认横向滚动
    }
    
    /**
     设置子视图
     */
    private func configureSubviews() {
        self.addSubview(collectionView)

    }
    
    /**
     设置UICollectionView的布局
     */
    private func layoutCollectionView() {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: collectionView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: collectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: collectionView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: collectionView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        
        self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    /// 即将从父视图移除
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview != nil {
            self.invalidateTimer()
        }
    }
    
    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    // MARK: - UICollectionViewDataSource
    private let kMultiple: Int = 50
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        if dataSource != nil {
            originalTotalItemsCount = dataSource!.numberOfItemsInCycleScrollView(self)
            totalItemsCount = originalTotalItemsCount * kMultiple
        }
        else {
            originalTotalItemsCount = 1
            totalItemsCount = 1
        }
        self.invalidateTimer()
        self.configureTimer()
        return totalItemsCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print(#function)
        print(Int(4.6))
        if dataSource != nil {
//            let cell = dataSource!.cycleScrollView(self, viewForItemAtIndex: indexPath.item % originalTotalItemsCount)
            return dataSource!.cycleScrollView(self, viewForItemAtIndex: indexPath.item % originalTotalItemsCount)
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(#function)
        delegate?.cycleScrollView?(self, didSelectItemAtIndex: indexPath.item)
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(#function)
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print(#function)
        if autoScroll {
            self.invalidateTimer()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
//        if autoScroll {
//            self.configureTimer()
//        }
    }
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        print(#function)
////        self.scrollViewDidEndScrollingAnimation(collectionView)
//    }
//    
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        print(#function)
//    }
}

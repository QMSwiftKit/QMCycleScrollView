//
//  ViewController.swift
//  QMCycleScrollView
//
//  Created by QingMingZhang on 16/9/19.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

let kScreenBounds: CGRect  = UIScreen.mainScreen().bounds
let kScreenSize: CGSize    = kScreenBounds.size
let kScreenWidth: CGFloat  = kScreenSize.width
let kScreenHeight: CGFloat = kScreenSize.height




let data0: [String:UIColor] = ["left": UIColor.greenColor(), "image": UIColor.yellowColor(), "right": UIColor.greenColor()]
let data1: [String:UIColor] = ["left": UIColor.redColor(), "image": UIColor.yellowColor(), "right": UIColor.greenColor()]
let data2: [String:UIColor] = ["left": UIColor.orangeColor(), "image": UIColor.whiteColor(), "right": UIColor.greenColor()]
let data3: [String:UIColor] = ["left": UIColor.blueColor(), "image": UIColor.yellowColor(), "right": UIColor.greenColor()]
let data4: [String:UIColor] = ["left": UIColor.purpleColor(), "image": UIColor.yellowColor(), "right": UIColor.greenColor()]
let data5: [String:UIColor] = ["left": UIColor.orangeColor(), "image": UIColor.yellowColor(), "right": UIColor.purpleColor()]
let data6: [String:UIColor] = ["left": UIColor.brownColor(), "image": UIColor.redColor(), "right": UIColor.greenColor()]
let data7: [String:UIColor] = ["left": UIColor.grayColor(), "image": UIColor.grayColor(), "right": UIColor.greenColor()]
let data8: [String:UIColor] = ["left": UIColor.orangeColor(), "image": UIColor.yellowColor(), "right": UIColor.greenColor()]


class ViewController: UIViewController, QMCycleScrollViewDelegate, QMCycleScrollViewDataSource {
    
    
    
    
    let datas: Array<[String: UIColor]> = [data0, data1, data2,
//                                           data3, data4, data5,
//                                           data6, data7, data8,
                                           ]

    // MARK: - UIStoryboard
    
    @IBOutlet weak var csv: QMCycleScrollView!
    @IBOutlet weak var csvLeft: QMCycleScrollView!
    
    @IBOutlet weak var csvCenter: QMCycleScrollView!
    
    @IBOutlet weak var csvRight: QMCycleScrollView!
    
    @IBOutlet weak var vBottom: UIView!
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let cs = QMCycleScrollView(frame: CGRectMake(0, 50, kScreenWidth/2, 50))
        cs.delegate = self
        cs.dataSource = self
        
        
        self.view.addSubview(cs)
        
        
        
        csv.delegate = self
        csv.dataSource = self
        
        csvLeft.delegate = self
        csvLeft.dataSource = self
        
        csvCenter.delegate = self
        csvCenter.dataSource = self
        
        csvRight.delegate = self
        csvRight.dataSource = self
        
        cs.registerNib(UINib(nibName: "OnlyImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnlyImageViewCollectionViewCell")
        
        csv.registerNib(UINib(nibName: "OnlyImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnlyImageViewCollectionViewCell")
        
        csvLeft.registerNib(UINib(nibName: "OnlyImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnlyImageViewCollectionViewCell")
        
        csvCenter.registerNib(UINib(nibName: "OnlyImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnlyImageViewCollectionViewCell")
        
        csvRight.registerNib(UINib(nibName: "OnlyImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnlyImageViewCollectionViewCell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - QMCycleScrollViewDataSource
    func cycleScrollView(cycleScrollView: QMCycleScrollView, viewForItemAtIndex index: Int) -> UICollectionViewCell {
        let cell =  cycleScrollView.dequeueReusableCellWithReuseIdentifier("OnlyImageViewCollectionViewCell", forIndex: index) as! OnlyImageViewCollectionViewCell
        let data = datas[index]
        cell.vLeft.backgroundColor = data["left"]
        cell.imageView.backgroundColor = data["image"]
        cell.vRight.backgroundColor = data["right"]
        
        return cell
    }
    func numberOfItemsInCycleScrollView(cycleScrollView: QMCycleScrollView) -> Int {
        return datas.count
    }
    
    func cycleScrollView(cycleScrollView: QMCycleScrollView, didSelectItemAtIndex index: Int) {
        print(index)
    }

}


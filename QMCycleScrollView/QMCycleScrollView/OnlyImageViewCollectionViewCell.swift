//
//  OnlyImageViewCollectionViewCell.swift
//  QMCycleScrollView
//
//  Created by QingMingZhang on 16/9/23.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

class OnlyImageViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - XIB
    
    @IBOutlet weak var vLeft: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var vRight: UIView!
    
    // MARK: - 唤醒
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.autoresizingMask = .None
    }

}

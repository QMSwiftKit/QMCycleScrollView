//
//  QMCollectionViewCell.swift
//  QMCycleScrollView
//
//  Created by QingMingZhang on 16/9/20.
//  Copyright © 2016年 极客栈. All rights reserved.
//

import UIKit

let kQMCollectionViewCellReuseIdentifier = "QMCollectionViewCell"

class QMCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.autoresizingMask = .None
    }

}

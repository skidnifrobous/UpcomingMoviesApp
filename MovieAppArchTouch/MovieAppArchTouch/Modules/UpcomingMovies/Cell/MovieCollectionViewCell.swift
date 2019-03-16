//
//  MovieCollectionViewCell.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 15/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var poster : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var genres : UILabel!
    @IBOutlet weak var releaseDate : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addShadow()
    }
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
}

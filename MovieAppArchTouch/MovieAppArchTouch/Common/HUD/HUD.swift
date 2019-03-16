//
//  HUD.swift
//  EAD
//
//  Created by Yuri Ramos on 21/07/17.
//  Copyright © 2017 Fractal Tecnologia. All rights reserved.
//

import UIKit

class HUD: UIView {
    
    var box : UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addBehavior()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    private func addBehavior() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        box = UINib(nibName: "HUD", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView
        self.addSubview(box)
        box.center = self.center
        box.layer.cornerRadius = 10
        box.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        box.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        box.center = self.center
    }
    
    func showIn(_ view: UIView, backGroundOpaque: Bool = false) {
        self.removeFromSuperview()
        self.alpha = 0
        self.frame = view.bounds
        if backGroundOpaque { self.backgroundColor = UIColor.white }
        view.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func hide(animated:Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
}

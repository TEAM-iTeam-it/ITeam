//
//  GradientButton.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/20.
//

import UIKit

class GradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(displayP3Red: 184/255, green: 98/255, blue: 255/255, alpha: 1).cgColor, UIColor(displayP3Red: 144/255, green: 255/255, blue: 201/255, alpha: 1).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 35
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

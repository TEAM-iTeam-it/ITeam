//
//  GradientCircleView.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/02.
//

import Foundation
import UIKit

class GradientView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(named: "purple_184")?.cgColor, UIColor(named: "purple_247")?.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0)
        l.endPoint = CGPoint(x: 1, y: 1)
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
}
class GradientWhiteView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor,
                    UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
                    UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor]
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        l.locations = [0, 0.12, 1]
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
}

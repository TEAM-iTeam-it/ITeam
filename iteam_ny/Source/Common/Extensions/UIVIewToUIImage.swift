//
//  UIVIewToUIImage.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/02.
//

import Foundation
import UIKit

extension GradientView {
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}

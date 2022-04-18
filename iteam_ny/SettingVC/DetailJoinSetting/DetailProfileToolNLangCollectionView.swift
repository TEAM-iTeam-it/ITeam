//
//  DetailProfileToolNLangCollectionView.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/17.
//

import UIKit

class DetailProfileToolNLangCollectionView: UICollectionView {
    
    override var intrinsicContentSize: CGSize {
        
        let number = numberOfItems(inSection: 0)
        var height: CGFloat = 0

        for i in 0..<number {

            guard let cell = cellForItem(at: IndexPath(row: i, section: 0)) else {
                continue
            }
            height += cell.bounds.height
        }
        return CGSize(width: contentSize.width, height: height)
    }

}

//
//  LeftAlignedCollectionViewFlowLayout.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/12.
//

import UIKit
import Foundation

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    required override init() {super.init(); common()}
      required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}
      
      private func common() {
          // estimatedItemSize.width = UICollectionViewFlowLayout.automaticSize.width
         
          minimumLineSpacing = 10
          minimumInteritemSpacing = 10
      }
      
      override func layoutAttributesForElements(
                      in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
          
          guard let att = super.layoutAttributesForElements(in:rect) else {return []}
          var x: CGFloat = sectionInset.left
          var y: CGFloat = -1.0
          
          for a in att {
              if a.representedElementCategory != .cell { continue }
              
              if a.frame.origin.y >= y { x = sectionInset.left }
              a.frame.origin.x = x
              x += a.frame.width + minimumInteritemSpacing
              y = a.frame.maxY
          }
          return att
      }
}

//
//  MakingGameTeamCollectionViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

class MakingGameTeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCollView: UICollectionView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var purpose: UILabel!
    @IBOutlet weak var part: UILabel!
    
    // @나연 : 서버에서 받아 올 사용자 이미지 네임
    var images: [String] = []
}
extension MakingGameTeamCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // delegate와 datasource를 내부 collectionview로 옮겨줌
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollView.delegate = self
        imageCollView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingGameTeamImageCell", for: indexPath) as! MakingGameTeamImageCollectionViewCell
        cell.userImage.image = UIImage(named: images[indexPath.row])
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
        cell.layer.masksToBounds = true
        
        return cell
    }
}
extension MakingGameTeamCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 50
        let height = 50

        let size = CGSize(width: width, height: height)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        // Make sure that the number of items is worth the computing effort.
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }


        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = -3.0
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset


        // Make sure to remove the last item spacing or it will
        // miscalculate the actual total width.
        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right


        // If the number of cells that exist take up less room than the
        // collection view width, then center the content with the appropriate insets.
        // Otherwise return the default layout inset.
        guard totalCellWidth < contentWidth else {
            return insets
        }


        // Calculate the right amount of padding to center the cells.
        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
    }
}

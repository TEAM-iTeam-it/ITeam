//
//  CompletedTeamCell.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/04.
//

import UIKit

class CompletedTeamCell: UICollectionViewCell {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var subContent: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // @나연 : 서버에서 받아 올 사용자 이미지 네임
    var images: [String] = []
    
        
}
extension CompletedTeamCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // delegate와 datasource를 내부 collectionview로 옮겨줌
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "completedTeamImgCell", for: indexPath) as! CompletedTeamCellImages
        cell.userImages.image = UIImage(named: images[indexPath.row])
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
        cell.layer.masksToBounds = true
        
        return cell
    }
}
extension CompletedTeamCell: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 70
        let height = 70

        let size = CGSize(width: width, height: height)
        return size
    }
}

class CompletedTeamCellImages: UICollectionViewCell {
    
    @IBOutlet weak var userImages: UIImageView!
    
    
}

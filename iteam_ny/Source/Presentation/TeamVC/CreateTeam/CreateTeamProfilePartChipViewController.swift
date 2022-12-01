//
//  CreateTeamProfilePartChipViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/05.
//

import UIKit

class CreateTeamProfilePartChipViewController: UIViewController {

    var parts: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        parts = ["웹 기획자", "웹 개발", "백엔드 개발"]
        
    }

}
extension CreateTeamProfilePartChipViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return parts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partNameCell", for: indexPath) as! CreateTeamProfilePartCollectionViewCell
//        cell.layer.borderWidth = 0.5
//        cell.layer.cornerRadius = cell.frame.height/2
//        cell.layer.borderColor = UIColor.black.cgColor
        cell.partName.setTitle(parts[indexPath.row], for: .normal)
        //cell.sizeToFit()
        
        return cell
    }
    
    
}

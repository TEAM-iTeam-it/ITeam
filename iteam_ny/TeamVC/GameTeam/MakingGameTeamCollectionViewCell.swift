//
//  MakingGameTeamCollectionViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class MakingGameTeamCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageCollView: UICollectionView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var purpose: UILabel!
    @IBOutlet weak var part: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    let user = Auth.auth().currentUser!
    let ref = Database.database().reference()
    var resizedImage: UIImage = UIImage()
    
    // 서버에서 받아 올 사용자 이미지 데이터
    var imageData: [Data] = [] {
        didSet {
            imageCollView.reloadData()
        }
    }
    var likeBool: Bool = false {
        willSet(newValue) {
            if newValue {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeButton.tintColor = UIColor(named: "purple_184")
            }
            else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                likeButton.tintColor = UIColor(named: "gray_196")
            }
        }
    }
    // delegate와 datasource를 내부 collectionview로 옮겨줌
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollView.delegate = self
        imageCollView.dataSource = self
    }
    
    @IBAction func likeButtonAction(_ sender: UIButton) {
        if likeBool {
            likeBool = false
            removeDataAcion()
        }
        else {
            likeBool = true
            pullDataAcion()
        }
    }
    // 관심있는 팀에 추가
    func pullDataAcion() {
        var updateString: String = ""
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            var lastDatas: [String] = []
            var lastData: String! = snapshot.value as? String
            lastDatas = lastData.components(separatedBy: ", ")
            if !lastDatas.contains(self.teamName.text!) {
                if snapshot.value as? String == nil || snapshot.value as? String == "" {
                    var lastData: String! = snapshot.value as? String
                    updateString = self.teamName.text!
                }
                else {
                    var lastData: String! = snapshot.value as? String
                    lastData += ", \(self.teamName.text!)"
                    updateString = lastData
                }
                let values: [String: Any] = [ "teamName": updateString ]
                // 데이터 추가
                self.ref.child("user").child(self.user.uid).child("likeTeam").updateChildValues(values)
            }
        }
    }
    
    // 관심있는 팀에서 삭제
    func removeDataAcion() {
        var updateString: String = ""
        var lastDatas: [String] = []
        
        // 데이터 받아와서 이미 있으면 지워주기
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            if snapshot.value as? String != nil {
                var lastData: String! = snapshot.value as? String
                lastDatas = lastData.components(separatedBy: ", ")
                
                print(lastDatas)
                for i in 0..<lastDatas.count {
                    print(i)
                    if lastDatas[i] == self.teamName.text! {
                        print(i)
                        lastDatas.remove(at: i)
                        break
                    }
                }
                for i in 0..<lastDatas.count {
                    if lastDatas[i] == "" {
                        lastDatas.remove(at: i)
                        break
                    }
                    if i == 0 {
                        updateString += lastDatas[i]
                    }
                    else {
                        updateString += ", \(lastDatas[i])"
                    }
                }
            }
            let values: [String: Any] = [ "teamName": updateString ]
            // 데이터 추가
            self.ref.child("user").child(self.user.uid).child("likeTeam").updateChildValues(values)
        }
    }
}
extension MakingGameTeamCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if imageData.count > 2 {
           count = 3
        }
        else {
            count = imageData.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingGameTeamImageCell", for: indexPath) as! MakingGameTeamImageCollectionViewCell
        cell.userImage.isHidden = false
        if imageData.count <= 3 {
            // 받아온 사진 리사이징, 셀에 설정
            if let fetchedImage = UIImage(data: imageData[indexPath.row]) {
                resizedImage = resizeImage(image: fetchedImage, width: 50, height: 50)
                cell.userImage.image = resizedImage
            }
            else {
                // 데이터 받아오기 전까지 기본 이미지
                resizedImage = resizeImage(image: UIImage(named: "imgUser4.png")!, width: 50, height: 50)
                cell.userImage.image = resizedImage
            }
        }
        else {
            if indexPath.row == 0 || indexPath.row == 1 {
                // 받아온 사진 리사이징, 셀에 설정
                if let fetchedImage = UIImage(data: imageData[indexPath.row]) {
                    resizedImage = resizeImage(image: fetchedImage, width: 50, height: 50)
                    cell.userImage.image = resizedImage
                }
                else {
                    // 데이터 받아오기 전까지 기본 이미지
                    resizedImage = resizeImage(image: UIImage(named: "imgUser4.png")!, width: 50, height: 50)
                    cell.userImage.image = resizedImage
                }
                
            }
            else if indexPath.row == 2 {
                // 3명 이상인 팀원에 대한 팀원 수 뷰
                cell.gradientView.layer.cornerRadius = cell.frame.height/2
                cell.userImage.isHidden = true
                cell.memberCountLabel.text = "+\(imageData.count-2)"
      
            }
        }
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
        cell.layer.masksToBounds = true
        
        return cell
    }
    // 이미지 리사이징
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }

        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = -3.0
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset

        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

        guard totalCellWidth < contentWidth else {
            return insets
        }

        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
    }
}

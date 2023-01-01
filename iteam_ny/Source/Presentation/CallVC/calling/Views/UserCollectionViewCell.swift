//
//  UserCollectionViewCell.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/26.
//

import UIKit

import Kingfisher
import FirebaseStorage

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var otherMemberNameTF: UILabel!
    @IBOutlet weak var otherMemberPartTF: UILabel!
    @IBOutlet weak var profileGradientImageView: UIImageView!
    
    
    func setUI(image:String, nickname: String, position: String) {
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        
        // kingfisher 사용하기 위한 url
        let uid: String = image
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        
        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
            if let error = error {
            } else {
                profileImage.kf.setImage(with: url)
            }
        }
        otherMemberNameTF.text = nickname
        otherMemberPartTF.text = position
        profileImage.layer.masksToBounds = true
        
        
        }
    
}

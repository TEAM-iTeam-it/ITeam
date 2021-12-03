//
//  UserCollectionViewCell.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/26.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!

    func setUI(isSpeaker:Bool) {
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.image = isSpeaker ? UIImage(named: "person_profile.png") : UIImage(named: "person_profile_yellow.png")
        }
    
}

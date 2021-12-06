//
//  UserProfile.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/29.
//

import UIKit

class UserProfileController: UIViewController{
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var rectangle35View: UIView!
    @IBOutlet weak var userImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.image = UIImage(named: "img_user4")
    }
}

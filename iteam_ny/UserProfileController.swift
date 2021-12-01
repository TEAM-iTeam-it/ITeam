//
//  UserProfile.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/29.
//

import UIKit

class UserProfileController: UIViewController{
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideButton.layer.cornerRadius = 0
    }
}

//
//  UserProfile.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/29.
//

import UIKit

class UserProfileController: UIViewController{
    var userprofileDetail: UserProfileDetail?
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var characterLabel: UITextField!
    
    @IBOutlet weak var Interest: UITextField!
    @IBOutlet weak var toolNlanguage: UITextField!
    @IBOutlet weak var sameSchol: UITextField!
    
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var projectDetail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var callTime: UILabel!
    @IBOutlet weak var contactLink: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    
    @IBOutlet weak var backStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backStack.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 40, right: 70)
        backStack.isLayoutMarginsRelativeArrangement = true
        backStack.layer.cornerRadius = 10
        
        backStack.layer.shadowColor = UIColor.black.cgColor // 색깔
        backStack.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        backStack.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        backStack.layer.shadowRadius = 5 // 반경
        backStack.layer.shadowOpacity = 0.3 // alpha값
        
//        let backgroundView = UIView()
//
//        backView.translatesAutoresizingMaskIntoConstraints = false
//        backView.contentMode = .scaleAspectFit
//        backView.addSubview(backgroundView)
//        backgroundView.backgroundColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            guard let detail = userprofileDetail else { return }
        
        
            userName.text = detail.name
            partLabel.text = detail.part
        purposeLabel.text = detail.purpose
            characterLabel.text = detail.character
            toolNlanguage.text = detail.language
            Interest.text = detail.interest
            date.text = detail.date
            projectDetail.text = detail.exDetail
            callTime.text = detail.calltime
            portfolioLabel.text = detail.portfolio
            contactLink.text = detail.contactLink
            
        }
    
}


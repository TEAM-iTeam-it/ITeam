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
    
    @IBOutlet weak var sameSchol: UITextField!
    
    @IBOutlet weak var Interest: UILabel!
    @IBOutlet weak var toolNlanguage: UILabel!
    
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var projectDetail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var callTime: UILabel!
    @IBOutlet weak var contactLink: UILabel!
    @IBOutlet weak var portfolioLabel: UILabel!
    
    @IBOutlet weak var backStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backStack.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 30, right: 0)
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

class ActualGradientButton2: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor(displayP3Red: 184/255, green: 98/255, blue: 255/255, alpha: 1).cgColor, UIColor(displayP3Red: 144/255, green: 255/255, blue: 201/255, alpha: 1).cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        layer.insertSublayer(l, at: 0)
        return l
    }()
}


//
//  TeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit

class TeamViewController: UIViewController {

    @IBOutlet weak var myteamView: UIView!
    @IBOutlet weak var myteamBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myteamBtn.backgroundColor = .white
        myteamBtn.layer.cornerRadius = 20
        myteamBtn.layer.borderColor = UIColor.black.cgColor
        myteamBtn.layer.borderWidth = 0
        myteamBtn.layer.shadowColor = UIColor.black.cgColor
        myteamBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        myteamBtn.layer.shadowOpacity = 0.2
        myteamBtn.layer.shadowRadius = 10
        self.navigationController?.isNavigationBarHidden = true
        
        // 로고 이미지 비활성화, 색상 유지
      
        
        
    }
    
    // [Button Action] 나의 팀 생성 버튼
    @IBAction func createMyTeam(_ sender: UIButton) {
        
    }
    
  
}

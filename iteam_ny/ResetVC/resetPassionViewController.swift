//
//  resetPassionViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/04/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetPassionViewController: UIViewController {

    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    @IBOutlet var passionBtns: [UIButton]!
    // 성적 저장을 위한 변수
    var passions: [String] = []
    var passion: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
    
        for i in 0...passionBtns.count-1 {
            passionBtns[i].layer.cornerRadius = 16
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func passionBtnClicked(_ sender: UIButton) {
        if passion == sender.titleLabel?.text {
            sender.backgroundColor = UIColor(named: "gray_245")
            sender.layer.borderWidth = 0
            passion = nil
        }
        else if passion != nil {
            for i in 0...passionBtns.count-1 {
                if passionBtns[i].titleLabel?.text == passion {
                    passionBtns[i].backgroundColor = UIColor(named: "gray_245")
                    passionBtns[i].setTitleColor(UIColor(named: "gray_121"), for: .normal)
                    passionBtns[i].layer.borderWidth = 0
                }
            }
            sender.backgroundColor = UIColor(named: "purple_247")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
            
            passion = sender.titleLabel?.text!
        }
        else {
            sender.backgroundColor = UIColor(named: "purple_247")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
            
            passion = sender.titleLabel?.text!
        }
        print(passion)
    }
    // [Button action] 성적 다음
    @IBAction func passionNextBtn(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let values: [String: Any] = [ "wantGrade": passion]
        
        ref = Database.database().reference()
        // [ 지역 데이터 추가 ]
        ref.child("user").child(user.uid).child("userProfileDetail").updateChildValues(values)
        
        let wordVC = self.storyboard?.instantiateViewController(withIdentifier: "wordVC")
        self.navigationController?.pushViewController(wordVC!, animated: true)
        
    }
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
}

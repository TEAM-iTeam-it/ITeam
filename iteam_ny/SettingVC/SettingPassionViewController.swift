//
//  SettingPassionViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingPassionViewController: UIViewController {

    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    @IBOutlet var passionBtns: [UIButton]!
    // 성적 저장을 위한 변수
    var passions: [String] = []
    var passion: String?
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 8
        
        for i in 0...passionBtns.count-1 {
            passionBtns[i].layer.cornerRadius = 16
        }
        nextBtn.backgroundColor = UIColor(named: "gray_196")
        nextBtn.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    @IBAction func passionBtnClicked(_ sender: UIButton) {
        if passion == sender.titleLabel?.text {
            sender.backgroundColor = UIColor(named: "gray_245")
            sender.layer.borderWidth = 0
            passion = nil
            nextBtn.backgroundColor = UIColor(named: "gray_196")
            nextBtn.isEnabled = false
        }
        else if passion != nil {
            for i in 0...passionBtns.count-1 {
                if passionBtns[i].titleLabel?.text == passion {
                    passionBtns[i].backgroundColor = UIColor(named: "gray_245")
                    passionBtns[i].layer.borderWidth = 0
                }
            }
            sender.backgroundColor = UIColor(named: "purple_light")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            passion = sender.titleLabel?.text!
            nextBtn.backgroundColor = UIColor(named: "purple_dark")
            nextBtn.isEnabled = true
        }
        else {
            sender.backgroundColor = UIColor(named: "purple_light")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            passion = sender.titleLabel?.text!
            nextBtn.backgroundColor = UIColor(named: "purple_dark")
            nextBtn.isEnabled = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

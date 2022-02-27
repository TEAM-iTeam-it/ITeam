//
//  Join2ViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/02/27.
//

import UIKit

class Join2ViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var detailPartBtn: UITextField!
    @IBOutlet weak var partBtn: UITextField!
    @IBOutlet weak var emailVFLabel: UILabel!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var emailViewNextBtn: UIButton!
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
//        for i in 0...nextBtns.count-1 {
//            nextBtns[i].layer.cornerRadius = 8
//        }
        
        DispatchQueue.main.async {
            if let emailBtn = self.emailViewNextBtn  {
                emailBtn.isHidden = true
                emailBtn.isEnabled = false
            }
            if let label = self.emailVFLabel  {
                label.isHidden = true
            }
            
            // textfield 좌측 공백
            if let email = self.emailTF {
                email.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            }
            if let password = self.passwordTF {
                password.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            }
            if let nickname = self.nicknameTF {
                nickname.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            }
            if let partBtn = self.partBtn, let detailPart = self.detailPartBtn {
                partBtn.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                detailPart.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
            }
            if let profileImage = self.profileImageButton {
                profileImage.layer.borderWidth = 0.5
                profileImage.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
                profileImage.layer.backgroundColor = UIColor(named: "purple_light")?.cgColor
                profileImage.layer.cornerRadius = 75
            }
            
        }

        // Do any additional setup after loading the view.
    }
    // [Keyboard setting] 화면 클릭시 제거
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // [Button action] 이메일 인증
    @IBAction func emailVF(_ sender: UIButton) {
        // firebase 인증
        
        DispatchQueue.main.async {
            sender.isHidden = true
            self.emailViewNextBtn.isHidden = false
            self.emailViewNextBtn.isEnabled = true
            self.emailVFLabel.isHidden = false
            
            self.emailTF.isEnabled = false
        }
    }

    
    
    // [Button action] 이전으로
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
    
    // [Button action] 시작화면으로
    @IBAction func goBackToFirstBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // [Button action] 회원가입 완료 팝업
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "JoinSuccessVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }

}

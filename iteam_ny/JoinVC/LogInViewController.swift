//
//  LogInViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/16.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            idTF.placeholder = "이미 로그인 된 상태입니다."
            passwdTF.placeholder = "이미 로그인 된 상태입니다."
        }
        subLabel.text = ""
        idTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        idTF.layer.cornerRadius = 8
        passwdTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        passwdTF.layer.cornerRadius = 8
        loginBtn.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func logInBtn(_ sender: UIButton) {
        print("로그인 클릭됨")
        Auth.auth().signIn(withEmail: idTF.text!, password: passwdTF.text!) { (user, error) in
            if user != nil{
                print("login success")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarVC = storyboard.instantiateInitialViewController() as? TabarController  {
                   
                    tabBarVC.modalPresentationStyle = .fullScreen
                    self.present(tabBarVC, animated: true, completion: nil)
                }
            }
            else{
                print("login fail")
                print(error?.localizedDescription)
            }
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

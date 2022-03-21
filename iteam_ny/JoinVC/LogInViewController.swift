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
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = Auth.auth().currentUser {
            idTF.placeholder = "이미 로그인 된 상태입니다."
            passwdTF.placeholder = "이미 로그인 된 상태입니다."
        }

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func logInBtn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: idTF.text!, password: passwdTF.text!) { (user, error) in
                    if user != nil{
                        print("login success")
                        let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "passwordVC")
                        passwordVC?.modalPresentationStyle = .overFullScreen
                        self.present(passwordVC!, animated: false, completion: nil)
                    }
                    else{
                        print("login fail")
                        print(error?.localizedDescription)
                    }
              }
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

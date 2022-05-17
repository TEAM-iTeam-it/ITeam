//
//  MyPageModifyViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/27.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MyPageModifyViewController: UIViewController  {

    @IBOutlet weak var positonLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var dataBase: DatabaseReference! //Firebase Realtime Database
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataBase = Database.database().reference().child("user")
        let userID = Auth.auth().currentUser?.uid
        dataBase.child(userID!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let partDetail = value?["partDetail"] as? String ?? ""
            
            self.positonLabel.text = "\(partDetail)"

        }) { error in
          print(error.localizedDescription)
        }
        
        dataBase.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let email = value?["email"] as? String ?? ""
            
            self.emailLabel.text = "\(email)"

        }) { error in
          print(error.localizedDescription)
        }
        
    }
    @IBAction func logoutDidTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("로그아웃됨. 앱이 종료됩니다")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        sleep(2)
        exit(0)
    }
    
}

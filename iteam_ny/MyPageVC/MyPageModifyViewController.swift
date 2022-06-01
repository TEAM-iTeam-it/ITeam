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
import Kingfisher

class MyPageModifyViewController: UIViewController  {

    @IBOutlet weak var positonLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var myimg: UIImageView!
    @IBOutlet weak var myNicknameTextField: UITextField!
    var dataBase: DatabaseReference! //Firebase Realtime Database
    var ref = Database.database().reference().child("user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        let fancyImage = UIImage(systemName:"arrow.left")

        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.configureWithDefaultBackground()
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)

        navigationController?.navigationBar.scrollEdgeAppearance = fancyAppearance
        
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let myname = value?["nickname"] as? String ?? ""
            
            self.myNicknameTextField.text = "\(myname)"

        }) { error in
          print(error.localizedDescription)
        }
        
        let img = Storage.storage().reference().child("user_profile_image/\(Auth.auth().currentUser!.uid).jpg")
        // Fetch the download URL
        img.downloadURL { [self] url, error in
            if let error = error {
            } else {
                myimg.kf.setImage(with: url)
                myimg.layer.cornerRadius = myimg.frame.height/2
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let partDetail = value?["partDetail"] as? String ?? ""
            
            self.positonLabel.text = "\(partDetail)"

        }) { error in
          print(error.localizedDescription)
        }
        
        ref.child(userID!).observeSingleEvent(of: .value, with: { snapshot in
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
    
    @IBAction func saveDidTapped(_ sender: Any) {
        
        //myNicknameTextField.text
        let userID = Auth.auth().currentUser!.uid
        let myNickname = myNicknameTextField.text
        ref.child(userID).child("userProfile").updateChildValues(["nickname":myNickname])
        
        
    }
    
    
    @IBAction func partDidTapped(_ sender: Any) {
        
        guard let MyPartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyPartViewController") as? MyPartViewController else{return}
        MyPartVC.delegate = self // AfterVC에서 생성한 delegate라는 변수를 통해서 델리게이트 지정.
        MyPartVC.modalPresentationStyle = .fullScreen
        present(MyPartVC, animated: true, completion: nil)
        
    
    }
}

extension MyPageModifyViewController: PartDataDelegate {
    func send(_ vc: UIViewController, Input value: String?) {
       // valueLabel.text = value
        let part = ""
        let partDetail = ""
        var partindex = value!.components(separatedBy: ",")
        partindex[0] = part
        partindex[1] = partDetail
    }
}

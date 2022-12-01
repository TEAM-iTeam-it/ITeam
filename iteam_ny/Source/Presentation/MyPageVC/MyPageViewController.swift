//
//  MyPageViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/04/19.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class MyPageViewController: UIViewController{
    var ref: DatabaseReference! //Firebase Realtime Database
       
    @IBOutlet weak var mypurpose: UILabel!
    @IBOutlet weak var mypart: UILabel!
    @IBOutlet weak var mynickName: UILabel!
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var profileView: UIButton!
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        backgroundView.setGradient(color1: UIColor(displayP3Red: 184/255, green: 98/255, blue: 255/255, alpha: 1), color2: UIColor(displayP3Red: 144/255, green: 255/255, blue: 201/255, alpha: 1))
        
        profileView.layer.shadowColor = UIColor.black.cgColor // 색깔
        profileView.layer.borderWidth = 0
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.15
        profileView.layer.shadowRadius = 10
        
            ref = Database.database().reference().child("user")
            
           // 내정보 가져오기
            let currentUser = Auth.auth().currentUser
            ref.child((currentUser?.uid)!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let partDetail = value?["partDetail"] as? String ?? ""
            let nickname = value?["nickname"] as? String ?? ""
                
                self.mypart.text = "\(partDetail) • "
                self.mynickName.text = "\(nickname)"
                
            }) { error in
              print(error.localizedDescription)
            }
        let img = Storage.storage().reference().child("user_profile_image/\(Auth.auth().currentUser!.uid).jpg")
        // Fetch the download URL
        img.downloadURL { [self] url, error in
            if let error = error {
            } else {
                myImg.kf.setImage(with: url)
                myImg.layer.cornerRadius = myImg.frame.height/2
            }
        }
        
        ref.child((currentUser?.uid)!).child("userProfileDetail").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let purpose = value?["purpose"] as? String ?? ""
            
            self.mypurpose.text = "\(purpose)"
            
        }) { error in
          print(error.localizedDescription)
        }
        
        }
    
}

extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.8]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}


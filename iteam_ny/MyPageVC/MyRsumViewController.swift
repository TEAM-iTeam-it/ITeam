//
//  MyRsumViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialBottomSheet

class MyRsumViewController: UIViewController {
   
    @IBOutlet weak var perposeLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var character_3: UITextField!
    @IBOutlet weak var character_2: UITextField!
    @IBOutlet weak var character_1: UITextField!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var contactLink: UITextField!
    @IBOutlet weak var portfolioLabel: UITextField!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var toolNlanguageLabel: UILabel!
    @IBOutlet weak var preferTime: UIButton!
    var projects: [ProjectEx] = []
    var fillCount: Int = 0 {
        willSet(newValue) {
           // if newValue ==
        }
    }
  
    var dataBase: DatabaseReference! //Firebase Realtime Database
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataBase = Database.database().reference().child("user")
        let userID = Auth.auth().currentUser?.uid
        dataBase.child(userID!).child("userProfile").child("portfolio").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let toolNLanguage = value?["toolNLanguage"] as? String ?? ""
            let interest = value?["interest"] as? String ?? ""
            let portfolioLink = value?["portfolioLink"] as? String ?? ""
            let contactLink = value?["contactLink"] as? String ?? ""
            let calltime = value?["calltime"] as? String ?? ""

//            let mycalltime: String = "\(calltime)"
            
            self.interestLabel.text = "\(interest)"
            self.toolNlanguageLabel.text = "\(toolNLanguage)"
            self.contactLink.text = "\(contactLink)"
            self.portfolioLabel.text = "\(portfolioLink)"
            self.preferTime.setTitle("\(calltime)", for: .normal)
            self.preferTime.setTitleColor(UIColor.black, for: .normal)

        }) { error in
          print(error.localizedDescription)
        }

        dataBase.child(userID!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let nickname = value?["nickname"] as? String ?? ""
            let partDetail = value?["partDetail"] as? String ?? ""


            self.partLabel.text = "\(partDetail)"
            self.nickName.text = "\(nickname)"

        })
        dataBase.child(userID!).child("userProfileDetail").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let purpose = value?["purpose"] as? String ?? ""
            let character = value?["character"] as? String ?? ""

            let charindex = character.components(separatedBy: ", ")

            self.perposeLabel.text = "\(purpose)"
            self.character_1.text = charindex[0]
            self.character_2.text = charindex[1]
            self.character_3.text = charindex[2]

        })

    }

}

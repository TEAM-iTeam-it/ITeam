//
//  resetViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetViewController: UIViewController {
    @IBOutlet weak var activeZoneLabel: UILabel!
    @IBOutlet weak var wantGradeLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    var dataBase: DatabaseReference! //Firebase Realtime Database
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        let fancyImage = UIImage(systemName:"arrow.left")

        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.backgroundColor = UIColor.white
        //fancyAppearance.configureWithDefaultBackground()
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)

        navigationController?.navigationBar.scrollEdgeAppearance = fancyAppearance
        dataBase = Database.database().reference().child("user")
        let userID = Auth.auth().currentUser?.uid
        dataBase.child(userID!).child("userProfileDetail").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let activeZone = value?["activeZone"] as? String ?? ""
            let character = value?["character"] as? String ?? ""
            let purpose = value?["purpose"] as? String ?? ""
            let wantGrade = value?["wantGrade"] as? String ?? ""
            
            self.activeZoneLabel.text = "\(activeZone)"
            self.wantGradeLabel.text = "\(wantGrade)"
            self.purposeLabel.text = "\(purpose)"
            self.characterLabel.text = "\(character)"

        }) { error in
          print(error.localizedDescription)
        }
        
    }
}

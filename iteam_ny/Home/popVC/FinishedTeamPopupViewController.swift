//
//  FinishedTeamPopupViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/05/29.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FinishedTeamPopupViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 16
        
    }
    
    
    @IBAction func onClickedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickedYes(_ sender: Any) {
        let userUID = Auth.auth().currentUser!.uid
        Database.database().reference().child("user").child(userUID).child("userTeam").setValue("")
        
        self.dismiss(animated: true, completion: nil)
    }
}

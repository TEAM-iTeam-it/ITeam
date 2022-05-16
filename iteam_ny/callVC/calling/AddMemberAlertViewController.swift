//
//  AddMemberAlertViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddMemberAlertViewController: UIViewController {
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var okayBtn: UIButton!
    
    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    var otherPersonUID: String = ""
    var userUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okayBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        
        userUID = Auth.auth().currentUser!.uid
    }
    @IBAction func sendFriendRequestAction(_ sender: UIButton) {
        sendFriendRequest()
        let evaluVC = storyboard?.instantiateViewController(withIdentifier: "evaluVC") as! EvaluateViewController
        evaluVC.modalPresentationStyle = .fullScreen
        evaluVC.didFriendRequest = true
        evaluVC.otherPersonUID = otherPersonUID
        present(evaluVC, animated: true)
        
    }
    func currentDateTime() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        var currentDateString = formatter.string(from: Date())

        return currentDateString
        
    }
    // 친구요청
    func sendFriendRequest() {
        ref = Database.database().reference()
        
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        var index: String = ""
        ref = Database.database().reference()
        ref.child("user").child(otherPersonUID).child("friendRequest").observeSingleEvent(of: .value) { [self] snapshot in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                index = "\(snapshots.count)"
                let valueUID = ["requestUID" : userUID]
                let valueTime = ["requestTime" : currentDateTime()]
                let valueStmt = ["requestStmt" : "요청"]
                
                // 요청한 시간과 함께 넘겨주기
                let dataPath = ref.child("user").child(otherPersonUID).child("friendRequest").child(index)
                dataPath.updateChildValues(valueUID)
                dataPath.updateChildValues(valueTime)
                dataPath.updateChildValues(valueStmt)
            }
        }
    }
    
}

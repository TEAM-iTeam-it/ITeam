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
    @IBAction func addFriendList(_ sender: UIButton) {
        addFriend()
        let evaluVC = storyboard?.instantiateViewController(withIdentifier: "evaluVC") as! EvaluateViewController
        evaluVC.modalPresentationStyle = .fullScreen
        present(evaluVC, animated: true)
        
    }
    func addFriend() {
        ref = Database.database().reference()
        
        var updateGiverUid: [String] = []
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        ref.child("user").child(otherPersonUID).child("friendRequest").observeSingleEvent(of: .value) { [self] snapshot in
          
            var lastData: [String]? = snapshot.value as? [String]
            if lastData == nil || lastData == [] {
                print("상대에게 내 요청이 없을 때")
                updateGiverUid.append(userUID)
                // 데이터 추가
                ref.child("user").child(otherPersonUID).child("friendRequest").setValue(updateGiverUid)
                
            }
            else {
                print("이미 내가 상대에게 요청했을 때")
                if !lastData!.contains(userUID) {
                    lastData?.append(userUID)
                    updateGiverUid = lastData!
                    // 데이터 추가
                    ref.child("user").child(otherPersonUID).child("friendRequest").setValue(updateGiverUid)
                }
            }
            
            // giverList에 나에게 요청건 사람 uid 받아와짐
            var giverList: [String] = []
            fetchFreindRequest()
            
            func fetchFreindRequest() {
                ref.child("user").child(userUID).observeSingleEvent(of: .value){ snapshot in
                    guard let snapData = snapshot.value as? [String:Any] else {return}
                    for key in snapData.keys {
                        if key == "friendRequest" {
                            for k in snapData.values {
                                if k is [String] {
                                    giverList = (k as? [String])!
                                    print(giverList)
                                }
                            }
                        }
                    }
                }
            }
            
            
            
            
            
        }
        
        
    }
    
}

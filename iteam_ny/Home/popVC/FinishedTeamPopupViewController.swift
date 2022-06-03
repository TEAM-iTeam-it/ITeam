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
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 16
        
    }
    
    
    @IBAction func onClickedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickedYes(_ sender: Any) {
        
        let emptyCurrentTeam: [String:String] = ["currentTeam":""]
        let emptyLikeTeam: [String:String] = ["teamName":""]
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("friendsList").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("friendRequest").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("likeTeam").setValue(emptyLikeTeam)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").removeValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let currentDateString = formatter.string(from: Date())
        
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestStmt").setValue("기본")
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestTime").setValue(currentDateString)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestUID").setValue("기본")
        
        let emptyUserTeam: [String:String] = ["userTeam":""]
        
        db.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(emptyUserTeam)
   
        
        // call에서 본인 기록 있으면 찾아서 삭제
        var callIndex: String = ""
        db.child("Call").observeSingleEvent(of: .value) { [self] (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                callIndex = "\(snapshots.count)"
                for i in 9...(Int(callIndex) ?? 9) {
                    db.child("Call").child(String(i)).removeValue()
                }
                
            }
        }
        
        // 리더일 때 팀 삭제
        db.child("user").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                if snap.key == "currentTeam" {
                    let teamname: String = snap.value as? String ?? ""
                    if teamname != nil && teamname != "" {
                        self.db.child("Team").child(teamname).observeSingleEvent(of: .value) { snapshot in
                            
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let value = snap.value as? String
                                // 내가 리더일 때 팀 삭제
                                if snap.key == "leader" {
                                    if value == Auth.auth().currentUser!.uid {
                                        print("리더")
                                        self.db.child("Team").child(teamname).removeValue()
                                        break
                                    }
                                }
                            }
                        }
                    }
        
                }
            }
        }
        db.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(emptyCurrentTeam)
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
}

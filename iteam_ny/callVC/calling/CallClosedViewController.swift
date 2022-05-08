//
//  CallClosedViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit
import FirebaseDatabase

class CallClosedViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    var otherPersonUID: String = ""
    var amILeader: Bool = false
    let db = Database.database().reference()
    var othersNickname: String = "" {
        willSet(newValue) {
            DispatchQueue.main.async {
                self.friendExnplainLabel.text = newValue + " 님을 친구로 추가하시겠습니까?"
            }
        }
    }
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var friendExnplainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        noBtn.layer.cornerRadius = 8
        yesBtn.layer.cornerRadius = 8
        
        fetchNickname(userUID: otherPersonUID)

    }
    func fetchNickname(userUID: String)  {
        let userdb = db.child("user").child(userUID)
     
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                if snap.key == "userProfile" {
                    for (key, content) in value! {
                        if key as! String == "nickname" {
                            othersNickname = content as! String
                           
                        }
                    }
                }
            }
        }
    }
    // 친구 요청 팝업
    @IBAction func sendAddMemberMessage(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "AddMemberAlertVC") as! AddMemberAlertViewController
        print("callclosed : \(otherPersonUID) ")
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

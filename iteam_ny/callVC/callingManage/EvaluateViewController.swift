//
//  EvaluateViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/04.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EvaluateViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var evaluateBtns: [UIButton]!
    @IBOutlet weak var nextBtn: UIButton!
    var selectedBtn: [String] = []
    var otherPersonUID: String = ""
    let db = Database.database().reference()
    var otherPersonName: String = "" {
        willSet(newValue) {
            DispatchQueue.main.async {
                self.titleLabel.text = "\(newValue) 님과의 통화가 어땠나요?"
            }
        }
    }
    var didFriendRequest: Bool = false
    
    @IBOutlet var evaluLabel: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 8
        
        fetchNickname(userUID: otherPersonUID)
    }
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if didFriendRequest {
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)            
        }
        else {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)     
        }
        
    }
    @IBAction func evaluateBtn(_ sender: UIButton) {
   
        if sender.isSelected == true {
            sender.isSelected = false
           sender.setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "gray_light2")
            selectedBtn.removeAll()
            
        }
        else {
            if selectedBtn.count >= 1 {
                for i in 0...evaluateBtns.count-1 {
                    evaluateBtns[i].isSelected = false
                    evaluateBtns[i].setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    evaluateBtns[i].tintColor = UIColor(named: "gray_light2")
                    selectedBtn.removeAll()
                }
            }
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "purple_184")
            switch sender {
            case evaluateBtns[0]:
                selectedBtn.append(evaluLabel[0].text!)
            case evaluateBtns[1]:
                selectedBtn.append(evaluLabel[1].text!)
            case evaluateBtns[2]:
                selectedBtn.append(evaluLabel[2].text!)
            case evaluateBtns[3]:
                selectedBtn.append(evaluLabel[3].text!)
            default:
                selectedBtn.append(evaluLabel[4].text!)
                
            }
          
        }
        print(selectedBtn)
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
                            otherPersonName = content as! String
                           
                        }
                    }
                }
            }
        }
    }

}

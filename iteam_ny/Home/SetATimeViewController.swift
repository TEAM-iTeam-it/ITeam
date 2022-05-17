//
//  SetATimeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialBottomSheet

class SetATimeViewController: UIViewController{
    var senderid : String = ""
    var ref: DatabaseReference!
    
//    @IBOutlet var TimeBtns: [UIButton]!
    
    @IBOutlet weak var candidateLabel_3: UILabel!
    @IBOutlet weak var candidateLabel_2: UILabel!
    @IBOutlet weak var candidateBtn_1: UILabel!
    @IBOutlet weak var selectTime_3: UIButton!
    @IBOutlet weak var selectTime_2: UIButton!
    @IBOutlet weak var selectTime_1: UIButton!
    var selectTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        candidateBtn_1.isHidden = true
        candidateLabel_2.isHidden = true
        candidateLabel_3.isHidden = true
        selectTime_3.layer.cornerRadius = 8
        selectTime_2.layer.cornerRadius = 8
        selectTime_1.layer.cornerRadius = 8
        
    }
    @IBOutlet var Buttons: Array<UIButton>!
    
    //첫번째, 두번째 세번째버튼을 선택했을 때
    @IBAction func btnClicked(_ sender: UIButton) {
        
        let btnNumber = Buttons.firstIndex(of: sender)
        print("cardNumber = \(btnNumber)")
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1 = stroyboard.instantiateViewController(withIdentifier: "SendTimePickerView") as! SendTimePickerView
        vc1.dataN = btnNumber!
        vc1.delegate = self
       
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc1)
        present(bottomSheet, animated: true, completion: nil)

        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 300
    }
    
    //다음 버튼 클릭했을때
    @IBAction func TimeNextBtn(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        var callTimeString: String = ""
        var first: String = ""
        var second: String = ""
        var third: String = ""
        first = selectTime_1.currentTitle!
        second = selectTime_2.currentTitle!
        third = selectTime_3.currentTitle!
        callTimeString = "\(first), " + "\(second), " + "\(third)"
        
        let callTime: [String: String] = [ "callTime": callTimeString]
        let callerUid: [String: String] = ["callerUid": user.uid]
        let receiverNickname: [String: String] = ["receiverNickname": senderid]
        var Index: String = ""
        ref = Database.database().reference()
        ref.child("Call").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                print(snapshots.count)
                Index = "\(snapshots.count)"
                self.ref.child("Call").child(Index).updateChildValues(callTime)
                self.ref.child("Call").child(Index).updateChildValues(callerUid)
                self.ref.child("Call").child(Index).updateChildValues(receiverNickname)
            }
            guard let vc = self.storyboard?.instantiateViewController(identifier: "QuestionViewController") as? QuestionViewController else {
                        return
                    }
                    vc.IndexN = Index
                    self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
extension SetATimeViewController: SendTimeDataDelegate {
    func SendTimeData(data: String) {
        let dhdh: String = "\(data)"
        let index = dhdh.index(dhdh.startIndex, offsetBy: 3)
        var result = dhdh.substring(from: index)
       
        if dhdh.contains("첫번째"){
            self.selectTime_1.setTitle(result, for: .normal)
            self.selectTime_1.setTitleColor(UIColor.black, for: .normal)
            
            candidateBtn_1.isHidden = false
            candidateBtn_1.layer.cornerRadius = 10
            
            selectTime_1.backgroundColor = .white
            selectTime_1.layer.borderWidth = 0
            selectTime_1.layer.borderColor = UIColor.black.cgColor
            selectTime_1.layer.shadowColor = UIColor.black.cgColor
            selectTime_1.layer.shadowOffset = CGSize(width: 0, height: 0)
            selectTime_1.layer.shadowOpacity = 0.2
            selectTime_1.layer.shadowRadius = 10
            selectTime_1.layer.masksToBounds = false
        }
        if dhdh.contains("두번째"){
            self.selectTime_2.setTitle(result, for: .normal)
            self.selectTime_2.setTitleColor(UIColor.black, for: .normal)
            
            candidateLabel_2.isHidden = false
            candidateLabel_2.layer.cornerRadius = 10
            
            
            selectTime_2.backgroundColor = .white
            selectTime_2.layer.borderWidth = 0
            selectTime_2.layer.borderColor = UIColor.black.cgColor
            selectTime_2.layer.shadowColor = UIColor.black.cgColor
            selectTime_2.layer.shadowOffset = CGSize(width: 0, height: 0)
            selectTime_2.layer.shadowOpacity = 0.2
            selectTime_2.layer.shadowRadius = 10
            selectTime_2.layer.masksToBounds = false
        }
        if dhdh.contains("세번째"){
            self.selectTime_3.setTitle(result, for: .normal)
            self.selectTime_3.setTitleColor(UIColor.black, for: .normal)
            
            candidateLabel_3.isHidden = false
            candidateLabel_3.layer.cornerRadius = 10
            
            selectTime_3.backgroundColor = .white
            selectTime_3.layer.borderWidth = 0
            selectTime_3.layer.borderColor = UIColor.black.cgColor
            selectTime_3.layer.shadowColor = UIColor.black.cgColor
            selectTime_3.layer.shadowOffset = CGSize(width: 0, height: 0)
            selectTime_3.layer.shadowOpacity = 0.2
            selectTime_3.layer.shadowRadius = 10
            selectTime_3.layer.masksToBounds = false
        }
    
    }
}

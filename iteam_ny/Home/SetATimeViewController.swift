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
    @IBOutlet weak var selectTime_3: UIButton!
    @IBOutlet weak var selectTime_2: UIButton!
    @IBOutlet weak var selectTime_1: UIButton!
    var selectTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        if dhdh.contains("두번째"){
            self.selectTime_2.setTitle(result, for: .normal)
            self.selectTime_2.setTitleColor(UIColor.black, for: .normal)
        }
        if dhdh.contains("세번째"){
            self.selectTime_3.setTitle(result, for: .normal)
            self.selectTime_3.setTitleColor(UIColor.black, for: .normal)
        }
    
    }
}
//selected = true
//for i in 0..<buttons.count {
//    buttons[i].backgroundColor = UIColor(named: "gray_245")
//    buttons[i].layer.borderWidth = 0
//    timeLabel[i].textColor = UIColor(named: "gray_121")
//    selectNumLabel[i].textColor = UIColor(named: "gray_121")
//    selectNumLabel[i].backgroundColor = UIColor(named: "gray_229")
//
//}
//sender.backgroundColor = UIColor(named: "green_243")
//sender.layer.borderWidth = 0.5
//sender.layer.borderColor = UIColor(named: "green_87")?.cgColor
//
//
//if sender == firstButton {
//    timeLabel[0].textColor = UIColor(named: "green_87")
//    selectNumLabel[0].textColor = .white
//    selectNumLabel[0].backgroundColor = UIColor(named: "green_87")
//    selectedTime = timeLabel[0].text!
//}
//else if sender == secondButton {
//    timeLabel[1].textColor = UIColor(named: "green_87")
//    selectNumLabel[1].textColor = .white
//    selectNumLabel[1].backgroundColor = UIColor(named: "green_87")
//    selectedTime = timeLabel[1].text!
//}
//else {
//    timeLabel[2].textColor = UIColor(named: "green_87")
//    selectNumLabel[2].textColor = .white
//    selectNumLabel[2].backgroundColor = UIColor(named: "green_87")
//    selectedTime = timeLabel[2].text!
//}

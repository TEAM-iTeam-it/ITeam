//
//  TeamCallRequestQuestionViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/03.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class TeamCallRequestQuestionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var selectBtns: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    var addQuestionArr: [String] = [""]
    var defaultQuestionArr: [String] = ["프로젝트를 하는 목적이 무엇인가요?", "하고 싶은 주제가 있으신가요?", "주로 작업하는 시간대가 어떻게 되시나요?", "병행하고 있는 활동이 있으신가요?", "주 사용 툴 혹은 언어는 무엇인가요?", "이번 프로젝트에서 맡고 싶은 역할이 있으신가요?"]
    var resultQuestionArr: [String] = []
    var defualtQuestionSelectBoolArr: [Bool] = [false, false, false, false, false, false]
    var keyHeight: CGFloat?
    var questionCount = QuestionCount.shared.count
    let db = Database.database().reference()
    var callIndex: String = ""
    var dateTimes: [String] = []
    var receiverNickname: String = ""
    var receiverType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        tableView.delegate = self
        tableView.dataSource = self
        
        saveButton.layer.cornerRadius = 8
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor(named: "gray_196")
        
        titleLabel.text = "\(receiverNickname)의 무엇이 궁금한가요?"
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selectQuestionBtnAction(_ sender: UIButton) {
        
        
        func setTrueButton() {
            sender.tintColor = UIColor(named: "purple_184")
           // sender.setImage(UIImage(named: "checkmark.circle.fill"), for: .normal)
        }
        func setFalseButton() {
            sender.tintColor = UIColor(named: "gray_229")
            //sender.setImage(UIImage(named: "checkmark.circle"), for: .normal)
        }
        
        // 5개 제한
        print(resultQuestionArr.count)
        print(defaultQuestionArr.count)
        
            switch sender {
            case selectBtns[0]:
                if defualtQuestionSelectBoolArr[0] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[0] = true
                        resultQuestionArr.append(defaultQuestionArr[0])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[0] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[0] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            case selectBtns[1]:
                if defualtQuestionSelectBoolArr[1] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[1] = true
                        resultQuestionArr.append(defaultQuestionArr[1])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[1] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[1] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            case selectBtns[2]:
                if defualtQuestionSelectBoolArr[2] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[2] = true
                        resultQuestionArr.append(defaultQuestionArr[2])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[2] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[2] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            case selectBtns[3]:
                if defualtQuestionSelectBoolArr[3] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[3] = true
                        resultQuestionArr.append(defaultQuestionArr[3])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[3] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[3] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            case selectBtns[4]:
                if defualtQuestionSelectBoolArr[4] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[4] = true
                        resultQuestionArr.append(defaultQuestionArr[4])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[4] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[4] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            default:
                if defualtQuestionSelectBoolArr[5] == false {
                    if resultQuestionArr.count <= 4 {
                        defualtQuestionSelectBoolArr[5] = true
                        resultQuestionArr.append(defaultQuestionArr[5])
                        setTrueButton()
                        questionCount += 1
                    }
                }
                else {
                    defualtQuestionSelectBoolArr[5] = false
                    for i in 0..<resultQuestionArr.count {
                        if resultQuestionArr[i] == defaultQuestionArr[5] {
                            resultQuestionArr.remove(at: i)
                            questionCount -= 1
                            break
                        }
                    }
                    setFalseButton()
                }
            }
        
        if resultQuestionArr.count >= 1 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(named: "purple_184")
        }
        else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(named: "gray_196")
        }
        print(resultQuestionArr)
        
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        db.child("Call").observeSingleEvent(of: .value) { [self] (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                print(snapshots.count)
                callIndex = "\(snapshots.count)"
                var callTimeString: String = ""
                var questionString: String = ""
                for i in 0..<dateTimes.count {
                    if i == 0 {
                        callTimeString += "\(dateTimes[i])"
                    }
                    else {
                        callTimeString += ", \(dateTimes[i])"
                    }
                }
                for i in 0..<resultQuestionArr.count {
                    if i == 0 {
                        questionString += "\(resultQuestionArr[i])"
                    }
                    else {
                        questionString += ", \(resultQuestionArr[i])"
                    }
                }
                
            
                let callTime: [String: String] = [ "callTime": callTimeString]
                let callerUid: [String: Any] = ["callerUid": Auth.auth().currentUser?.uid]
                let receiverNickname: [String: String] = ["receiverNickname": receiverNickname]
                let receiverType: [String: String] = ["receiverType": receiverType]
                let question: [String: String] = ["Question": questionString]
                let stmt: [String: String] = ["stmt": "요청됨"]
                
                db.child("Call").child(callIndex).updateChildValues(callTime)
                db.child("Call").child(callIndex).updateChildValues(callerUid)
                db.child("Call").child(callIndex).updateChildValues(receiverNickname)
                db.child("Call").child(callIndex).updateChildValues(receiverType)
                db.child("Call").child(callIndex).updateChildValues(question)
                db.child("Call").child(callIndex).updateChildValues(stmt)
            }
        }
        let popupView = storyboard?.instantiateViewController(withIdentifier: "endPopUpVC") as! TeamCallRequestPopupViewController
        popupView.modalPresentationStyle = .overFullScreen
        self.present(popupView, animated: false, completion: nil)
    }
    
}
extension TeamCallRequestQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! TeamQuestionTableViewCell
        cell.delegate = self
        cell.delegate2 = self
        
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addQuestionArr.count
    }
    
    
    //키보드 올라갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillShow(_ sender:Notification){
            self.view.frame.origin.y = -150
    }
    //키보드 내려갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillHide(_ sender:Notification){
            self.view.frame.origin.y = 0
    }
}

extension TeamCallRequestQuestionViewController: SendAddQuestionDataDelegate {
    func sendAddQuestionSignal() {
        addQuestionArr.append("")
        tableView.reloadData()
    }
}
extension TeamCallRequestQuestionViewController: SendButtonDataDelegate {
    func sendAddData(data: String) {
        if resultQuestionArr.count < 5 {
            resultQuestionArr.append(data)
            print(resultQuestionArr)
        }
        if resultQuestionArr.count >= 1 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(named: "purple_184")
        }
        else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(named: "gray_196")
        }
    }
    
    func sendRemoveData(data: String) {
        for i in 0..<resultQuestionArr.count {
            if resultQuestionArr[i] == data {
                resultQuestionArr.remove(at: i)
                print(resultQuestionArr)
                break
            }
        }
        if resultQuestionArr.count >= 1 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(named: "purple_184")
        }
        else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(named: "gray_196")
        }
    }
    
   
}


class QuestionCount {
    static let shared = QuestionCount()

    var count: Int = 0

    private init() { }
}


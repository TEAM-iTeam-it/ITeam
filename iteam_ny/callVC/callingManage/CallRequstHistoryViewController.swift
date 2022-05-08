//
//  CallRequstHistoryViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CallRequstHistoryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sameSchoolLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet var callTimeLabels: [UILabel]!
    @IBOutlet weak var questionTableview: UITableView!
    
    var personUID: String = ""
    let db = Database.database().reference()
    var person = Person(nickname: "", position: "", callStm: "", profileImg: "")
    var callTime: [String] = []
    var questionArr: [String] = []
    var teamIndex: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fetchUser(userUID: personUID, stmt: "요청됨")
        setUI()
        questionTableview.delegate = self
        questionTableview.dataSource = self
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func callRequestCancelAction(_ sender: UIButton) {
        let values: [String: String] = [ "stmt": "요청취소됨" ]
        db.child("Call").child(teamIndex).updateChildValues(values)
        self.dismiss(animated: false, completion: nil)
    }
    
    func setUI() {
        sameSchoolLabel.layer.borderWidth = 0.5
        sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
        sameSchoolLabel.textColor = UIColor(named: "purple_184")
        
        sameSchoolLabel.layer.cornerRadius = sameSchoolLabel.frame.height/2
        sameSchoolLabel.text = "같은 학교"
        
        profileView.layer.borderWidth = 0
        profileView.layer.cornerRadius = 24
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.2
        profileView.layer.shadowRadius = 8.0
        
        
        titleLabel.text = "\(person.nickname) 님이 요청을 확인 중입니다."
        nickNameLabel.text = person.nickname
        infoLabel.text = person.position
        
        for i in 0..<callTime.count {
            if callTime[i].contains("0분") {
                callTimeLabels[i].text = callTime[i].replacingOccurrences(of: "0분", with: "")
            }
            else {
                callTimeLabels[i].text = callTime[i]
                
            }
        }
        
    }
    
    
}
extension CallRequstHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! CallRequestHistoryQuestionTableViewCell
        cell.questionLabel.text = questionArr[indexPath.row]
        return cell
    }
}


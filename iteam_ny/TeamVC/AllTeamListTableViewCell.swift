//
//  AllTeamListTableViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AllTeamListTableViewCell: UITableViewCell {


    @IBOutlet weak var teamProfileLabel: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var part: UILabel!
    @IBOutlet weak var circleTitleView: GradientView!
    @IBOutlet weak var favorButton: UIButton!
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser!
    var likeBool: Bool = false {
        willSet(newValue) {
            if newValue {
                favorButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favorButton.tintColor = UIColor(named: "purple_184")
            }
            else {
                favorButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favorButton.tintColor = UIColor(named: "gray_196")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    @IBAction func favorBtnAction(_ sender: UIButton) {
        if likeBool {
            likeBool = false
            removeDataAcion()
        }
        else {
            likeBool = true
            pullDataAcion()
        }
    }
    // 관심있는 팀에 추가
    func pullDataAcion() {
        var updateString: String = ""
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            var lastDatas: [String] = []
            let lastData: String! = snapshot.value as? String
            lastDatas = lastData.components(separatedBy: ", ")
            if !lastDatas.contains(self.teamName.text!) {
                if snapshot.value as? String == nil || snapshot.value as? String == "" {
                    var lastData: String! = snapshot.value as? String
                    updateString = self.teamName.text!
                }
                else {
                    var lastData: String! = snapshot.value as? String
                    lastData += ", \(self.teamName.text!)"
                    updateString = lastData
                }
                let values: [String: Any] = [ "teamName": updateString ]
                // 데이터 추가
                self.ref.child("user").child(self.user.uid).child("likeTeam").updateChildValues(values)
            }
        }
    }
    
    // 관심있는 팀에서 삭제
    func removeDataAcion() {
        var updateString: String = ""
        var lastDatas: [String] = []
        
        // 데이터 받아와서 이미 있으면 지워주기
        ref.child("user").child(user.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) {snapshot in
            if snapshot.value as? String != nil {
                var lastData: String! = snapshot.value as? String
                lastDatas = lastData.components(separatedBy: ", ")
                
                print(lastDatas)
                for i in 0..<lastDatas.count {
                    print(i)
                    if lastDatas[i] == self.teamName.text! {
                        print(i)
                        lastDatas.remove(at: i)
                        break
                    }
                }
                for i in 0..<lastDatas.count {
                    if lastDatas[i] == "" {
                        lastDatas.remove(at: i)
                        break
                    }
                    if i == 0 {
                        updateString += lastDatas[i]
                    }
                    else {
                        updateString += ", \(lastDatas[i])"
                    }
                }
            }
            let values: [String: Any] = [ "teamName": updateString ]
            // 데이터 추가
            self.ref.child("user").child(self.user.uid).child("likeTeam").updateChildValues(values)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

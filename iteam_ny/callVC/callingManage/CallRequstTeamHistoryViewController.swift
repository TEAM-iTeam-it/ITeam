//
//  CallRequstTeamHistoryViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/07.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class CallRequstTeamHistoryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileImageCollectionView: UICollectionView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    @IBOutlet var callTimeLabels: [UILabel]!
    @IBOutlet weak var questionTableview: UITableView!
    
    var personUID: String = ""
    let db = Database.database().reference()
    var team = Team(teamName: "", purpose: "", part: "", images: [])
    var leader = Person(nickname: "", position: "", callStm: "", profileImg: "")
    var teamFormatPerson = Person(nickname: "", position: "", callStm: "", profileImg: "")
    var callTime: [String] = []
    var questionArr: [String] = []
    var teamIndex: String = ""

    var teamImageData: [Data] = []
    var resizedImage: UIImage = UIImage()
    var memberList: [String] = []
    var teamMemberUid: [String] = [] {
        willSet {
            profileImageCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()

        
        
        //fetchUser(userUID: personUID, stmt: "요청됨")
        setUI()
        questionTableview.delegate = self
        questionTableview.dataSource = self
        
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func callRequestCancelAction(_ sender: UIButton) {
        let values: [String: String] = [ "stmt": "요청취소됨" ]
        db.child("Call").child(teamIndex).updateChildValues(values)
        self.dismiss(animated: false, completion: nil)
    }
    func setData() {
        team = Team(teamName: teamFormatPerson.nickname, purpose: "", part: teamFormatPerson.position, images: [])
        
        fetchTeam()
        fetchTeamUid()
    }
    

    // 리더 이름, 멤버 uid 받아오기
    func fetchTeam() {
        let favorTeamList = db.child("Team").child(team.teamName)
        
        favorTeamList.observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let values = snapshot.value
            let dic = values as! [String: String]
            for i in dic.keys {
                if i == "memberList" {
                    let memberListString = dic["memberList"] as! String
                    memberList = memberListString.components(separatedBy: ", ")
                    print(memberList)
                }
                if i == "leader" {
                    guard let leaderuid = dic["leader"] else {
                        return
                    }
                    fetchNickname(userUID: leaderuid)
                }
            }
        })
    }
    func fetchTeamUid() {
        let userdb = db.child("Team").child(team.teamName)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var memberString: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? String
                
                if snap.key == "memberList" {
                    memberString = value ?? ""
                    teamMemberUid = memberString.components(separatedBy: ", ")
                }
            }
        }
    }
    
    // uid로 user 닉네임 반환
    func fetchNickname(userUID: String)  {
        let userdb = db.child("user").child(userUID)
     
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                if snap.key == "userProfile" {
                    for (key, content) in value! {
                        if key as! String == "nickname" {
                            leader.nickname = content as! String
                            DispatchQueue.main.async {
                                self.titleLabel.text = self.leader.nickname
                            }
                           
                        }
                    }
                }
            }
        }
    }
    
    func setUI() {
        
        profileView.layer.borderWidth = 0
        profileView.layer.cornerRadius = 24
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.2
        profileView.layer.shadowRadius = 8.0
        
        
        titleLabel.text = leader.nickname
        nickNameLabel.text = team.teamName + " 팀"
        infoLabel.text = team.part
        
        for i in 0..<callTime.count {
            if callTime[i].contains("00분") {
                callTimeLabels[i].text = callTime[i].replacingOccurrences(of: "00분", with: "")
            }
            else {
                callTimeLabels[i].text = callTime[i]
                
            }
        }
        
    }

}
extension CallRequstTeamHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! CallRequestHistoryQuestionTableViewCell
        cell.questionLabel.text = questionArr[indexPath.row]
        return cell
    }
}
extension CallRequstTeamHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if teamMemberUid.count <= 3 {
            return teamMemberUid.count
        }
        else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 커스텀 셀 따로 만들지 않고 어차피 이미지만 들어간 셀이라 그냥 사용
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailTeamProfileCell", for: indexPath) as! TeamProfileImageCollectionViewCell
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
        cell.userImage.layer.masksToBounds = true
        cell.layer.masksToBounds = true
        cell.userImage.backgroundColor = .clear
        cell.userImage.isHidden = false
        cell.gradientView.layer.cornerRadius =  cell.gradientView.frame.height/2
        cell.gradientView.layer.masksToBounds = true
        cell.gradientView.isHidden = true
        
        
        // kingfisher 사용하기 위한 url
        let uid: String = teamMemberUid[indexPath.row]
        print(uid)
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        starsRef.downloadURL { [self] url, error in
            if let error = error {
                cell.userImage.image = UIImage()
            } else {
                cell.userImage.kf.setImage(with: url)
            }
        }
        
        // Fetch the download URL
        if teamMemberUid.count > 3  {
            if indexPath.row == 2 {
                cell.userImage.isHidden = true
                cell.gradientView.isHidden = false
                cell.memberCountLabel.text = "+\(teamMemberUid.count-2)"
            }
        }
            
        
        // 셀 디자인 및 데이터 세팅
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
    
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    
}
extension CallRequstTeamHistoryViewController: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -20.0
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 74
        let height = 74
        

        let size = CGSize(width: width, height: height)
        return size
    }
    
    // 중앙 정렬
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth = 74
        let spacingWidth = -10
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let cellSpacingWidth = numberOfItems * spacingWidth
        let totalCellWidth = numberOfItems * itemWidth + cellSpacingWidth
        let inset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 5, left: inset, bottom: 5, right: inset)
    }
}

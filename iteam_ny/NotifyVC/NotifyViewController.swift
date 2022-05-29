//
//  NotifyViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/04.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class NotifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notifyTableView: UITableView!
    var ref: DatabaseReference!
    let db = Database.database().reference()
    var giverList: [String] = []
    var friendList: [Friend] = []
    var friendUid:[String] = []
    var friendUid2:[String] = []
    var memberUid:[String] = []
    var memberUid2:[String] = []
    var requestUID = ""
    var requestStmt = ""
    var requestTime = ""
    var nickname: String = ""
    var allInfo = ""
    var memberInfo = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        notifyTableView.separatorStyle = .none
        fetchMemberData()
        fetchChangedData()
    }
    
    func removeArr() {
        
        friendList.removeAll()
        requestNum.removeAll()
        memberUid.removeAll()
        memberUid2.removeAll()
        friendUid.removeAll()
        friendUid2.removeAll()
        memberInfo.removeAll()
        allInfo.removeAll()
//        Index.removeAll()
    }
    
    func fetchChangedData() {
//        friendList.removeAll()
        removeArr()
        db.child("user").child(Auth.auth().currentUser!.uid).child("friendRequest").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨 친구")
            DispatchQueue.main.async {
                self.fetchMemberData()
            }
        })
        removeArr()
        db.child("user").child(Auth.auth().currentUser!.uid).child("memberRequest").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨 멤버")
            DispatchQueue.main.async {
                self.fetchMemberData()
            }
        })
        
        

    }
//    func fetchChangedData2(){
//        removeArr()
//
//    }
    
    //팀원 수락 요청 가져오기
    var requestNum = ""
    func fetchMemberData() {
//        friendList.removeAll()
        removeArr()
        let userdb = db.child("user").child(Auth.auth().currentUser!.uid)
        let userUID = Auth.auth().currentUser!.uid
            
            let memberRequestList = db.child("user").child(userUID).child("memberRequest")
            //queryEqual(toValue: myNickname)
        memberRequestList.observeSingleEvent(of: .value) { [self] snapshot in
            
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    requestNum = snap.key
                    let value = snap.value as? NSDictionary
//                    print (value)
                    
                    requestTime = value?["requestTime"] as? String ?? ""
                    requestStmt = value?["requestStmt"] as? String ?? ""
                    requestUID = value?["requestUID"] as? String ?? ""
                    memberInfo = (requestUID+","+requestStmt+","+requestTime)
//                    if memberInfo.contains("요청"){
                        memberUid.append(memberInfo)
//                    }
                }
                
                for uid in self.memberUid{
                    self.memberUid2.append(uid)
                    print(uid + "빙글빙글")
                    let charindex = uid.components(separatedBy: ",")
                    //friendList.append(contentsOf: <#T##Sequence#>)
                    self.db.child("user").child(charindex[0]).observeSingleEvent(of: .value) { [self] snapshot in
                        var nickname: String = ""

                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let value = snap.value as? NSDictionary

                            if snap.key == "userProfile" {
                                for (key, content) in value! {
                                    if key as! String == "nickname" {
                                        nickname = content as! String
                                    }
                                }
                            }
                        }
                        print("a")
                        print(nickname)
                        print(charindex[0])
                        print(charindex[1])
                        print(charindex[2])
                        var friend = Friend(uid: charindex[0], nickname: nickname + " 님이 팀원 추가를 요청했습니다.", position: charindex[2], profileImg: "",stmt: charindex[1])
                        friendList.append(friend)
                        notifyTableView.reloadData()
                    }
                }
            }
        
            // 친구요청 가져오기
            let friendAlarmList = db.child("user").child(userUID).child("friendRequest")
            //queryEqual(toValue: myNickname)
        friendAlarmList.observeSingleEvent(of: .value) { [self] snapshot in
                
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as? NSDictionary
                    
                    requestTime = value?["requestTime"] as? String ?? ""
                    requestStmt = value?["requestStmt"] as? String ?? ""
                    requestUID = value?["requestUID"] as? String ?? ""
                    print(requestTime)
                    print(requestStmt)
                    print(requestUID)
                    allInfo = (requestUID+","+requestStmt+","+requestTime)
                        friendUid.append(allInfo)
                    
                }
                
                for uid in self.friendUid{
                    self.friendUid2.append(uid)
                    print(uid)
                    let charindex = uid.components(separatedBy: ",")
                    //friendList.append(contentsOf: <#T##Sequence#>)
                    self.db.child("user").child(charindex[0]).observeSingleEvent(of: .value) { [self] snapshot in
                        var nickname: String = ""

                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let value = snap.value as? NSDictionary

                            if snap.key == "userProfile" {
                                for (key, content) in value! {
                                    if key as! String == "nickname" {
                                        nickname = content as! String
                                    }
                                }
                            }
                        }
                        print(charindex[0])
                        print(charindex[1])
                        print(charindex[2])
                        let friend = Friend(uid: charindex[0], nickname: nickname + " 님이 친구를 요청했습니다.", position: charindex[2], profileImg: "",stmt : charindex[1])
                        friendList.append(friend)
                        
                        notifyTableView.reloadData()
                    }
                }
            }
       
        notifyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return RequestContent.count
        friendList = friendList.sorted(by: {$0.position > $1.position})
        return friendList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestCell
        //수락 버튼을 눌렀을때
        cell.accept = { [unowned self] in
            let userUID = Auth.auth().currentUser!.uid
            let uid = friendList[indexPath.row].uid
            let nickname = friendList[indexPath.row].nickname
            var Index: String = ""
            
//          Database.database().reference().child("user").child(userUID).child("friendsList").updateChildValues(fUid)
            if(nickname.contains("친구")){
                db.child("user").child(Auth.auth().currentUser!.uid).child("friendsList").observeSingleEvent(of: .value) { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        print(snapshots.count)
                        Index = "\(snapshots.count)"
                        let fUid: [String: String] = [Index : uid]
                        db.child("user").child(userUID).child("friendsList").updateChildValues(fUid)
                    }
                }
                
                db.child("user").child(uid).child("friendsList").observeSingleEvent(of: .value) { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        print(snapshots.count)
                        Index = "\(snapshots.count)"
                        let myUid: [String: String] = [Index : userUID]
                        db.child("user").child(uid).child("friendsList").updateChildValues(myUid)
                    }
                }
//                self.friendList.remove(at: indexPath.row)
                notifyTableView.reloadData()
                db.child("user").child(userUID).child("friendRequest").child(requestNum).child("requestStmt").setValue("수락")
            }
   
            
            if(nickname.contains("팀원")){
                db.child("user").child(uid).child("userTeam").observeSingleEvent(of: .value) {snapshot in
                  let value = snapshot.value as? String ?? ""
                    if value.isEmpty{
                      db.child("user").child(uid).child("userTeam").setValue(userUID)
                    }
                    else{
                     db.child("user").child(uid).child("userTeam").setValue(value + ", " + userUID)
                    }
                   
                }
                db.child("user").child(userUID).child("userTeam").observeSingleEvent(of: .value) {snapshot in
                  let value = snapshot.value as? String ?? ""
                    if value.isEmpty{
                        db.child("user").child(userUID).child("userTeam").setValue(uid)
                    }
                    else{
                        db.child("user").child(userUID).child("userTeam").setValue(value + ", " + uid )
                    }
                   
                }
                
                db.child("user").child(userUID).child("memberRequest").child(requestNum).child("requestStmt").setValue("수락")
                notifyTableView.reloadData()
            }

        }
            //거절하기 버튼 눌렀을 때 실행할 함수 선언
           cell.refuse = { [unowned self] in
           // 1. DB 에서 요청 데이터 삭제하기
//            let userUID = Auth.auth().currentUser!.uid
//               Database.database().reference().child("user").child(userUID).child("friendRequest").removeValue()
           self.friendList.remove(at: indexPath.row)
               notifyTableView.reloadData()
        }
        
        //알림 default 셀
        if friendList[indexPath.row].stmt == "기본"{
            cell.refuseBtn.layer.isHidden = true
            cell.AcceptedBtn.layer.isHidden = true
            cell.refuseBtn.isEnabled = true
            cell.AcceptedBtn.isEnabled = false
            
//            let currentUser = Auth.auth().currentUser
            db.child("user").child(Auth.auth().currentUser!.uid).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
              // Get user value
              let value = snapshot.value as? NSDictionary
            let nickname = value?["nickname"] as? String ?? ""
                cell.ContentLabel.text = "\(nickname) 님 iteam에 오신 걸 환영합니다!"
                print(nickname + "여기 오류")
            })
            cell.profileImg.image = UIImage(named: "AppIcon60@3x")
            
        }
            
        else if friendList[indexPath.row].stmt == "수락"{
            cell.AcceptedBtn.isEnabled = false
            cell.refuseBtn.layer.isHidden = true
            cell.AcceptedBtn.layer.isHidden = false
            cell.AcceptedBtn.setTitle("추가됨", for: .normal)
            cell.AcceptedBtn.backgroundColor = UIColor.white
            cell.AcceptedBtn.setTitleColor(.black, for: .normal)
            cell.AcceptedBtn.layer.borderWidth = 0.5
            cell.AcceptedBtn.layer.cornerRadius = 10
            cell.AcceptedBtn.layer.borderColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0).cgColor
            cell.AcceptedBtn.isEnabled = true
        }
        else if friendList[indexPath.row].stmt == "요청"{
            cell.refuseBtn.layer.isHidden = false
            cell.AcceptedBtn.layer.isHidden = false
            cell.AcceptedBtn.setTitle("수락", for: .normal)
            cell.AcceptedBtn.backgroundColor = UIColor(named: "purple_184")
            cell.AcceptedBtn.setTitleColor(.white, for: .normal)
            cell.AcceptedBtn.layer.borderWidth = 0
            cell.AcceptedBtn.layer.cornerRadius = 10
            cell.AcceptedBtn.isEnabled = true
        }
        
        let notiImg = friendList[indexPath.row].uid
        let starsRef = Storage.storage().reference().child("user_profile_image/\(notiImg).jpg")
        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
            if let error = error {
            } else {
                cell.profileImg.kf.setImage(with: url)
                cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2
            }
        }
        
            // Set up cell.button
            cell.ContentLabel.text = friendList[indexPath.row].nickname
            cell.DateLabel.text = friendList[indexPath.row].position
//            cell.profileImg.image = UIImage(named: "\(friendList[indexPath.row].profileImg)")
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


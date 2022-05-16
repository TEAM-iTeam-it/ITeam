//
//  NotifyViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/05/04.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NotifyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notifyTableView: UITableView!
    var ref: DatabaseReference!
    let db = Database.database().reference()
    var notiContent: [Noti] = []
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
        notiContent.append(Noti(content: "이성책임 팀과의 통화가 곧 시작됩니다.", date: "04/20 14:30", profileImg: "imgUser8"))
        notiContent.append(Noti(content: "레인 님과의 통화가 곧 시작됩니다.", date: "04/17 15:04", profileImg: "imgUser5"))
        
        fetchData()
        fetchMemberData()
//        fetchChangedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notifyTableView.reloadData()
        
    }
    
    //팀원 수락 요청 가져오기
    func fetchMemberData() {
        let userdb = db.child("user").child(Auth.auth().currentUser!.uid)
        let userUID = Auth.auth().currentUser!.uid
            
            let memberRequestList = db.child("user").child(userUID).child("memberRequest")
            //queryEqual(toValue: myNickname)
        memberRequestList.observeSingleEvent(of: .value) { [self] snapshot in
                
                // 나와 관련된 call 가져오기
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as? NSDictionary
//                    print (value)
                    
                    requestTime = value?["requestTime"] as? String ?? ""
                    requestStmt = value?["requestStmt"] as? String ?? ""
                    requestUID = value?["requestUID"] as? String ?? ""
                    print(requestTime)
                    print(requestStmt)
                    print(requestUID)
                    memberInfo = (requestUID+","+requestStmt+","+requestTime)
                    memberUid.append(memberInfo)
                }
                
                for uid in self.memberUid{
                    self.memberUid2.append(uid)
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
                        print("a")
                        print(nickname)
                        print(charindex[0])
                        print(charindex[1])
                        print(charindex[2])
                        var friend = Friend(uid: charindex[0], nickname: nickname + " 님이 팀원 추가를 요청했습니다.", position: charindex[2], profileImg: "")
                        friendList.append(friend)
                        notifyTableView.reloadData()
                    }
                }
            }
        notifyTableView.reloadData()
    }
    
    //친구 수락 요청 가져오기
    func fetchData() {
        let userdb = db.child("user").child(Auth.auth().currentUser!.uid)
        let userUID = Auth.auth().currentUser!.uid
            // 팀 알림 가져오기
            let favorTeamList = db.child("user").child(userUID).child("friendRequest")
            //queryEqual(toValue: myNickname)
            favorTeamList.observeSingleEvent(of: .value) { [self] snapshot in
                
                // 나와 관련된 call 가져오기
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as? NSDictionary
//                    print (value)
                    
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
                        print("b")
                        print(charindex[0])
                        print(charindex[1])
                        print(charindex[2])
                        var friend = Friend(uid: charindex[0], nickname: nickname + " 님이 친구를 요청했습니다.", position: charindex[2], profileImg: "")
                        friendList.append(friend)
                        notifyTableView.reloadData()
                    }
                }
            }
        notifyTableView.reloadData()
    }
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
//        giverList.removeAll()
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return RequestContent.count
        return friendList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestCell
        
        //수락 버튼
        cell.accept = { [unowned self] in
            let userUID = Auth.auth().currentUser!.uid
            let fuid = friendList[indexPath.row].uid
            let fnickname = friendList[indexPath.row].nickname
            
        //친구 리스트에 추가 진행중
            var Index: String = ""
            
//          Database.database().reference().child("user").child(userUID).child("friendsList").updateChildValues(fUid)
            if(fnickname.contains("친구")){
                db.child("user").child(userUID).child("friendsList").observeSingleEvent(of: .value) { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        print(snapshots.count)
                        Index = "\(snapshots.count)"
                        let fUid: [String: String] = [Index : fuid]
                        db.child("user").child(userUID).child("friendsList").updateChildValues(fUid)
                    }
                }
                self.friendList.remove(at: indexPath.row)
                notifyTableView.reloadData()
            }
   
            
            if(fnickname.contains("팀원")){
                db.child("user").child(fuid).child("userTeam").observeSingleEvent(of: .value) {snapshot in
                  let value = snapshot.value as? String ?? ""
                    if value.isEmpty{
                      db.child("user").child(fuid).child("userTeam").setValue(userUID)
                    }
                    else{
                     db.child("user").child(fuid).child("userTeam").setValue(value + ", " + userUID)
                    }
                   
                }
                db.child("user").child(userUID).child("userTeam").observeSingleEvent(of: .value) {snapshot in
                  let value = snapshot.value as? String ?? ""
                    if value.isEmpty{
                        db.child("user").child(userUID).child("userTeam").setValue(fuid)
                    }
                    else{
                        db.child("user").child(userUID).child("userTeam").setValue(value + ", " + fuid )
                    }
                   
                }
                self.friendList.remove(at: indexPath.row)
                notifyTableView.reloadData()
            }

        }
            //거절하기 버튼 눌렀을 때 실행할 함수 선언
           cell.refuse = { [unowned self] in
           // 1. DB 에서 요청 데이터 삭제하기
            let userUID = Auth.auth().currentUser!.uid
//               Database.database().reference().child("user").child(userUID).child("friendRequest").removeValue()
           self.friendList.remove(at: indexPath.row)
               notifyTableView.reloadData()
//           self.requestCV.reloadData()
        }
        
            // Set up cell.button
            cell.ContentLabel.text = friendList[indexPath.row].nickname
            cell.DateLabel.text = friendList[indexPath.row].position
            cell.profileImg.image = UIImage(named: "\(friendList[indexPath.row].profileImg)")
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class Noti {
    var content: String
    var date: String
    var profileImg: String
    
    //var profileImg: UIImage
    
    init(content: String, date: String, profileImg: String ) {
        self.content = content
        self.date = date
        self.profileImg = profileImg
    }
    
    
}

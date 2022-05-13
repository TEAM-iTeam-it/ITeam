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
    var RequestContent: [Request] = []
    var giverList: [String] = []
    var friendList: [Friend] = []
    var friendUid:[String] = []
    var giverNumber: [String] = []
    
    

//    var RequestContent: [Request] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        notiContent.append(Noti(content: "이성책임 팀과의 통화가 곧 시작됩니다.", date: "04/20 14:30", profileImg: "imgUser8"))
        notiContent.append(Noti(content: "레인 님과의 통화가 곧 시작됩니다.", date: "04/17 15:04", profileImg: "imgUser5"))
        RequestContent.append(Request(content: "에일리 님이 친구를 요청했습니다.", date: "04/17 15:04", profileImg: "imgUser5"))
        RequestContent.append(Request(content: "레인 님과의 통화가 곧 시작됩니다.", date: "04/17 15:04", profileImg: "imgUser5"))
        
        fetchFreindRequest()
        fetchChangedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //notifyTableView.reloadData()
        
    }
    // giverList에 나에게 친구요청한 사람 uid 받아와짐
    func fetchFreindRequest() {
//        giverList.removeAll()
        
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser!.uid
        ref.child("user").child(userUID).observeSingleEvent(of: .value){ snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {return}
            for key in snapData.keys {
                if key == "friendRequest" {
                    for k in snapData.values {
                        if k is [String] {
                            self.giverList = (k as? [String])!
//                            print(self.giverList)
                           
                        }

                    }
                }

            }
            //uid 닉네임 가져오기
            for uid in self.giverList{
                self.friendUid.append(uid)
                print(uid)
                //friendList.append(contentsOf: <#T##Sequence#>)
                self.db.child("user").child(uid).observeSingleEvent(of: .value) { [self] snapshot in
                    var nickname: String = ""
                    var part: String = ""
                    var partDetail: String = ""
                    var purpose: String = ""
                    var uid: String = ""
                    
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let value = snap.value as? NSDictionary
                        
                        if snap.key == "userProfile" {
                            for (key, content) in value! {
                                if key as! String == "nickname" {
                                    nickname = content as! String
                                }
                                if key as! String == "part" {
                                    part = content as! String
                                }
                                if key as! String == "partDetail" {
                                    partDetail = content as! String
                                }
                            }
                            
                        }
                        if snap.key == "userProfileDetail" {
                            for (key, content) in value! {
                                if key as! String == "purpose" {
                                    purpose = content as! String
                                }
                            }
                        }
                        
                    }
                    if part == "개발자" {
                        part = partDetail + part
                        
                    }
                    part += " • " + purpose.replacingOccurrences(of: ", ", with: "/")
                    
                    var friend = Friend(uid: uid, nickname: nickname, position: part, profileImg: "")
                    friendList.append(friend)
                    //notifyTableView.reloadData()
                }
            }
        }
        
        notifyTableView.reloadData()
    }
    
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        giverList.removeAll()
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchFreindRequest()
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return RequestContent.count
        return friendList.count
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: NotifyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "notifyTableViewCell", for: indexPath) as! NotifyTableViewCell
//
//        let Rcell: FriendRequestCell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestCell
//
//
//        cell.ContentLabel.text = notiContent[indexPath.row].content
//        cell.dateLabel.text = notiContent[indexPath.row].date
//        cell.profileImg.image = UIImage(named: "\(notiContent[indexPath.row].profileImg)")
////        cell.profileImg.image = UIImage(systemName: "person.crop.circle.fill")
//        return cell;Rcell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(giverList)
//        if giverList.isEmpty == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell", for: indexPath) as! FriendRequestCell
        
        //수락 버튼
        cell.accept = { [unowned self] in
           // 1. 새로운 채팅방 개설하기 위해 DB에 채팅 데이터 추가하는 함수 호출
           // 2. DB 에서 요청 데이터 삭제하기
            let userUID = Auth.auth().currentUser!.uid
            let fuid = friendUid[indexPath.row]
            print(fuid)
            //데이터베이스에서 삭제...미해결
//           Database.database().reference().child("user").child(userUID).child("friendRequest").queryEqual(toValue: fuid).removeValue()
            
        //친구 리스트에 추가 진행중
            
            var Index: String = ""
//            Database.database().reference().child("user").child(userUID).child("friendsList").updateChildValues(fUid)
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
//           self.UITableView.reloadData()
        }
            //거절하기 버튼 눌렀을 때 실행할 함수 선언
           cell.refuse = { [unowned self] in
           // 1. DB 에서 요청 데이터 삭제하기
            let userUID = Auth.auth().currentUser!.uid
               Database.database().reference().child("user").child(userUID).child("friendRequest").removeValue()
           self.friendList.remove(at: indexPath.row)
               notifyTableView.reloadData()
//           self.requestCV.reloadData()
        }
        
            // Set up cell.button
            cell.ContentLabel.text = friendList[indexPath.row].nickname
            cell.DateLabel.text = friendList[indexPath.row].position
            cell.profileImg.image = UIImage(named: "\(friendList[indexPath.row].profileImg)")
            return cell
            
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "notifyTableViewCell", for: indexPath) as! NotifyTableViewCell
//            // Set up cell.label
//
//                cell.ContentLabel.text = notiContent[indexPath.row].content
//                cell.dateLabel.text = notiContent[indexPath.row].date
//                cell.profileImg.image = UIImage(named: "\(notiContent[indexPath.row].profileImg)")
//            //        cell.profileImg.image = UIImage(systemName: "person.crop.circle.fill")
//            return cell
//        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Int{
    var toDayTime :String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        return dateFormatter.string(from: date)
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
        //self.profileImg = profileImg
    }
    
    
}

class Request {
    var content: String
    var date: String
    var profileImg: String

    //var profileImg: UIImage

    init(content: String, date: String, profileImg: String ) {
        self.content = content
        self.date = date
        self.profileImg = profileImg
        //self.profileImg = profileImg
    }


}

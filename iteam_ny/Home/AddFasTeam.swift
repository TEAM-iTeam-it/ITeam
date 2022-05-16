//
//  AddFasTeam.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddFasTeam:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var memberAddBtn: UIButton!
    var friendContent: [myFriend] = []
    var ref: DatabaseReference!
    let db = Database.database().reference()
    @IBOutlet weak var myFriendTableView: UITableView!
    var friendList: [String] = []
    var myFriendUid:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFreindRequest()
//        friendContent.append(myFriend(content: "ios개발, 공모전", name: "에일리", profileImg: "imgUser5"))
    }
    
    func fetchFreindRequest() {
//        giverList.removeAll()
        
        let ref = Database.database().reference()
        let userUID = Auth.auth().currentUser!.uid
        ref.child("user").child(userUID).observeSingleEvent(of: .value){ snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {return}
            for key in snapData.keys {
                if key == "friendsList" {
                    for k in snapData.values {
                        if k is [String] {
                            self.friendList = (k as? [String])!
//                            print(self.giverList)
                        }

                    }
                }

            }
            //uid 닉네임 가져오기
            for uid in self.friendList{
                self.myFriendUid.append(uid)
                print(uid)
                //friendList.append(contentsOf: <#T##Sequence#>)
                self.db.child("user").child(uid).observeSingleEvent(of: .value) { [self] snapshot in
                    var nickname: String = ""
                    var part: String = ""
                    var partDetail: String = ""
                    var purpose: String = ""
//                    var uid: String = ""
                    
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
                    
                    var friend2 = myFriend(uid: uid, content: part, name: nickname, profileImg: "")
                    friendContent.append(friend2)
                    myFriendTableView.reloadData()
                }
            }
        }
        
        myFriendTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendContent.count
    }
    
    func currentDateTime() -> String {
        var formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        var currentDateString = formatter.string(from: Date())

        return currentDateString
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addfriendCell", for: indexPath) as! AddfriendCell
        
        cell.accept = { [unowned self] in
        // 1. DB 에서 요청 데이터 삭제하기
         let userUID = Auth.auth().currentUser!.uid
            // 데이터 받아와서 이미 있으면 합쳐주기
            var index: String = ""
            ref = Database.database().reference()
            ref.child("user").child(friendContent[indexPath.row].uid).child("memberRequest").observeSingleEvent(of: .value) { [self] snapshot in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    index = "\(snapshots.count)"
                    let valueUID = ["requestUID" : userUID]
                    let valueTime = ["requestTime" : currentDateTime()]
                    let valueStmt = ["requestStmt" : "요청"]
                    
                    // 요청한 시간과 함께 넘겨주기
                    let dataPath = ref.child("user").child(friendContent[indexPath.row].uid).child("memberRequest").child(index)
                    dataPath.updateChildValues(valueUID)
                    dataPath.updateChildValues(valueTime)
                    dataPath.updateChildValues(valueStmt)
                }
            }
        myFriendTableView.reloadData()
     }
        cell.friendProfile.text = friendContent[indexPath.row].content
        cell.friendName.text = friendContent[indexPath.row].name
        cell.userImg.image = UIImage(named: "\(friendContent[indexPath.row].profileImg)")
        return cell
    }

}

class myFriend {
    var content: String
    var name: String
    var profileImg: String
    var uid: String

    //var profileImg: UIImage

    init(uid: String, content: String, name: String, profileImg: String ) {
        self.content = content
        self.name = name
        self.profileImg = profileImg
        self.uid = uid
    }


}

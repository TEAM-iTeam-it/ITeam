//
//  AddFasTeam.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class AddFasTeam:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    var friendContent: [myFriend] = []
    var ref: DatabaseReference!
    let db = Database.database().reference()
    @IBOutlet weak var myFriendTableView: UITableView!
    var friendList: [String] = []
    var myFriendUid:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myFriendTableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        let fancyImage = UIImage(systemName:"arrow.left")

        var fancyAppearance = UINavigationBarAppearance()
        fancyAppearance.backgroundColor = UIColor.white
        //fancyAppearance.configureWithDefaultBackground()
        fancyAppearance.setBackIndicatorImage(fancyImage, transitionMaskImage: fancyImage)

        navigationController?.navigationBar.scrollEdgeAppearance = fancyAppearance
        
        fetchFreind()
        fetchChangedData()
//        friendContent.append(myFriend(content: "ios개발, 공모전", name: "에일리", profileImg: "imgUser5"))
    }
    override func viewWillAppear(_ animated: Bool) {
        //myFriendTableView.reloadData()
    }
    func fetchChangedData() {
//        teamMembers.removeAll()
        Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).child("friendsList").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchFreind()
//                self.fetchMemberData()
            }
        })
    }
    
    func fetchFreind() {
        friendContent.removeAll()
        
//        let ref =
        let userUID = Auth.auth().currentUser!.uid
        Database.database().reference().child("user").child(userUID).observeSingleEvent(of: .value){ snapshot in
            guard let snapData = snapshot.value as? [String:Any] else {return}
            for key in snapData.keys {
                print(key + "@@")
                if key == "friendsList"{
                    for k in snapData.values {
                        if k is [String] {
                            self.friendList = (k as? [String])!
                            print(self.friendList)
                        }

                    }
                }

            }
            //uid 닉네임 가져오기
            for uid in self.friendList{
                self.myFriendUid.append(uid)
                print(uid + "!!!!!!!!!!!")
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
            cell.addBtn.backgroundColor = UIColor.white
            //cell.addBtn.layer.cornerRadius = 5
            cell.addBtn.setTitleColor(.black, for: .normal)
            cell.addBtn.setTitle("요청됨", for: .normal)
            cell.addBtn.layer.borderWidth = 0.5
            cell.addBtn.layer.borderColor = UIColor.lightGray.cgColor
            
    }
        let friendImg = friendContent[indexPath.row].uid
        let starsRef = Storage.storage().reference().child("user_profile_image/\(friendImg).jpg")
        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
            if let error = error {
            } else {
                cell.userImg.kf.setImage(with: url)
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height/2
            }
        }
        
        cell.friendProfile.text = friendContent[indexPath.row].content
        cell.friendName.text = friendContent[indexPath.row].name
//        cell.userImg.image = UIImage(named: "\(friendContent[indexPath.row].profileImg)")
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

//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Kingfisher

class HomeViewController: UIViewController, PickpartDataDelegate{
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var myPart: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var memberStackVIew: UIStackView!
    var text:String = ""
    var pickpart:[String] = []
    var teamMembers: [MyTeam] = []
    var updateFetchData = 0
    
    @IBOutlet weak var addFriendView: UIView!
    @IBOutlet weak var memberColl: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBAction func addEntry(_ sender: UIButton) {
        
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let alertPopupVC = stroyboard.instantiateViewController(withIdentifier: "PopupViewController") as!PopupViewController
        
        alertPopupVC.modalPresentationStyle = .overCurrentContext
        alertPopupVC.modalTransitionStyle = .crossDissolve
        alertPopupVC.delegate = self
        
        self.present(alertPopupVC, animated: true, completion: nil)
        
    }
    
    func makeButton(){
        guard let addButtonContainerView = memberStackVIew.arrangedSubviews.last else {
            fatalError("Expected at least one arranged view in the stack view")
        }
        // add button 한 칸 앞 index를 가져 온다
        let nextEntryIndex = memberStackVIew.arrangedSubviews.count - 1
        
        
        let offset = CGPoint(x: scrollView.contentOffset.x + addButtonContainerView.bounds.size.width , y:
                                scrollView.contentOffset.y)
        
        // stackview를 만들어서 안 보이게 처리
        let newEntryView = createEntryView()
        newEntryView.isHidden = true
        
        // 만들어진 stack view를 add button앞에다가 추가
        memberStackVIew.insertArrangedSubview(newEntryView, at: nextEntryIndex)
        
        // 0.25초 동안 추가된 뷰가 보이게 하면서 scrollview의 스크롤 이동
        UIView.animate(withDuration: 0.25) {
            newEntryView.isHidden = false
            self.scrollView.contentOffset = offset
        }
    }
    
    // 수직 스택뷰 안에 들어갈 수평 스택뷰들 만든다.
    private func createEntryView() -> UIView {
        let pickimage = GradientButton()
        pickimage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        // 버튼 넓이
        pickimage.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        pickimage.backgroundColor = UIColor.purple
        pickimage.setTitle(text, for: .normal)
        pickimage.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        //진행중
        pickimage.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        
        //아래 슬라이드 바
        let numberLabel = UILabel()
        numberLabel.text = "여기자리"
        numberLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
//        let hereBtn = UIView()
//        hereBtn.backgroundColor = .black
//        hereBtn.frame.size.height = 1
//        hereBtn.frame.size.width = 50
        stack.addArrangedSubview(pickimage)
//        stack.addArrangedSubview(hereBtn)
        return stack
    }
    //파트별로 리스트 띄우기 진행중
    @objc func tapped(sender: UIButton) {
        
        pickpart.removeAll()
        print(sender.currentTitle)
        
        //특정 데이터만 읽기
        let usersRef = Database.database().reference().child("user")
        let queryRef = usersRef.queryOrdered(byChild: "userProfile/part").queryEqual(toValue: sender.currentTitle)
        var userUID: String = ""
        queryRef.observeSingleEvent(of: .value) { [self] snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                userUID = snap.key
                pickpart.append(userUID)
                
            }
            //                print(pickpart)
        }
        // 특정 목록만 띄우기
        ref.observe(.value) { snapshot in
            guard var value = snapshot.value as? [String: [String: Any]] else { return }
            print(value.keys)
            
            for abc in value.keys {
                
                if (self.pickpart.contains("\(abc)")) == false{
                    print(abc)
                    value.removeValue(forKey: "\(abc)")
                }
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let userData = try JSONDecoder().decode([String: Uid].self, from: jsonData)
                let showUserList = Array(userData.values)
                self.userList = showUserList.sorted { $0.rank < $1.rank } //정렬 순서
                
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
                
            }catch let DecodingError.dataCorrupted(context) {
                print("바뀐error2 : ",context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("바뀐Key '\(key)' not found:", context.debugDescription)
                print("바뀐codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("바뀐Value '\(value)' not found:", context.debugDescription)
                print("바뀐codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("바뀐Type '\(type)' mismatch:", context.debugDescription)
                print("바뀐codingPath:", context.codingPath)
            } catch {
                print("바뀐error: ", error)
            }
            catch let error {
                print("바뀐ERROR JSON parasing \(error.localizedDescription)")
            }
            
            print("바뀐 countentArray2.cout : \(self.userList.count)")
        }
    }
    
    func SendCategoryData(data: String) {
        if data == "개발자"{
            text = "개발자"
            makeButton()
            
        }
        if data == "디자이너"{
            text = "디자이너"
            makeButton()
            
        }
        if data == "기획자"{
            text = "기획자"
            makeButton()
        }
    }
    
    var ref: DatabaseReference! //Firebase Realtime Database
    
    func removeArr() {
        
        teamMembers.removeAll()
        updateFetchData = 0
        //        myMemberList.removeAll()
    }
    
    func fetchChangedData() {
        //        teamMembers.removeAll()
        removeArr()
        
//        Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ (snapshot) -> Void in
//            print("DB 수정됨")
//            DispatchQueue.main.async {
//                self.fetchMemberList()
//                //                self.fetchMemberData()
//            }
//        })
        Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ [self] (snapshot) -> Void in
              print("DB 수정됨 Call")
              if updateFetchData == 0 {
                  updateFetchData += 1
              }
              else if updateFetchData == 1 {
                  print(updateFetchData)
                  updateFetchData += 1
                  self.fetchMemberList()
                  DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                      updateFetchData = 1
                  })
              }
          })
        
    }
    //
    var fillteredData = [String]()
    var userList: [Uid] = []
    //알고리즘 - 진행중
    var userprofileDetail: UserProfileDetail?
    
    //알고리즘 - 진행중
    func sortList(a:Int, b:Int) -> Bool {
        let celebrity1: [String] = ["창의적인", "상상력이 풍부한", "전통에 얽매이지 않는" ]
        let celebrity2: [String] = ["외향적인", "열정적인", "사교성이 있는" ]
        let celebrity3: [String] = ["자신감 있는", "의사 결정을 잘하는", "목표 지향적인"]
        let celebrity4: [String] = ["문제를 극복하는", "도전적인", "추진력있는"]
        let celebrity5: [String] = ["전략적인", "신중한", "정확히 판단하는"]
        let detail = userprofileDetail
        let char = detail?.character
        
        let charindex: [String] = (char?.components(separatedBy: ", "))!
        let f = charindex[0]
        let s = charindex[1]
        let l = charindex[2]
        
        //나의 성향 출력
        if let firstIndex = celebrity1.firstIndex(of: f) {
            print("창의적인")
        }
        for mych in charindex {
            if let firstIndex = celebrity1.firstIndex(of: mych) {
                print("창의적인")
            }
        }
        
        return a>b
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        fetchMemberList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("user")
        ref.child(Auth.auth().currentUser!.uid).child("userTeam").setValue("")
    
        fetchMemberList()
        fetchChangedData()
       
        // 내정보 가져오기
        let currentUser = Auth.auth().currentUser
        let myuid: String = Auth.auth().currentUser!.uid
        ref.child((currentUser?.uid)!).child("userProfile").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let partDetail = value?["partDetail"] as? String ?? ""
            
            self.myPart.text = "\(partDetail)"
            
        }) { error in
            print(error.localizedDescription)
        }
        let img = Storage.storage().reference().child("user_profile_image/\(Auth.auth().currentUser!.uid).jpg")
        // Fetch the download URL
        img.downloadURL { [self] url, error in
            if let error = error {
            } else {
                myImg.kf.setImage(with: url)
                myImg.layer.cornerRadius = myImg.frame.height/2
            }
        }
        
        //UITableView Cell Register
        let nibName = UINib(nibName: "UserListCell", bundle: nil)
        homeTableView.register(nibName, forCellReuseIdentifier: "UserListCell")
        
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.estimatedRowHeight = 70
        
        self.homeTableView.panGestureRecognizer.delaysTouchesBegan = true
        
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        
        //데이터 가져오기
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let userData = try JSONDecoder().decode([String: Uid].self, from: jsonData)
                let showUserList = Array(userData.values)
                self.userList = showUserList.sorted { $0.rank < $1.rank } //정렬 순서
                
                print("countentArray.cout : \(showUserList.count)")
                
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                    print("countentArray3.cout : \(self.userList.count)")
                }
                
            }catch let DecodingError.dataCorrupted(context) {
                print("error2 : ",context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            catch let error {
                print("ERROR JSON parasing \(error.localizedDescription)")
            }
            
            print("countentArray2.cout : \(self.userList.count)")
        }
        
        homeTableView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
      
        homeTableView.layer.cornerRadius = 20
        homeTableView.layer.borderColor = UIColor.black.cgColor
        homeTableView.layer.borderWidth = 0
        homeTableView.layer.shadowColor = UIColor.black.cgColor
        homeTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        homeTableView.layer.shadowOpacity = 0.15
        homeTableView.layer.shadowRadius = 10
        homeTableView.sectionHeaderTopPadding = 50
        
        addFriendView.backgroundColor = .white
        addFriendView.layer.cornerRadius = 20
        addFriendView.layer.borderColor = UIColor.black.cgColor
        addFriendView.layer.borderWidth = 0
        addFriendView.layer.shadowColor = UIColor.black.cgColor
        addFriendView.layer.shadowOffset = CGSize(width: 0, height: 0)
        addFriendView.layer.shadowOpacity = 0.15
        addFriendView.layer.shadowRadius = 10
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //나의 팀원 상단에 띄우기
    func fetchMemberList() {
        removeArr()
        let ref = Database.database().reference()
        var myMemberList = ""
        
        let userUID = Auth.auth().currentUser!.uid
        let memberRequestList =  Database.database().reference().child("user").child(userUID).child("userTeam")
        //queryEqual(toValue: myNickname)
        memberRequestList.observeSingleEvent(of: .value) { [self] snapshot in
            let value = snapshot.value as? String ?? ""
            if value.isEmpty == false{
                memberColl.isHidden = false
                myMemberList = value
                let memberindex = myMemberList.components(separatedBy: ", ")
                //uid 닉네임 가져오기
                for muid in memberindex{
                    //                self.myFriendUid.append(uid)
                    print(muid + "!!!!!!!!!!!")
                    //friendList.append(contentsOf: <#T##Sequence#>)
                    Database.database().reference().child("user").child(muid).observeSingleEvent(of: .value) { [self] snapshot in
                        var mnickname: String = ""
                        var mpart: String = ""
                        var partDetail: String = ""
                        
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let value = snap.value as? NSDictionary
                            
                            if snap.key == "userProfile" {
                                for (key, content) in value! {
                                    if key as! String == "nickname" {
                                        mnickname = content as! String
                                        print(mnickname + "dkdkdkdkdkdk")
                                    }
                                    if key as! String == "part" {
                                        mpart = content as! String
                                    }
                                    if key as! String == "partDetail" {
                                        partDetail = content as! String
                                    }
                                }
                            }
                        }
                        if mpart == "개발자" {
                            mpart = partDetail + mpart
                        }
                        var member = MyTeam(uid: muid, part: mpart, name: mnickname, profileImg: "")
                        teamMembers.append(member)
                        memberColl.reloadData()
                    }
                }
            }else{
                memberColl.isHidden = true
            }
            memberColl.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    //배열의 인덱수 수가 테이블 뷰의 row 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableviewHeight.constant = CGFloat(userList.count * 70 + 110)
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell",for: indexPath) as? UserListCell else {return UITableViewCell()}
        
        cell.userName.text = "\(userList[indexPath.row].userProfile.nickname)"
        cell.school.text = "\(userList[indexPath.row].userProfile.schoolName)"
        cell.partLabel.text = "\(userList[indexPath.row].userProfile.partDetail) • "
        cell.userPurpose.text = "\(userList[indexPath.row].userProfileDetail.purpose)"
        
        // 같은 학교 처리
        if cell.school.text == "네이버대학교" {
            cell.school.layer.borderWidth = 0.5
            cell.school.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            cell.school.textColor = UIColor(named: "purple_184")
            
            cell.school.layer.cornerRadius = cell.school.frame.height/2
            cell.school.text = "같은 학교"
            cell.school.isHidden = false
            
        }
        else {
            cell.school.isHidden = true
        }
        
        let nickname: String = userList[indexPath.row].userProfile.nickname
        //            print(nickname)
        
        var userUID2 :String = ""
        let userdb = Database.database().reference().child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                userUID2 = snap.key
            }
            let uid: String = userUID2
            //                print(fetchNickNameToUID(nickname:"우다다"))
            //                print(uid)
            let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
            // Fetch the download URL
            starsRef.downloadURL { [self] url, error in
                if let error = error {
                } else {
                    cell.userImage.kf.setImage(with: url)
                    cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //            print("You selected cell #\(indexPath.row)!")
        //상세페이지 이동
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "UserProfileController") as? UserProfileController else { return }
        
        detailViewController.userprofileDetail = userList[indexPath.row].userProfileDetail
        detailViewController.userprofile = userList[indexPath.row].userProfile
        self.show(detailViewController, sender: nil)
        
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        collectionViewWidth.constant = CGFloat(teamMembers.count * 90)
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeTeamCollectionViewCell", for: indexPath) as! HomeTeamCollectionViewCell
        
        let uid: String = teamMembers[indexPath.row].uid
        let hi:String = teamMembers[indexPath.row].name
        //        print("!!!!!!\(hi)!!!!!!!!")
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        
        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
            if let error = error {
                print("에러 \(error.localizedDescription)")
            } else {
                cell.userImg.kf.setImage(with: url)
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height/2
            }
        }
        
        cell.memberNickname.text = teamMembers[indexPath.row].name
        cell.memberPart.text = teamMembers[indexPath.row].part
        //        cell.userImg.image = UIImage(named: "\(teamMembers[indexPath.row].profileImg)")
        return cell
        
    }
}



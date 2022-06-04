//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2021/11/27.
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
    @IBOutlet weak var teamTitleLabel: UILabel!
    @IBOutlet weak var decidedTeamBtn: UIButton!
    @IBOutlet weak var teamExplainLabel: UILabel!
    var text:String = ""
    var pickpart:[String] = []
    var teamMembers: [MyTeam] = []
    var updateFetchData = 0
    var othercharacter = ""
    var myRank = 0
    
    var teamname: String?
    var memberList: [String] = []
    
    var creativeProperty: [String] = ["창의적인", "상상력이 풍부한", "전통에 얽매이지 않는"]
    var exploratoryProperty: [String] = ["외향적인", "열정적인", "사교성 있는"]
    var leadershipProperty: [String] = ["자신감 있는", "의사 결정을 잘하는", "목표 지향적인"]
    var propulsiveProperty: [String] = ["문제를 극복하는", "도전적인", "추진력있는"]
    var strategicProperty: [String] = ["전략적인", "신중한", "정확히 판단하는"]
    var goodMoodProperty: [String] = ["경청하는", "협력적인", "온화한"]
    var actionableProperty: [String] = ["능률적인", "엄격한", "실행력있는"]
    var persistenceProperty: [String] = ["근면 성실한", "완벽추구", "꼼꼼한"]
    var wellSkilledProperty: [String] = ["헌신적인", "전문적인", "몰두하는"]
    
    var teamTypeArr: [String] = ["창조적인", "탐색적인", "리더쉽 있는", "추진적인", "전략적인", "분위기 좋은", "실행력있는", "뒷심이 있는" ,"기술적인"]

    var teamTypeCount: [Int] = Array(repeating: 0, count: 9)
    var userPurpose: [String] = []
//    var fetchCharatorCount: Int = 0 {
//
//        willSet {
//            if newValue == memberList.count {
//                configTeamTypeLoad()
//            }
//        }
//    }
    
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
    //팀빌딩 완료 버튼
    @IBAction func clickedFinishedTeam(_ sender: Any) {
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let finishedPopupVC = stroyboard.instantiateViewController(withIdentifier: "FinishedTeamPopupViewController") as!FinishedTeamPopupViewController
        
        finishedPopupVC.modalPresentationStyle = .overCurrentContext
        finishedPopupVC.modalTransitionStyle = .crossDissolve
        //finishedPopupVC.delegate = self
        self.present(finishedPopupVC, animated: true, completion: nil)
    }
    
    
    var ref: DatabaseReference! //Firebase Realtime Database
    
    func removeArr() {
        for i in 0...8{
            teamTypeCount[i] = 0
        }
        memberList.removeAll()
        teamMembers.removeAll()
        userPurpose.removeAll()
        updateFetchData = 0
        //        myMemberList.removeAll()
    }
    
    func fetchDeleteData(){
        Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).observe(.childRemoved, with:{ [self] (snapshot) -> Void in
              print("DB 수정됨 삭제")
            DispatchQueue.main.async {
                self.fetchMemberList()
               
            }
          })
    }
    
    func fetchChangedData() {
        //        teamMembers.removeAll()
        removeArr()
        Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ [self] (snapshot) -> Void in
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
    var userprofileDetail: UserProfileDetail?
    
    //알고리즘 - 진행중
    func sortList(){
        var characterRank: [Int : Int] = [:]
        let detail = userprofileDetail
        let char = detail?.character
        
        let charindex: [String] = (char?.components(separatedBy: ", "))!
        
        var mych = ""
        var userch = ""
        
        for i in 0...2{
            if creativeProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "창조적인"
                }
                else{
                   mych = mych + "창조적인"
                }
            }
            if exploratoryProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "탐색적인"
                }
                else{
                   mych = mych + "탐색적인"
                }
            }
            if leadershipProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "리더쉽있는"
                }
                else{
                   mych = mych + "리더쉽있는"
                }
            }
            if propulsiveProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "추진적인"
                }
                else{
                   mych = mych + "추진적인"
                }
            }
            if strategicProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "전략적인"
                }
                else{
                   mych = mych + "전략적인"
                }
            }
            if goodMoodProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "분위기가 좋은"
                }
                else{
                   mych = mych + "분위기가 좋은"
                }
            }
            if actionableProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "실행력있는"
                }
                else{
                   mych = mych + "실행력있는"
                }
            }
            if persistenceProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "뒷심이있는"
                }
                else{
                   mych = mych + "뒷심이있는"
                }
            }
            if wellSkilledProperty.contains("\(charindex[i])"){
                if mych.isEmpty{
                    mych = "기술적인"
                }
                else{
                   mych = mych + "기술적인"
                }
            }
        }
        for j in 0..<userList.count{
            let userCharacter = userList[j].userProfileDetail.character.components(separatedBy: ", ")
            for k in 0...2{
                if creativeProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "창조적인"
                    }
                    else{
                        userch = userch + ",창조적인"
                    }
                }
                if exploratoryProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "탐색적인"
                    }
                    else{
                        userch = userch + ",탐색적인"
                    }
                }
                if leadershipProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "리더쉽있는"
                    }
                    else{
                        userch = userch + ",리더쉽있는"
                    }
                }
                if propulsiveProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "추진적인"
                    }
                    else{
                        userch = userch + ",추진적인"
                    }
                }
                if strategicProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "전략적인"
                    }
                    else{
                        userch = userch + ",전략적인"
                    }
                }
                if goodMoodProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "분위기가 좋은"
                    }
                    else{
                        userch = userch + ",분위기가 좋은"
                    }
                }
                if actionableProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "실행력있는"
                    }
                    else{
                        userch = userch + ",실행력있는"
                    }
                }
                if persistenceProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "뒷심이있는"
                    }
                    else{
                        userch = userch + ",뒷심이있는"
                    }
                }
                if wellSkilledProperty.contains("\(userCharacter[k])"){
                    if userch.isEmpty{
                        userch = "기술적인"
                    }
                    else{
                        userch = userch + ",기술적인"
                    }
                }
            }
            let userIndex = userch.components(separatedBy: ",")
            if (mych.contains("\(userIndex[0])")&&mych.contains("\(userIndex[1])")) || (mych.contains("\(userIndex[0])")&&mych.contains("\(userIndex[2])")) || (mych.contains("\(userIndex[1])")&&mych.contains("\(userIndex[2])")){
                characterRank[j] = 2
            }
            if mych.contains("\(userIndex[0])") || mych.contains("\(userIndex[1])") || mych.contains("\(userIndex[2])"){
                characterRank[j] = 3
            }
            if mych.contains("\(userIndex[0])") && mych.contains("\(userIndex[1])") && mych.contains("\(userIndex[2])"){
                characterRank[j] = 0
            }
            else{
                characterRank[j] = 5
            }
        }
        characterRank.sorted { $0.1 > $1.1 }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        fetchMemberList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("user")
    
        fetchMemberList()
        fetchChangedData()
        fetchDeleteData()
       
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
        
        decidedTeamBtn.layer.cornerRadius = 12
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
    //팀 조합 알고리즘
    func configTeamType() {
        var userPurposeCopy: [String] = []
        if !(memberList.contains(Auth.auth().currentUser!.uid)) {
            memberList.insert(Auth.auth().currentUser!.uid, at: 0)
        }
        for i in 0..<memberList.count {
            Database.database().reference().child("user").child(memberList[i]).child("userProfileDetail").child("character").observeSingleEvent(of: .value) { [self] snapshot in
                let value = snapshot.value as! String
                
                let charaterArr: [String] = value.components(separatedBy: ", ")
                for string in charaterArr {
                    self.userPurpose.append(string)
                }
                userPurposeCopy = userPurpose
                var onePersonPurposeCount: [Int] = Array(repeating: 0, count: 9)
                let bounds = 3*i..<3*i+3
                for i in bounds {
                    if creativeProperty.contains(userPurpose[i]) {
                        if onePersonPurposeCount[0] != 0 {
                            userPurposeCopy[i] = ""
                        }
                        else {
                            onePersonPurposeCount[0] += 1
                        }
                    }
                    else if exploratoryProperty.contains(userPurpose[i]) {
                        if onePersonPurposeCount[1] != 0 {
                            userPurposeCopy[i] = ""
                        }
                        else {
                            onePersonPurposeCount[1] += 1
                        }
                    }
                    else if leadershipProperty.contains(userPurpose[i]) {
                        if onePersonPurposeCount[2] != 0 {
                            userPurposeCopy[i] = ""
                        }
                        else {
                            onePersonPurposeCount[2] += 1
                        }
                    }
                    else if propulsiveProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[3] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[3] += 1
                            }
                    }
                    else if strategicProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[4] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[4] += 1
                            }
                    }
                    else if goodMoodProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[5] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[5] += 1
                            }
                    }
                    else if actionableProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[6] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[6] += 1
                            }
                    }
                    else if persistenceProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[7] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[7] += 1
                            }
                    }
                    else if wellSkilledProperty.contains(userPurpose[i]) {
                            if onePersonPurposeCount[8] != 0 {
                                userPurposeCopy[i] = ""
                            }
                            else {
                                onePersonPurposeCount[8] += 1
                            }
                    }
                    print("userPurposeCopy \(userPurposeCopy)")
                }
                //fetchCharatorCount += 1
                userPurpose = userPurposeCopy
            }
        }
    }
    
    func configTeamTypeLoad() {
        print(userPurpose)
        print("******************************")
        for i in 0..<userPurpose.count{
            if creativeProperty.contains(userPurpose[i]) {
                teamTypeCount[0] += 1
            }
            else if exploratoryProperty.contains(userPurpose[i]) {
                teamTypeCount[1] += 1
            }
            else if leadershipProperty.contains(userPurpose[i]) {
                teamTypeCount[2] += 1
            }
            else if propulsiveProperty.contains(userPurpose[i]) {
                teamTypeCount[3] += 1
            }
            else if strategicProperty.contains(userPurpose[i]) {
                teamTypeCount[4] += 1
            }
            else if goodMoodProperty.contains(userPurpose[i]) {
                teamTypeCount[5] += 1
            }
            else if actionableProperty.contains(userPurpose[i]) {
                teamTypeCount[6] += 1
            }
            else if persistenceProperty.contains(userPurpose[i]) {
                teamTypeCount[7] += 1
            }
            else if wellSkilledProperty.contains(userPurpose[i]) {
                teamTypeCount[8] += 1
            }
        }
        
        var maxCountIndex: [Int] = []
        print("젤 많이 선택된 횟수 \(teamTypeCount.max())")
        for i in 0..<teamTypeCount.count {
            if teamTypeCount[i] == teamTypeCount.max() {
                print("\(i)번째")
                maxCountIndex.append(i)
            }
        }
        var teamTitle: String = ""
        // 1순위 유형이 여러 개일 때
        if maxCountIndex.count != 1 {
            let random = maxCountIndex.randomElement()!
            print(random)
            teamTitle = teamTypeArr[random]
            
        }
        // 유형이 하나일 때
        else {
            teamTitle = teamTypeArr[maxCountIndex[0]]
        }
        teamTitleLabel.text = "우리는 " + teamTitle + " 팀"
        if teamTitle.contains("창조"){
            teamExplainLabel.text = "창조적이고 상상력이 풍부해서\n어려운 문제를 잘 해결할 수 있습니다.\n작은 일을 쉽게 지나칠 수 있으니 주의하세요"
        }
        if teamTitle.contains("탐색"){
            teamExplainLabel.text = "외향적이고 열정적이며\n언제나 기회를 발굴하고 탐색하는 편입니다.\n초기 열정이 사라지면 관심이 떨어질 수 있습니다."
        }
        if teamTitle.contains("리더쉽"){
            teamExplainLabel.text = "의사결정과 위임을 잘하기 때문에\n목표 설정이 명확하면 일이 수월하게 진행됩니다.\n개인의 일을 다른 사람에게 미루지 않으면 좋습니다."
        }
        if teamTitle.contains("추진"){
            teamExplainLabel.text = "어려운 일이 생겼을 경우\n극복하는 추진력과 용기를 가지고 있습니다.\n다른 사람의 감정을 상하게 할 수 있으니\n서로 조심하는 게 좋습니다."
        }
        if teamTitle.contains("전략"){
            teamExplainLabel.text = "문제에 있어 모든 방안을 살피고 정확히 판단할 수 있습니다.\n너무 비판적일 수 있기 때문에 다양한 시각을 가지면 좋습니다."
        }
        if teamTitle.contains("분위기"){
            teamExplainLabel.text = "협력적이고 남을 잘 이해할 수 있어\n평온한 조직을 만들 수 있습니다.\n남의 영향을 쉽게 받을 수 있기 때문에 결단력이 필요합니다."
        }
        if teamTitle.contains("실행력"){
            teamExplainLabel.text = "능률적이고 아이디어를 실행에 잘 옮기는 팀입니다.\n유연성이 부족하여 새로운 가능성에 대해\n열린 사고를 가지면 좋습니다."
        }
        if teamTitle.contains("뒷심"){
            teamExplainLabel.text = "열정적이고 실수나 빠진 것을 잘 찾아내며\n제 시간에 과업을 완수할 수 있는 팀입니다.\n사소한 것에 서로 간섭할 수 있습니다."
        }
        if teamTitle.contains("기술"){
            teamExplainLabel.text = "전문 분야의 지식과 기능을 제공할 수 있는 팀입니다.\n전문 분야의 기술적 내용에 치중하여 큰 그림을 놓칠 수 있습니다."
        }
        
    }

    //나의 팀원 상단에 띄우기
    func fetchMemberList() {
        removeArr()
        let ref = Database.database().reference()
        var myMemberList = ""
        
        let userUID = Auth.auth().currentUser!.uid
        let teamMemberList =  Database.database().reference().child("user").child(userUID).child("userTeam")
        //queryEqual(toValue: myNickname)
        teamMemberList.observeSingleEvent(of: .value) { [self] snapshot in
            let value = snapshot.value as? String ?? ""
            if value.isEmpty == false{
                memberColl.isHidden = false
                decidedTeamBtn.isEnabled = true
                decidedTeamBtn.backgroundColor = UIColor(named: "purple_184")
                myMemberList = value
                let memberindex = myMemberList.components(separatedBy: ", ")
                //uid 닉네임 가져오기
                for muid in memberindex{
                    memberList.append(muid)
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
                        configTeamType()
                        configTeamTypeLoad()
                        memberColl.reloadData()
                    }
                }
            }else{
                memberColl.isHidden = true
                decidedTeamBtn.backgroundColor = UIColor(named: "gray_196")
                decidedTeamBtn.isEnabled = false
                teamTitleLabel.text = "어떤 팀을 만들고 싶으신가요?"
                teamExplainLabel.text = "음성통화를 통해 친구를 만들어\n마음이 잘 맞는 팀원을 찾아보세요"
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
        
        cell.selectionStyle = .none
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
        
        var userUID2 :String = ""
        let userdb = Database.database().reference().child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                userUID2 = snap.key
            }
            let uid: String = userUID2
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

        collectionViewWidth.constant = CGFloat(teamMembers.count * 90 + 15)
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeTeamCollectionViewCell", for: indexPath) as! HomeTeamCollectionViewCell
        
        let uid: String = teamMembers[indexPath.row].uid
        let hi:String = teamMembers[indexPath.row].name
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



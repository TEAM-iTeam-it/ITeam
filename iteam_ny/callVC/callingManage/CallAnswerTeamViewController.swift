//
//  CallAnswerTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/06.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class CallAnswerTeamViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var answerListTableView: UITableView!
    
    // MARK: - Properties
    var updateFetchData: Bool = false
    var personList: [Person] = []
    var whenIReceivedOtherPerson: [Person] = []
    var whenISendOtherTeam: [Person] = []
    var toGoSegue: String = "대기"
    let db = Database.database().reference()
    
    var name: String = "speaker"
    var myNickname = ""
    var myTeamname = ""
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    var callTimeArr: [[String]] = []
    var questionArr: [[String]] = []
    var callTimeArrSend: [[String]] = []
    var questionArrSend: [[String]] = []
    var didISent: [Bool] = []
    var fetchedInputUIDToNickName: String = ""
    var teamIndex: [String] = []
    var teamIndexForSend: [String] = []
    var callTeamIndex: [String] = []
    var nowRequestedUid: String = "" {
        willSet(newValue) {
            callingOtherUid = newValue
        }
    }
    var checkDidload: Bool = false
    var callingOtherUid: String = ""
    var amiLeader: Bool = false
    var leader: Person = Person(nickname: "", position: "", callStm: "", profileImg: "")
    private var refreshControl = UIRefreshControl()
    var didUserUpdate: Bool = false
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerListTableView.delegate = self
        answerListTableView.dataSource = self
        
        setUI()
        
        fetchChangedData()

    }
    override func viewWillAppear(_ animated: Bool) {
        if !updateFetchData {
            fetchData()            
        }
        //setUI()
    }
    /*
    @IBAction func testChangeCall(_ sender: UIButton) {
        
        let stmt: [String: String] = [ "stmt": "통화"]
        
        for i in 0..<personList.count {
            if personList[i].callStm == "대기 중" {
                var indexCount = -1
                
                for j in 0..<personList.count {
                    if personList[j].callStm == "대기 중" {
                        indexCount += 1
                    }
                }
               
                
                for j in 0..<whenIReceivedOtherPerson.count {
                    if whenIReceivedOtherPerson[j].nickname == personList[indexCount].nickname {
                        let ref = Database.database().reference()
                            .child("Call").child(teamIndex[j])
                        ref.updateChildValues(stmt)
                        break
                    }
                }
                for j in 0..<whenISendOtherTeam.count {
                    if whenISendOtherTeam[j].nickname == personList[indexCount].nickname {
                        let ref = Database.database().reference()
                            .child("Call").child(teamIndexForSend[j])
                        ref.updateChildValues(stmt)
                        break
                    }
                }
                break
            }
        }
    }
     */
    
    // MARK: - Functions
    func setUI() {
        name = "speaker"
        
        answerListTableView.refreshControl = refreshControl
        /*
         let requestList = UIAction(title: "요청됨", handler: { _ in print("요청내역") })
         let denied = UIAction(title: "요청수락", handler: { _ in print("거절함") })
         let canceled = UIAction(title: "통화", handler: { _ in print("취소됨") })
         let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
         
         conditionChangeBtn.menu = UIMenu(title: "상태를 선택해주세요", image: UIImage(systemName: "heart.fill"), identifier: nil, options: .displayInline, children: [requestList, denied, canceled, cancel])
         */
        
        
    }
    func removeArr() {
        
        personList.removeAll()
        whenIReceivedOtherPerson.removeAll()
        whenISendOtherTeam.removeAll()
        
        callTimeArr.removeAll()
        questionArr.removeAll()
        callTimeArrSend.removeAll()
        questionArrSend.removeAll()
        didISent.removeAll()
        
        teamIndex.removeAll()
        teamIndexForSend.removeAll()
        callTeamIndex.removeAll()
        
        //answerListTableView.reloadData()
        
        toGoSegue = "대기"
        name = "speaker"
        myNickname = ""
        myTeamname = ""
        
        fetchedInputUIDToNickName = ""
        
        nowRequestedUid = ""
        callingOtherUid = ""
        amiLeader = false
        
    }
    
    func fetchData() {
        
        removeArr()
        
        let userdb = db.child("user").child(Auth.auth().currentUser!.uid)
        // 내 닉네임 받아오기
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                let teamnameValue = snap.value as? String
                
                if snap.key == "userProfile" {
                    for (key, content) in value! {
                        if key as! String == "nickname" {
                            myNickname = content as! String
                        }
                    }
                }
                if snap.key == "currentTeam" {
                    let value: String = teamnameValue!
                    myTeamname = value
                    checkIamLeader()
                }
            }
            // 팀 알림 가져오기
            let favorTeamList = db.child("Call")
            //queryEqual(toValue: myNickname)
            favorTeamList.observeSingleEvent(of: .value) { [self] snapshot in
                var myCallTime: [[String:String]] = []
                
                // 나와 관련된 call 가져오기
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as? NSDictionary
                    
                    
                    for (key, content) in value! {
                        // 내 팀이 받는 경우를 가져오기(팀은 개인에게 보낼 수 x -> receiverType이 team이면 무조건 receiverNickname은 팀이름 )
                        if key as! String == "receiverNickname" && content as! String == myTeamname + " 팀" {
                            var newValue = value as! [String : String]
                            newValue["teamName"] = snap.key
                            myCallTime.append(newValue)
                            didISent.append(false)
                            break
                        }
                        // 내가 요청한 사람일 경우를 가져오기
                        else if key as! String == "callerUid" && content as! String == Auth.auth().currentUser?.uid {
                            var newValue = value as! [String : String]
                            newValue["teamName"] = snap.key
                            myCallTime.append(newValue)
                            didISent.append(true)
                            break
                        }
                    }
                }
                // 나와 관련된 call에서 데이터 불러오기
                for i in 0..<myCallTime.count {
                    
                    for j in 0..<myCallTime[i].keys.count {
                        // 내가 받은 팀인 경우
                        if myCallTime[i]["receiverNickname"] == myTeamname + " 팀" {
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "team" {
                                
                                // 요청옴은 따로 넘겨줘야함
                                if myCallTime[i]["stmt"] == "통화"
                                    || myCallTime[i]["stmt"] == "대기 중"
                                    || myCallTime[i]["stmt"] == "요청취소됨"
                                    || myCallTime[i]["stmt"] == "요청거절됨" {
                                    
                                    fetchUser(userUID: myCallTime[i]["callerUid"]!, stmt: myCallTime[i]["stmt"]!)
                                    fetchIReceivedOtherUser(userUID: myCallTime[i]["callerUid"]!, stmt: myCallTime[i]["stmt"]!)
                                    callTeamIndex.append(myCallTime[i]["teamName"]!)
                                }
                                else {
                                    fetchUser(userUID: myCallTime[i]["callerUid"]!, stmt: "요청옴")
                                    fetchIReceivedOtherUser(userUID: myCallTime[i]["callerUid"]!, stmt: "요청옴")
                                }
                                callTimeArr.append((myCallTime[i]["callTime"]?.components(separatedBy: ", "))!)
                                questionArr.append((myCallTime[i]["Question"]?.components(separatedBy: ", "))!)
                                if myCallTime[i]["teamName"] != nil {
                                    teamIndex.append(myCallTime[i]["teamName"]!)
                                }
                                fetchNickname(userUID: myCallTime[i]["callerUid"]!)
                                break
                            }
                        }
                        // 내가 팀에 요청한 경우
                        else if myCallTime[i]["callerUid"] == Auth.auth().currentUser?.uid {
                            
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "team" {
                                
                                if myCallTime[i]["stmt"] == "통화"
                                    || myCallTime[i]["stmt"] == "대기 중"
                                    || myCallTime[i]["stmt"] == "요청취소됨"
                                    || myCallTime[i]["stmt"] == "요청거절됨" {
                                    
                                    fetchTeam(teamname: myCallTime[i]["receiverNickname"]!, stmt: myCallTime[i]["stmt"]!)
                                }
                                else {
                                    fetchTeam(teamname: myCallTime[i]["receiverNickname"]!, stmt: "요청됨")
                                }
                                
                                callTimeArrSend.append((myCallTime[i]["callTime"]?.components(separatedBy: ", "))!)
                                questionArrSend.append((myCallTime[i]["Question"]?.components(separatedBy: ", "))!)
                                
                                if myCallTime[i]["teamName"] != nil {
                                    teamIndexForSend.append(myCallTime[i]["teamName"]!)
                                }
                                if myCallTime[i]["stmt"] == "통화" {
                                    callTeamIndex.append(myCallTime[i]["teamName"]!)
                                }
                                
                                break
                            }
                        }
                        
                    }
                    
                }
            }
        }
        answerListTableView.reloadData()
        
        
        
    }
    
    // 2022.05.13 오후 03시 00분 -> 5월 13일 오후 03시 00분
    func dateFormatStringToString(dateString: String) -> String {
        
        let dateStr = dateString // Date 형태의 String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        
        // String -> Date
        let convertDate = dateFormatter.date(from: dateStr)
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "M월 dd일 a h시 m분"
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertStr = myDateFormatter.string(from: convertDate!)
        
        return convertStr
        
    }
    // uid와 stmt로 user 정보 받기
    func fetchUser(userUID: String, stmt: String) {
        var count: Int = 0
        let userdb = db.child("user").child(userUID)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var nickname: String = ""
            var part: String = ""
            var partDetail: String = ""
            var purpose: String = ""
            count += 1
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
            
            let person = Person(nickname: nickname, position: part, callStm: stmt, profileImg: userUID)
            
            personList.append(person)
            answerListTableView.reloadData()
        }
    }
    
    // 팀 이름으로 팀 정보 받아오기
    func fetchTeam(teamname: String, stmt: String) {
        let justTeamname = teamname.replacingOccurrences(of: " 팀", with: "")
        let userdb = db.child("Team").child(justTeamname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var part: String = ""
            var purpose: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? String
                
                if snap.key == "part" {
                    part = value!
                }
                if snap.key == "purpose" {
                    purpose = value!
                }
            }
            purpose = purpose.replacingOccurrences(of: ", ", with: "/")
            purpose += " • " + part + " 구인 중"
            
            let person = Person(nickname: justTeamname, position: purpose, callStm: stmt, profileImg: "")
            personList.append(person)
            whenISendOtherTeam.append(person)
            answerListTableView.reloadData()
        }
    }
    
    // 내가 받은 경우 상대 저장
    func fetchIReceivedOtherUser(userUID: String, stmt: String) {
        let userdb = db.child("user").child(userUID)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var nickname: String = ""
            var part: String = ""
            var partDetail: String = ""
            var purpose: String = ""
            
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
            let person = Person(nickname: nickname, position: part, callStm: stmt, profileImg: userUID)
            
            whenIReceivedOtherPerson.append(person)
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
                            fetchedInputUIDToNickName = content as! String
                            
                        }
                    }
                }
                
            }
        }
    }
    
    
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        
        db.child("Call").observe(.childChanged, with:{ [self] (snapshot) -> Void in
            print("updateFetchData \(updateFetchData)")
            
            if !checkDidload {
                checkDidload = true
            }
            if checkDidload {
                if !updateFetchData {
                    print("패치됨")
                    updateFetchData = true
                    self.fetchData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        self.updateFetchData = false
                    })
                }
            }
            
        })
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ [self] (snapshot) -> Void in
            
            if didUserUpdate {
                print("didUserUpdate 1 \(didUserUpdate)")
                didUserUpdate = true
                print("didUserUpdate 2 \(didUserUpdate)")
                self.fetchData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    self.didUserUpdate = false
                    print("didUserUpdate 3 \(didUserUpdate)")
                })
                
            }
            
            
        })
        db.child("Team").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨 team")
            
            self.fetchData()
            
            
        })
    }
    
    // 내 팀이 있다면 리더인지 확인
    func checkIamLeader() {
        if myTeamname != "" {
            db.child("Team").child(myTeamname).child("leader").observeSingleEvent(of: .value) { [self] snapshot in
                let leaderUid: String! = snapshot.value as? String
                if leaderUid == Auth.auth().currentUser!.uid {
                    amiLeader = true
                }
                fetchLeader(userUID: leaderUid)
            }            
        }
    }
    // uid와 stmt로 user 정보 받기
    func fetchLeader(userUID: String) {
        let userdb = db.child("user").child(userUID)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var nickname: String = ""
            var part: String = ""
            var partDetail: String = ""
            var purpose: String = ""
            
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
            
            let person = Person(nickname: nickname, position: part, callStm: "", profileImg: userUID)
            
            leader = person
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingVC" {
            if let destination = segue.destination as? ChannelWaitingViewController {
                destination.nickname = personList[(sender as? Int)!].nickname
                let position = personList[(sender as? Int)!].position
                destination.position = String(position)
                destination.profile = personList[(sender as? Int)!].profileImg
            }
        }
    }
    // nickname으로 uid찾기
    func fetchNickNameToUID(nickname: String)  {
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var userUID: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                userUID = snap.key
            }
            nowRequestedUid = userUID
        }
    }
    
}

// MARK: - Extensions
extension CallAnswerTeamViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (refreshControl.isRefreshing) {
            self.refreshControl.endRefreshing()
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("여기여기")
        if !personList.isEmpty {
            print(personList[0].callStm)
        }
        return personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AnswerTeamCell", for: indexPath) as! AnswerTableViewCell
        cell.nicknameLabel.text = personList[indexPath.row].nickname
        
        // 같은 학교 처리
        if cell.nicknameLabel.text == "시연" {
            cell.sameSchoolLabel.layer.borderWidth = 0.5
            cell.sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            cell.sameSchoolLabel.textColor = UIColor(named: "purple_184")
            
            cell.sameSchoolLabel.layer.cornerRadius = cell.sameSchoolLabel.frame.height/2
            cell.sameSchoolLabel.text = "같은 학교"
            cell.sameSchoolLabel.isHidden = false
            
        }
        else {
            cell.sameSchoolLabel.isHidden = true
        }
        
        cell.selectionStyle = .none
        
        // 기본 디자인 세팅
        cell.cancelLabel.isHidden = true
        cell.positionLabel.text = personList[indexPath.row].position
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.selectionStyle = .none
        
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.callingStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.callStateBtn.layer.masksToBounds = true
        
        cell.callStateBtn.backgroundColor = .clear
        cell.callStateBtn.layer.borderWidth = 0.5
        cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        cell.callStateBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
        cell.nicknameLabel.textColor = .black
        
        cell.positionLabel.textColor = UIColor(named: "gray_121")
        cell.callStateBtn.isHidden = false
        cell.callingStateBtn.isHidden = true
        
        
        // 개인일 경우
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2
        cell.profileImg.isHidden = false
        
        // 팀일 경우 디자인 세팅
        cell.teamProfileLabel.isHidden = true
        cell.circleTitleView.isHidden = true
        cell.circleTitleView.layer.cornerRadius = cell.circleTitleView.frame.height/2
        cell.circleTitleView.layer.masksToBounds = true
        // 버튼 색상 처리
        if personList[indexPath.row].callStm == "요청거절됨" || personList[indexPath.row].callStm == "요청취소됨" {
            cell.layer.borderWidth = 0.0
            cell.callStateBtn.backgroundColor = .systemGray6
            cell.callStateBtn.setTitleColor(.lightGray, for: .normal)
            cell.cancelLabel.text = "요청 거절됨"
            cell.cancelLabel.textColor = UIColor(named: "red_254")
            cell.nicknameToSameSchoolConst.constant = 6
            cell.cancelLabel.isHidden = false
            cell.callStateBtn.isHidden = true
            
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    cell.profileImg.isHidden = true
                    cell.teamProfileLabel.isHidden = false
                    cell.circleTitleView.isHidden = false
                    
                    let teamFirstName = personList[indexPath.row].nickname[personList[indexPath.row].nickname.startIndex]
                    cell.teamProfileLabel.text = String(teamFirstName)
                    
                }
            }
            // 다른 사람이 우리 팀으로 보낸 경우 -> 개인 표시
            for j in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[j].nickname == personList[indexPath.row].nickname {
                    // kingfisher 사용하기 위한 url
                    let uid: String = personList[indexPath.row].profileImg
                    let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
                    
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                
                                cell.profileImg.kf.setImage(with: url)
                            }
                        }
                    }
                }
            }
            
            
            if personList[indexPath.row].callStm == "요청취소됨" {
                cell.nicknameLabel.textColor = .systemGray5
                cell.positionLabel.textColor = .systemGray5
                cell.profileImg.tintColor = UIColor(named: "gray_light2")
                cell.cancelLabel.text = "요청 취소됨"
                cell.cancelLabel.textColor = UIColor(named: "gray_196")
                
            }
        }
        else if personList[indexPath.row].callStm == "대기 중" {
            // 내가 팀에 보낸 경우 -> 팀 표시
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    cell.profileImg.isHidden = true
                    cell.teamProfileLabel.isHidden = false
                    cell.circleTitleView.isHidden = false
                    
                    let teamFirstName = personList[indexPath.row].nickname[personList[indexPath.row].nickname.startIndex]
                    cell.teamProfileLabel.text = String(teamFirstName)
                    
                }
            }
            // 다른 사람이 우리 팀으로 보낸 경우 -> 개인 표시
            for j in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[j].nickname == personList[indexPath.row].nickname {
                    // kingfisher 사용하기 위한 url
                    let uid: String = personList[indexPath.row].profileImg
                    let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
                    
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            print("error.localizedDescription \(error.localizedDescription)")
                        } else {
                            
                            DispatchQueue.main.async {
                                cell.profileImg.kf.setImage(with: url)
                            }
                        }
                    }
                }
            }
            cell.callStateBtn.layer.borderWidth = 0
            cell.callStateBtn.backgroundColor = UIColor(named: "purple_184")
            cell.callStateBtn.setTitleColor(.white, for: .normal)
        }
        
        else if personList[indexPath.row].callStm == "요청옴" {
            for i in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[i].nickname == personList[indexPath.row].nickname {
                    // kingfisher 사용하기 위한 url
                    let uid: String = personList[indexPath.row].profileImg
                    let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
                    
                    // Fetch the download URL
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            print("error \(error.localizedDescription)")
                        } else {
                            cell.profileImg.kf.setImage(with: url)
                        }
                    }
                }
            }
            
            cell.callStateBtn.layer.borderWidth = 0
            cell.callStateBtn.backgroundColor = UIColor(named: "green_dark")
            cell.callStateBtn.setTitleColor(.white, for: .normal)
            
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    cell.profileImg.isHidden = true
                    cell.teamProfileLabel.isHidden = false
                    cell.circleTitleView.isHidden = false
                    
                    let teamFirstName = personList[indexPath.row].nickname[personList[indexPath.row].nickname.startIndex]
                    cell.teamProfileLabel.text = String(teamFirstName)
                    
                }
            }
            cell.callStateBtn.layer.borderWidth = 0.5
            cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            cell.callStateBtn.setTitleColor(UIColor(named: "gray_51"), for: .normal)
            cell.callStateBtn.backgroundColor = nil
            
        }
        
        else if personList[indexPath.row].callStm == "통화" {
            
            // 내가 팀에 보낸 경우 -> 팀 표시
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    cell.profileImg.isHidden = true
                    cell.teamProfileLabel.isHidden = false
                    cell.circleTitleView.isHidden = false
                    
                    let teamFirstName = personList[indexPath.row].nickname[personList[indexPath.row].nickname.startIndex]
                    cell.teamProfileLabel.text = String(teamFirstName)
                    
                }
            }
            // 다른 사람이 우리 팀으로 보낸 경우 -> 개인 표시
            for j in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[j].nickname == personList[indexPath.row].nickname {
                    // kingfisher 사용하기 위한 url
                    let uid: String = personList[indexPath.row].profileImg
                    let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
                    
                    // Fetch the download URL
                    starsRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                cell.profileImg.kf.setImage(with: url)
                            }
                        }
                    }
                }
            }
            
            
            cell.callingStateBtn.setTitleColor(.white, for: .normal)
            cell.callingStateBtn.layer.cornerRadius = cell.callingStateBtn.frame.height/2
            cell.callingStateBtn.translatesAutoresizingMaskIntoConstraints = false
            cell.callingStateBtn.backgroundColor = UIColor(named: "purple_184")
            cell.callStateBtn.isHidden = true
            cell.callingStateBtn.isHidden = false
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        
        
        if personList[indexPath.row].callStm == "대기 중" {
            let waitingRoomVC = thisStoryboard.instantiateViewController(withIdentifier: "waitingRoomVC") as! ChannelWaitingViewController
            waitingRoomVC.modalPresentationStyle = .fullScreen
            
            // 1. 내가 보낸 경우 -> 팀을 표시해야함
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    
                    // 받는 사람
                    waitingRoomVC.nickname = personList[indexPath.row].nickname
                    let position = personList[indexPath.row].position
                    waitingRoomVC.position = position
                    
                    //personList[indexPath.row].
                    
                    waitingRoomVC.fromPerson = myNickname
                    waitingRoomVC.toPerson = personList[indexPath.row].nickname
                    // 대기 중, 요청됨, 통화도 보낸 사람으로 구분
                    waitingRoomVC.questionArr = questionArrSend[i]
                    waitingRoomVC.callTime = callTimeArrSend[i][0]
                    waitingRoomVC.profile = personList[indexPath.row].profileImg
                    waitingRoomVC.teamIndex = teamIndexForSend[i]
                }
            }
            // 2. 내가 승인한 경우
            for i in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[i].nickname == personList[indexPath.row].nickname {
                    
                    // 받는 사람
                    waitingRoomVC.nickname = personList[indexPath.row].nickname
                    let position = personList[indexPath.row].position
                    waitingRoomVC.position = position
                    
                    waitingRoomVC.fromPerson = personList[indexPath.row].nickname
                    waitingRoomVC.toPerson = myNickname
                    
                    waitingRoomVC.questionArr = questionArr[i]
                    waitingRoomVC.callTime = callTimeArr[i][0]
                    waitingRoomVC.profile = personList[indexPath.row].profileImg
                    waitingRoomVC.teamIndex = teamIndex[i]
                    print("teamIndex[i] \(teamIndex[i])")
                }
            }
            present(waitingRoomVC, animated: true, completion: nil)
            
            
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            let historyVC = thisStoryboard.instantiateViewController(withIdentifier: "teamHistoryVC") as! CallRequstTeamHistoryViewController
            historyVC.modalPresentationStyle = .fullScreen
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname {
                    historyVC.callTime = callTimeArrSend[i]
                    historyVC.teamFormatPerson = personList[indexPath.row]
                    historyVC.questionArr = questionArrSend[i]
                    historyVC.teamIndex = teamIndexForSend[i]
                }
            }
            present(historyVC, animated: true, completion: nil)
        }
        else if personList[indexPath.row].callStm == "통화" {
            let callingVC = storyboard?.instantiateViewController(withIdentifier: "callingTeamVC") as! ChannelTeamViewController
            
            callingVC.nickname = personList[indexPath.row].nickname
            let position = personList[indexPath.row].position
            callingVC.position = String(position)
            
            
            var callCount: Int = -1
            for j in 0...indexPath.row{
                if personList[j].callStm == "통화" {
                    callCount += 1
                }
            }
            
            // 보낸 거랑 어캐 구분..?
            
            
            // 내가 보냈을 때 ->
            for i in 0..<whenISendOtherTeam.count {
                if whenISendOtherTeam[i].nickname == personList[indexPath.row].nickname && whenISendOtherTeam[i].callStm == "통화" {
                    callingVC.teamIndex = callTeamIndex[callCount]
                }
            }
            
            // 내가 받았을 때
            for j in 0..<whenIReceivedOtherPerson.count {
                if whenIReceivedOtherPerson[j].nickname == personList[indexPath.row].nickname && whenIReceivedOtherPerson[j].callStm == "통화" {
                    callingVC.teamIndex = callTeamIndex[callCount]
                }
            }
            
            callingVC.nowEntryPersonUid = Auth.auth().currentUser!.uid
            callingVC.name = name
            callingVC.image = personList[indexPath.row].profileImg
            callingVC.modalPresentationStyle = .fullScreen
            present(callingVC, animated: true, completion: nil)
        }
        else if personList[indexPath.row].callStm == "요청옴" {
            // 리더인 경우 아닌 경우 구분
            if amiLeader {
                let storyboard: UIStoryboard = UIStoryboard(name: "CallAgree", bundle: nil)
                if let nextView = storyboard.instantiateInitialViewController() as? UINavigationController,
                   let nextViewChild = nextView.viewControllers.first as? CallAgreeViewController {
                    
                    for j in 0..<whenIReceivedOtherPerson.count {
                        if whenIReceivedOtherPerson[j].nickname == personList[indexPath.row].nickname {
                            nextViewChild.times = callTimeArr[j]
                            nextViewChild.questionArr = questionArr[j]
                            nextViewChild.teamName = teamIndex[j]
                            nextViewChild.callerNickname = personList[j].nickname
                        }
                    }
                    
                    nextView.modalPresentationStyle = .fullScreen
                    self.present(nextView, animated: true, completion: nil)
                }
            }
            else {
                let historyVC = thisStoryboard.instantiateViewController(withIdentifier: "historyVC") as! CallRequstHistoryViewController
                historyVC.modalPresentationStyle = .fullScreen
                for i in 0..<whenIReceivedOtherPerson.count {
                    
                    if whenIReceivedOtherPerson[i].nickname == personList[indexPath.row].nickname {
                        historyVC.callTime = callTimeArr[i]
                        historyVC.person = leader
                        historyVC.questionArr = questionArr[i]
                        historyVC.teamIndex = teamIndex[i]
                        historyVC.isTeamMemberWaiting = true
                    }
                }
                present(historyVC, animated: true, completion: nil)
            }
            
        }
        return indexPath
    }
}


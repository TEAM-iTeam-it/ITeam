//
//  CallAnswerViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import Kingfisher

class CallAnswerViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var answerListTableView: UITableView!
    
    // MARK: - Properties
    var updateFetchData: Int = 0
    var personList: [Person] = []
    var whenIReceivedOtherPerson: [Person] = []
    var whenISendOtherPerson: [Person] = []
    var toGoSegue: String = "대기"
    let db = Database.database().reference()
    
    var name: String = "speaker"
    var myNickname = ""
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    var callTimeArr: [[String]] = []
    var questionArr: [[String]] = []
    var callTimeArrSend: [[String]] = []
    var questionArrSend: [[String]] = []
    var didISent: [Bool] = []
    var fetchedInputUIDToNickName: String = ""
    var teamIndex: [String] = []
    var teamIndexForSend: [String] = []
    var nowRequestedUid: String = "" {
        willSet(newValue) {            callingOtherUid = newValue
        }
    }
    var addedFetchData: Int = 0
    var didAddedData: Bool = true
    var callingOtherUid: String = ""
    var url = "gs://iteam-test.appspot.com/user_profile_image/"
    var checkLoadNow: Bool = false
    var didUserUpdate: Bool = false
    private var refreshControl = UIRefreshControl()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        answerListTableView.delegate = self
        answerListTableView.dataSource = self
        
        fetchData()
        
        setUI()
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
    }
    
    // MARK: - @IBAction Properties
    @IBAction func removeCurrentUserData(_ sender: UIButton) {
        
        /*
        let emptyCurrentTeam: [String:String] = ["currentTeam":""]
        db.child("user").child(Auth.auth().currentUser!.uid).updateChildValues(emptyCurrentTeam)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("friendsList").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("likeTeam").removeValue()
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").removeValue()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let currentDateString = formatter.string(from: Date())
        
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestStmt").setValue("기본")
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestTime").setValue(currentDateString)
        db.child("user").child(Auth.auth().currentUser!.uid)
            .child("memberRequest").child("0").child("requestUID").setValue("기본")
        
        db.child("user").child(Auth.auth().currentUser!.uid).child("userTeam")
            .removeValue()
   
        */
        // call에서 본인 기록 있으면 찾아서 삭제
        
        
        // 리더일 때 팀 삭제
        db.child("user").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                if snap.key == "currentTeam" {
                    let teamname: String = snap.value as? String ?? ""
                    print("teamname 여기여 \(teamname)")
                    if teamname != nil && teamname != "" {
                        self.db.child("Team").child(teamname).observeSingleEvent(of: .value) { snapshot in
                            
                            for child in snapshot.children {
                                let snap = child as! DataSnapshot
                                let value = snap.value as? String
                                // 내가 리더일 때 팀 삭제
                                if snap.key == "leader" {
                                    if value == Auth.auth().currentUser!.uid {
                                        print("리더다 리더")
                                        //self.db.child("Team").child(teamname).removeValue()
                                        break
                                    }
                                    else {
                                        print("아니다 아니야")
                                    }
                                }
                            }
                        }
                    }
        
                }
            }
        }
        
    }
    
    // MARK: - Functions
    func setUI() {
        name = "speaker"
        
        answerListTableView.refreshControl = refreshControl
    }
    
    func removeArr() {
        personList.removeAll()
        whenIReceivedOtherPerson.removeAll()
        whenISendOtherPerson.removeAll()
        callTimeArr.removeAll()
        questionArr.removeAll()
        callTimeArrSend.removeAll()
        questionArrSend.removeAll()
        didISent.removeAll()
        teamIndex.removeAll()
        teamIndexForSend.removeAll()
    }

    
    func fetchData() {
        
        removeArr()
        let userdb = db.child("user").child(Auth.auth().currentUser!.uid)
        
        // 내 닉네임 받아오기
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                if snap.key == "userProfile" {
                    for (key, content) in value! {
                        if key as! String == "nickname" {
                            myNickname = content as! String
                        }
                    }
                    
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
                        
                        // 내가 받는 사람일 경우를 가져오기
                        if key as! String == "receiverNickname" && content as! String == myNickname {
                            var newValue = value as! [String : String]
                            newValue["teamName"] = snap.key
                            myCallTime.append(newValue)
                            didISent.append(false)
                            break
                        }
                        // 내가 요청한 사람일 경우를 가져오기
                        if key as! String == "callerUid" && content as? String == Auth.auth().currentUser?.uid {
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
                        // 내가 받은 경우
                        if myCallTime[i]["receiverNickname"] == myNickname {
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "personal" {
                          
                                if myCallTime[i]["stmt"] == "통화"
                                    || myCallTime[i]["stmt"] == "대기 중"
                                    || myCallTime[i]["stmt"] == "요청취소됨"
                                    || myCallTime[i]["stmt"] == "요청거절됨" {
                                    
                                    fetchUser(userUID: myCallTime[i]["callerUid"]!, stmt: myCallTime[i]["stmt"]!)
                                    fetchIReceivedOtherUser(userUID: myCallTime[i]["callerUid"]!, stmt: myCallTime[i]["stmt"]!)
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
                        // 내가 보낸 경우
                        if myCallTime[i]["callerUid"] == Auth.auth().currentUser?.uid {
                            
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "personal" {
                                if myCallTime[i]["stmt"] == "통화"
                                    || myCallTime[i]["stmt"] == "대기 중"
                                    || myCallTime[i]["stmt"] == "요청취소됨"
                                    || myCallTime[i]["stmt"] == "요청거절됨" {
                                    
                                    fetchUID(nickname: myCallTime[i]["receiverNickname"]!, stmt: myCallTime[i]["stmt"]!)
                                }
                                else {
                                    fetchUID(nickname: myCallTime[i]["receiverNickname"]!, stmt: "요청됨")
                                }
                                
                                callTimeArrSend.append((myCallTime[i]["callTime"]?.components(separatedBy: ", "))!)
                                questionArrSend.append((myCallTime[i]["Question"]?.components(separatedBy: ", "))!)
                                
                                if myCallTime[i]["teamName"] != nil {
                                    teamIndexForSend.append(myCallTime[i]["teamName"]!)
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
            
            personList.append(person)
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
            
            let person = Person(nickname: nickname, position: part, callStm: stmt, profileImg: "")
            
            whenIReceivedOtherPerson.append(person)
        }
    }
    // 내가 보낸 경우 상대 저장
    func fetchISendOtherUser(userUID: String, stmt: String) {
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
            
            let person = Person(nickname: nickname, position: part, callStm: stmt, profileImg: "")
            
            whenISendOtherPerson.append(person)
        }
    }
    // nickname으로 uid 찾기
    func fetchUID(nickname: String, stmt: String) {
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var userUID: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                userUID = snap.key 
            }
            fetchUser(userUID: userUID, stmt: stmt)
            fetchISendOtherUser(userUID: userUID, stmt: stmt)
        }
        
    }
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

        db.child("Call").observe(.childAdded, with: { [self] snapshot -> Void in
            if addedFetchData == 0 {
                checkLoadNow = true
                addedFetchData += 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    self.didAddedData = true
                    self.addedFetchData = 1
                    self.checkLoadNow = false
                })
            }
            else if addedFetchData == 1 {
                didAddedData = true
                self.fetchData()
                addedFetchData += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    self.addedFetchData = 1
                    
                    self.didAddedData = false
                })} })
        
        db.child("Call").observe(.childChanged, with: { [self] (snapshot) -> Void in
            if !checkLoadNow && !didAddedData {
                if updateFetchData == 0 {
                    updateFetchData += 1
                    self.fetchData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                        self.updateFetchData = 0
                    })
                }
            }
        })
        
         
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ [self] (snapshot) -> Void in
            if !didUserUpdate {
                didUserUpdate = true
                self.fetchData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    self.didUserUpdate = false
                })
            }
            
        })
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
extension CallAnswerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AnswerPersonCell", for: indexPath) as! AnswerTableViewCell
        
        cell.profileImg.layer.cornerRadius = cell.profileImg.frame.height/2
        cell.nicknameLabel.text = personList[indexPath.row].nickname
        
        let uid: String = personList[indexPath.row].profileImg
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        
        starsRef.downloadURL { [self] url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    cell.profileImg.kf.setImage(with: url)
                }
            }
        }
        
        
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
        
        cell.cancelLabel.isHidden = true
        cell.positionLabel.text = personList[indexPath.row].position
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.selectionStyle = .none
        
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.callingStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.callStateBtn.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        cell.callStateBtn.backgroundColor = .clear
        cell.callStateBtn.layer.borderWidth = 0.5
        cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        cell.callStateBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
        cell.nicknameLabel.textColor = .black
        
        cell.positionLabel.textColor = UIColor(named: "gray_121")
        
        cell.profileImg.image = UIImage(named: "\(personList[indexPath.row].profileImg)")
        cell.profileImg.image?.withRenderingMode(.alwaysTemplate)
        cell.callStateBtn.isHidden = false
        cell.callingStateBtn.isHidden = true
        cell.grayImageView.isHidden = true
        cell.grayImageView.layer.cornerRadius = cell.grayImageView.frame.height/2
        
        
        
        
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
            
            if personList[indexPath.row].callStm == "요청취소됨" {
                cell.nicknameLabel.textColor = .systemGray5
                cell.positionLabel.textColor = .systemGray5
               // cell.profileImg.tintColor = UIColor(named: "gray_light2")
                cell.cancelLabel.text = "요청 취소됨"
                cell.cancelLabel.textColor = UIColor(named: "gray_196")
                cell.grayImageView.isHidden = false
            }
        }
        else if personList[indexPath.row].callStm == "대기 중" {
            cell.callStateBtn.layer.borderWidth = 0
            cell.callStateBtn.backgroundColor = UIColor(named: "purple_184")
            cell.callStateBtn.setTitleColor(.white, for: .normal)
        }
        
        else if personList[indexPath.row].callStm == "요청옴" {
            cell.callStateBtn.layer.borderWidth = 0
            cell.callStateBtn.backgroundColor = UIColor(named: "green_dark")
            cell.callStateBtn.setTitleColor(.white, for: .normal)
            
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            cell.callStateBtn.layer.borderWidth = 0.5
            cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            cell.callStateBtn.setTitleColor(UIColor(named: "gray_51"), for: .normal)
            cell.callStateBtn.backgroundColor = nil
        }
    
        
        else if personList[indexPath.row].callStm == "통화" {
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
            // 수정 필요-> 내가 받은 경우, 보낸 경우 구분해야함
            let waitingRoomVC = thisStoryboard.instantiateViewController(withIdentifier: "waitingRoomVC") as! ChannelWaitingViewController
            waitingRoomVC.modalPresentationStyle = .fullScreen
            
            
            // 1. 내가 보낸 경우
            for i in 0..<whenISendOtherPerson.count {
                
                if whenISendOtherPerson[i].nickname == personList[indexPath.row].nickname {
                    // 받는 사람
                    waitingRoomVC.nickname = personList[indexPath.row].nickname
                    let position = personList[indexPath.row].position
                    waitingRoomVC.position = position
                    
                    
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
                    
                    //personList[indexPath.row].
                    
                    waitingRoomVC.fromPerson = personList[indexPath.row].nickname
                    waitingRoomVC.toPerson = myNickname
                    
                    waitingRoomVC.questionArr = questionArr[i]
                    waitingRoomVC.callTime = callTimeArr[i][0]
                    waitingRoomVC.profile = personList[indexPath.row].profileImg
                    waitingRoomVC.teamIndex = teamIndex[i]
                    
                }
            }
            present(waitingRoomVC, animated: true, completion: nil)
            
            
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            let historyVC = thisStoryboard.instantiateViewController(withIdentifier: "historyVC") as! CallRequstHistoryViewController
            historyVC.modalPresentationStyle = .fullScreen
            
            for i in 0..<whenISendOtherPerson.count {
                if whenISendOtherPerson[i].nickname == personList[indexPath.row].nickname {
                
                    historyVC.callTime = callTimeArrSend[i]
                    historyVC.person = personList[indexPath.row]
                    historyVC.questionArr = questionArrSend[i]
                    historyVC.teamIndex = teamIndexForSend[i]
                    
                }
            }
            
            
            present(historyVC, animated: true, completion: nil)
        }
        else if personList[indexPath.row].callStm == "통화" {
            let callingVC = storyboard?.instantiateViewController(withIdentifier: "callingVC") as! ChannelViewController
            callingVC.modalPresentationStyle = .fullScreen
            callingVC.nickname = personList[indexPath.row].nickname
            callingVC.otherPersonUID = personList[indexPath.row].profileImg
            let position = personList[indexPath.row].position
            callingVC.position = String(position)
           
        
            callingVC.name = name
            callingVC.profile = personList[indexPath.row].profileImg
            print(personList[indexPath.row].profileImg)
            
            present(callingVC, animated: true, completion: nil)
            
        }
        else if personList[indexPath.row].callStm == "요청옴" {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "CallAgree", bundle: nil)
            if let nextView = storyboard.instantiateInitialViewController() as? UINavigationController,
               let nextViewChild = nextView.viewControllers.first as? CallAgreeViewController {
                var indexCount = -1
                
                for i in 0..<whenIReceivedOtherPerson.count {
                    if whenIReceivedOtherPerson[i].nickname == personList[indexPath.row].nickname {
                        indexCount = i
                    }
                }
               
                nextViewChild.times = callTimeArr[indexCount]
                nextViewChild.questionArr = questionArr[indexPath.row]
                nextViewChild.teamName = teamIndex[indexCount]
                nextViewChild.callerNickname = personList[indexCount].nickname
                
                print(callTimeArr)
                
                nextView.modalPresentationStyle = .fullScreen
                self.present(nextView, animated: true, completion: nil)
            }
            
        }
        return indexPath
    }
}

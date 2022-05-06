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

class CallAnswerTeamViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var conditionChangeBtn: UIButton!
    @IBOutlet weak var answerListTableView: UITableView!
    
    var personList: [Person] = []
    var toGoSegue: String = "대기"
    let db = Database.database().reference()
    
    // [삭제 예정] 시연을 위한 변수
    var counter:Int = 0
    var name: String = ""
    var myNickname = ""
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    var callTimeArr: [[String]] = []
    var questionArr: [[String]] = []
    var callTimeArrSend: [[String]] = []
    var questionArrSend: [[String]] = []
    var didISent: [Bool] = []
    var hasReceived: Bool = false
    var fetchedInputUIDToNickName: String = ""
    var teamIndex: [String] = []
    var teamIndexForSend: [String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerListTableView.delegate = self
        answerListTableView.dataSource = self
        
        setUI()
        fetchData()
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
    }
    override func viewWillAppear(_ animated: Bool) {
        answerListTableView.reloadData()
    }
    
    func setUI() {
        counter = 0
        name = "speaker"
        
        let requestList = UIAction(title: "요청됨", handler: { _ in print("요청내역") })
        let denied = UIAction(title: "요청수락", handler: { _ in print("거절함") })
        let canceled = UIAction(title: "통화", handler: { _ in print("취소됨") })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
        
        conditionChangeBtn.menu = UIMenu(title: "상태를 선택해주세요", image: UIImage(systemName: "heart.fill"), identifier: nil, options: .displayInline, children: [requestList, denied, canceled, cancel])
        // Do any additional setup after loading the view.
        
        
        let url = "gs://iteam-test.appspot.com/user_profile_image/7DNtefn5EBPbSI8By0g1IeVS0Jg1.jpg"
        //imageView.setImage(with: url)
        
    }
    
    func fetchData() {
        
        personList.removeAll()
        
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
                var receiverType: [String] = []
                
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
                            hasReceived = true
                            didISent.append(false)
                            break
                        }
                        // 내가 요청한 사람일 경우를 가져오기
                        if key as! String == "callerUid" && content as! String == Auth.auth().currentUser?.uid {
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
                        if myCallTime[i]["receiverNickname"] == myNickname {
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "team" {
                                fetchUser(userUID: myCallTime[i]["callerUid"]!, stmt: myCallTime[i]["stmt"]!)
                                
                                callTimeArr.append((myCallTime[i]["callTime"]?.components(separatedBy: ", "))!)
                                questionArr.append((myCallTime[i]["Question"]?.components(separatedBy: ", "))!)
                                if myCallTime[i]["teamName"] != nil {
                                    teamIndex.append(myCallTime[i]["teamName"]!)
                                }
                                fetchNickname(userUID: myCallTime[i]["callerUid"]!)
                                break
                            }
                        }
                        if myCallTime[i]["callerUid"] == Auth.auth().currentUser?.uid {
                            
                            if myCallTime[i]["receiverType"] != nil && myCallTime[i]["receiverType"] == "team" {
                                fetchUID(nickname: myCallTime[i]["receiverNickname"]!, stmt: myCallTime[i]["stmt"]!)
                                callTimeArrSend.append((myCallTime[i]["callTime"]?.components(separatedBy: ", "))!)
                                questionArr.append((myCallTime[i]["Question"]?.components(separatedBy: ", "))!)
                                
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
            
            var person = Person(nickname: nickname, position: part, callStm: stmt, profileImg: "")
            
            personList.append(person)
            answerListTableView.reloadData()
        }
    }
    // nickname으로 uid 찾기
    func fetchUID(nickname: String, stmt: String) {
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var userUID: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                userUID = snap.key
            }
            fetchUser(userUID: userUID, stmt: stmt)
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
        personList.removeAll()
        db.child("Call").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchData()
            }
        })
        db.child("user").child(Auth.auth().currentUser!.uid).observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchData()
            }
            
        })
    }
    
    // 삭제할 코드 - 유닛 테스트
    @IBAction func testSignout(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("로그아웃됨. 앱이 종료됩니다")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        sleep(2)
        exit(0)
    }
    
    
    
    // [삭제 예정] 시연을 위한 nextbutton
    @IBAction func nextBtn(_ sender: UIButton) {
        if counter == 0 {
            personList[0].callStm = "통화대기"
            answerListTableView.reloadData()
            toGoSegue = "통화대기"
            counter += 1
        }
        if counter == 1{
            personList[0].callStm = "통화시작"
            answerListTableView.reloadData()
            toGoSegue = "통화시작"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingVC" {
            if let destination = segue.destination as? ChannelWaitingViewController {
                // let cell = sender as! AnswerTableViewCell
                destination.nickname = personList[(sender as? Int)!].nickname
                // var position = personList[(sender as? Int)!].position.split(separator: "•")
                var position = personList[(sender as? Int)!].position
                destination.position = String(position)
                destination.profile = personList[(sender as? Int)!].profileImg
            }
        }
        else if segue.identifier == "startVC" {
            if let destination = segue.destination as? ChannelViewController {
                // let cell = sender as! AnswerTableViewCell
                destination.nickname = personList[(sender as? Int)!].nickname
                var position = personList[(sender as? Int)!].position
                destination.position = String(position)
                destination.name = name
                destination.profile = personList[(sender as? Int)!].profileImg
                
            }
        }
        
    }
    // nickname으로 uid찾기
    func fetchUID(nickname: String) -> String {
        var userUID: String = ""
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                
                userUID = snap.key
            }
        }
        return userUID
    }
    
    
}

extension CallAnswerTeamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        
        
        cell.positionLabel.text = personList[indexPath.row].position
        //   cell.callStateBtn.titleLabel?.font = .systemFont(ofSize: 13)
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.selectionStyle = .none
        
        cell.callStateBtn.backgroundColor = .clear
        cell.callStateBtn.layer.borderWidth = 0.5
        cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        cell.callStateBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
        cell.nicknameLabel.textColor = .black
        
        cell.positionLabel.textColor = UIColor(named: "gray_121")
        
        cell.profileImg.image = UIImage(named: "\(personList[indexPath.row].profileImg)")
        cell.profileImg.image?.withRenderingMode(.alwaysTemplate)
        
        // 버튼 색상 처리
        if personList[indexPath.row].callStm == "요청거절됨" || personList[indexPath.row].callStm == "요청취소됨" {
            cell.layer.borderWidth = 0.0
            cell.callStateBtn.backgroundColor = .systemGray6
            cell.callStateBtn.setTitleColor(.lightGray, for: .normal)
            
            if personList[indexPath.row].callStm == "요청취소됨" {
                cell.nicknameLabel.textColor = .systemGray5
                cell.positionLabel.textColor = .systemGray5
                cell.profileImg.tintColor = UIColor(named: "gray_light2")
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
            cell.callStateBtn.setTitleColor(.white, for: .normal)
            cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
            cell.callStateBtn.translatesAutoresizingMaskIntoConstraints = false
            
            // 버튼 그라디언트
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.callStateBtn.bounds
            gradientLayer.colors = [UIColor(named: "purple_184")?.cgColor, UIColor(named: "green_151")?.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = cell.callStateBtn.bounds
            cell.callStateBtn.layer.insertSublayer(gradientLayer, at: 0)
            cell.callStateBtn.layer.masksToBounds = true
            
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
            if didISent[indexPath.row] {
                
                var indexCount = -1
                
                for i in 0...indexPath.row {
                    if personList[i].callStm == "대기 중" {
                        indexCount += 1
                    }
                }
                
                // 받는 사람
                waitingRoomVC.nickname = personList[indexPath.row].nickname
                var position = personList[indexPath.row].position
                waitingRoomVC.position = position
                
                //personList[indexPath.row].
                
                waitingRoomVC.fromPerson = myNickname
                waitingRoomVC.toPerson = personList[indexPath.row].nickname
                waitingRoomVC.questionArr = questionArr[indexPath.row]
                waitingRoomVC.callTime = callTimeArrSend[indexCount][0]
                
                // waitingRoomVC.profile = personList[(sender as? Int)!].profileImg
            }
            // 2. 내가 승인한 경우
            else {
                var indexCount = -1
                
                for i in 0...indexPath.row {
                    if personList[i].callStm == "대기 중" {
                        indexCount += 1
                    }
                }
                
                // 받는 사람
                waitingRoomVC.nickname = personList[indexPath.row].nickname
                var position = personList[indexPath.row].position
                waitingRoomVC.position = position
                
                //personList[indexPath.row].
                
                waitingRoomVC.fromPerson = personList[indexPath.row].nickname
                waitingRoomVC.toPerson = myNickname
                waitingRoomVC.questionArr = questionArr[indexPath.row]
                waitingRoomVC.callTime = callTimeArr[indexCount][0]
            }
            
            present(waitingRoomVC, animated: true, completion: nil)
            
            
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            let historyVC = thisStoryboard.instantiateViewController(withIdentifier: "historyVC") as! CallRequstHistoryViewController
            historyVC.modalPresentationStyle = .fullScreen
            
            var indexCount = -1
            
            for i in 0...indexPath.row {
                if personList[i].callStm == "요청됨" {
                    indexCount += 1
                }
            }
            historyVC.callTime = callTimeArrSend[indexCount]
            historyVC.person = personList[indexPath.row]
            historyVC.questionArr = questionArr[indexPath.row]
            historyVC.teamIndex = teamIndexForSend[indexCount]
            
            present(historyVC, animated: true, completion: nil)
        }
        else if personList[indexPath.row].callStm == "통화" {
            performSegue(withIdentifier: "startVC", sender: indexPath.row)
        }
        else if personList[indexPath.row].callStm == "요청옴" {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "CallAgree", bundle: nil)
            if let nextView = storyboard.instantiateInitialViewController() as? UINavigationController,
               let nextViewChild = nextView.viewControllers.first as? CallAgreeViewController {
                var indexCount = -1
                
                for i in 0...indexPath.row {
                    if personList[i].callStm == "요청옴" {
                        indexCount += 1
                    }
                }
                nextViewChild.times = callTimeArr[indexCount]
                nextViewChild.questionArr = questionArr[indexPath.row]
                nextViewChild.teamName = teamIndex[indexCount]
                nextViewChild.callerNickname = fetchedInputUIDToNickName
                
                nextView.modalPresentationStyle = .fullScreen
                self.present(nextView, animated: true, completion: nil)
            }
            
        }
        return indexPath
    }
}

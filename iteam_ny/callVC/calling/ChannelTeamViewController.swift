//
//  ChannelTeamViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/08.
//

import UIKit
import AgoraRtcKit
import FirebaseAuth
import FirebaseDatabase

class ChannelTeamViewController: UIViewController {
    @IBOutlet var callButtons: [UIButton]!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeExplainLabel: UILabel!
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    
    // 입장할 때 speaker로 받기
    var name: String = ""
    
    // 내꺼만 띄우거나 상대거만 띄워야함
    var users: [Person] = []
    var user = Person(nickname: "", position: "", callStm: "", profileImg: "")
    var nickname: String = "jhkhkhkj"
    var position: String = "ghjghjgjg"
    var image: String = ""
    
    // agoraRTtcKit
    var agkit: AgoraRtcEngineKit?
    
    // uid
    var userID: UInt = 0
    
    // 말하고 있는 사람들
    var activeSpeakers: Array<UInt> = []
    
    // 말하고 있는 사람
    var activeSpeaker: UInt?
    
    // 듣고 있는 사람
    var activeAudience: Set<UInt> = []
    
    // 상대 UID -> 팀일 경우 팀장, 개인일 경우 상대 uid
    var otherPersonUID: String = ""
    
    // 말하는 사람인지 듣는 사람인지 역할
    lazy var role:AgoraClientRole = name == "speaker" || name == "speaker2" ? .broadcaster : .audience
    
    let db = Database.database().reference()
    
    var myNickname: String = ""
    var teamIndex: String = ""
    var nowEntryPersonUid: String = ""
    var participantList: [Person] = []
    var thisCallTeamname: String = "" {
        willSet(newValue) {
            checkIamLeader(teamname: newValue)
        }
    }
    // 리더인지, caller(개인) 인지
    var amiLeader: Bool = false
    // caller, leader 모두 아닐 때 신고하기 버튼 없앰
    var amiCaller: Bool = true {
        willSet(newValue) {
            print("amiCaller \(amiCaller)")
            if newValue == false && !amiLeader {
                DispatchQueue.main.async {
                    self.reportButton.isHidden = true
                }
            }
        }
    }
    // 타이머
    var secondsLeft: Int = 180
    var timer: Timer?
    
    var didMuteButtonTapped: Bool = false
    var didSpeakerButtonTapped: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        
        // collectionview 세팅
       // collection.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = collection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        
        // 참여한 사람 추가 밑 불러오기
        addParticipant()
        fetchParticipant()
        
        // 팀 이름 받아와서 본인이 리더인지 확인
        fetchTeamName()
        
        fetchNickname(userUID: Auth.auth().currentUser!.uid)
        
        // 아고라 세팅
        requestMicrophonePermission()
        connectAgora()
        joinChannel()
        
        setUI()
        
        fetchNickNameToUID(nickname: nickname)
        
        // 바뀐 데이터 불러오기
        fetchChangedData()
        
        // 타이머 시작
        timerButtonClicked()
        
    }
    
    func setUI() {
        for i in 0..<callButtons.count {
            callButtons[i].layer.cornerRadius = callButtons[0].frame.height/2
        }
        leaveButton.layer.cornerRadius = leaveButton.frame.height/2
        
        
    }
    @IBAction func leaveChannel(_ sender: UIButton) {
        self.agkit?.createRtcChannel("testToken11")?.leave()
        self.agkit?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        
        removeParticipant()
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "CallClosedVC") as! CallClosedViewController
        // 통화 끝났을 때 개인, 팀원은 그냥 종료/팀장은 개인을 팀원으로 추가할지!
        if amiLeader {
            popupVC.otherPersonUID = otherPersonUID
            popupVC.amILeader = true
            popupVC.modalPresentationStyle = .overFullScreen
            present(popupVC, animated: false, completion: nil)
        }
        else {
            dismiss(animated: true)
        }
    }
    @IBAction func reportPerson(_ sender: UIButton) {
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "CallReportVC") as! CallReportViewController
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    @IBAction func muteVolumeDidTapped(_ sender: UIButton) {
        if didMuteButtonTapped {
            sender.backgroundColor = UIColor(named: "gray_229")
            agkit!.muteLocalAudioStream(false)
            didMuteButtonTapped = false

        }
        else {
            sender.backgroundColor = UIColor(named: "gray_121")
            agkit!.muteLocalAudioStream(true)
            didMuteButtonTapped = true
        }
    }
    @IBAction func switchSpeakerDidTapped(_ sender: UIButton) {
        if didSpeakerButtonTapped {
            sender.backgroundColor = UIColor(named: "gray_229")
            agkit!.setEnableSpeakerphone(false)
            didSpeakerButtonTapped = false

        }
        else {
            sender.backgroundColor = UIColor(named: "gray_121")
            agkit!.setEnableSpeakerphone(true)
            didSpeakerButtonTapped = true
        }
        
    }
    
    func updateTimerLabel() {
        var minutes = self.secondsLeft / 60
        var seconds = self.secondsLeft % 60
        
        if self.secondsLeft < 10 {
            self.timerLabel.textColor = UIColor.red
        } else {
            self.timerLabel.textColor = UIColor.black
        }
        
        if self.secondsLeft > 0 {
            self.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            self.timerLabel.isHidden = true
            self.timeExplainLabel.text = "통화시간이 종료되었습니다"
        }
        
    }
    
    func timerButtonClicked() {
        updateTimerLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            // 30 -> 1로 수정해야함
            self.secondsLeft -= 1
            self.updateTimerLabel()
            
            if self.secondsLeft == 0 {
                self.leaveChannel(UIButton())
            }
        }
    }
    
    // 참여하는 사람에 추가
    func addParticipant() {
        
        var updateString: String = ""
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        db.child("Call").child(teamIndex).child("participant").observeSingleEvent(of: .value) { [self] snapshot in
            var lastDatas: [String] = []
            var lastData: String! = snapshot.value as? String
            if lastData  != nil {
                lastDatas = lastData.components(separatedBy: ", ")
            }
            if !lastDatas.contains(nowEntryPersonUid) {
                if snapshot.value as? String == nil || snapshot.value as? String == "" {
                    var lastData: String! = snapshot.value as? String
                    updateString = nowEntryPersonUid
                }
                else {
                    var lastData: String! = snapshot.value as? String
                    lastData += ", \(nowEntryPersonUid)"
                    updateString = lastData
                }
                let values: [String: Any] = [ "participant": updateString ]
                // 데이터 추가
                self.db.child("Call").child(teamIndex).updateChildValues(values)
            }
        }
        
    }
    
    // 참여하는 사람에서 삭제
    func removeParticipant() {
        var updateString: String = ""
        var lastDatas: [String] = []
        
        // 데이터 받아와서 이미 있으면 지워주기
        db.child("Call").child(teamIndex).child("participant").observeSingleEvent(of: .value) { [self] snapshot in
            if snapshot.value as? String != nil {
                var lastData: String! = snapshot.value as? String
                lastDatas = lastData.components(separatedBy: ", ")
                
                for i in 0..<lastDatas.count {
                    if lastDatas[i] == Auth.auth().currentUser!.uid {
                        lastDatas.remove(at: i)
                        break
                    }
                }
                for i in 0..<lastDatas.count {
                    if lastDatas[i] == "" {
                        lastDatas.remove(at: i)
                        break
                    }
                    if i == 0 {
                        updateString += lastDatas[i]
                    }
                    else {
                        updateString += ", \(lastDatas[i])"
                    }
                }
            }
            let values: [String: Any] = [ "participant": updateString ]
            // 데이터 추가
            self.db.child("Call").child(teamIndex).updateChildValues(values)
            fetchParticipant()
        }
    }
    
    // 참여하는 사람 받아오기
    func fetchParticipant() {
        
        var updateString: String = ""
        
        db.child("Call").child(teamIndex).child("participant").observeSingleEvent(of: .value) { [self] snapshot in
            var lastDatas: [String] = []
            if let participant = snapshot.value as? String {
                if participant != nil && participant != ""{
                    lastDatas = participant.components(separatedBy: ", ")
                    for i in 0..<lastDatas.count {
                        fetchUser(userUID: lastDatas[i])
                    }
                }
            }
                    
        }
    }
    
    // uid로 user 정보 받기
    func fetchUser(userUID: String) {
        participantList.removeAll()
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
                partDetail += part
                
            }
            
            var person = Person(nickname: nickname, position: partDetail, callStm: "", profileImg: userUID)
            
            participantList.append(person)
            collection.reloadData()
        }
    }
    
    // 채널 연결
    func connectAgora() {
        // 앱아이디로 실행
        agkit = AgoraRtcEngineKit.sharedEngine(withAppId: "1bc8bc4e2bff4c63a191db9a6fc44cd8", delegate: self)
        // 오디오 가능하게 설정
        agkit?.enableAudio()
        // 오디오 볼륨설정
        agkit?.enableAudioVolumeIndication(1000, smooth: 3, report_vad: true)
        // 채널 프로필
        agkit?.setChannelProfile(.liveBroadcasting)
        // 현재 역할 설정
        agkit?.setClientRole(role)
    }
    // 음성 권한
    func requestMicrophonePermission(){
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                print("Mic: 권한 허용")
            } else {
                print("Mic: 권한 거부")
            }
        })
    }
    // 채널 입장
    func joinChannel() {
        agkit?.joinChannel(byToken: "0061bc8bc4e2bff4c63a191db9a6fc44cd8IADIU3Vf9JAbwXD8VYAAY2uYridTl8X/pgkDaRPX0fkJiTfvbuoAAAAAEACXaa56o/6EYgEAAQCj/oRi",
                           channelId: "testToken11",
                           info: nil,
                           uid: userID,
                           joinSuccess: {(_, uid, elapsed) in
            self.userID = uid
            if self.role == .audience {
                self.activeAudience.insert(uid)
            } else {
                self.activeSpeakers.append(uid)
            }
            self.collection.reloadData()
            print("joinChannel")
        })
    }
    // 닉네임으로 uid 반환
    func fetchNickNameToUID(nickname: String)  {
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var userUID: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                userUID = snap.key
            }
            otherPersonUID = userUID
        }
    }
    
    // uid로 personlist에 Person 추가
    func fetchNickname(userUID: String)  {
        let userdb = db.child("user").child(userUID)
        var part: String = ""
        var detailPart: String = ""
        var imageName: String = userUID
        
        
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                if snap.key == "userProfile" {
                    for (key, content) in value! {
                        if key as! String == "nickname" {
                            myNickname = content as! String
                            
                        }
                        if key as! String == "part" {
                            part = content as! String
                        }
                        if key as! String == "partDetail" {
                            detailPart = content as! String
                        }
                    }
                }
            }
            if part == "개발자" {
                detailPart += part
            }
            user = Person(nickname: myNickname, position: detailPart, callStm: "", profileImg: imageName)
            users.append(user)
        }
    }
    
    // 바뀐 데이터 불러오기
    func fetchChangedData() {
        db.child("Call").observe(.childChanged, with:{ (snapshot) -> Void in
            print("DB 수정됨")
            DispatchQueue.main.async {
                self.fetchParticipant()
            }
        })
    }
    
    func fetchTeamName() {
        db.child("Call").child(teamIndex).child("receiverNickname").observeSingleEvent(of: .value) { [self] snapshot in
            var receiverNicknameValue: String! = snapshot.value as? String
            var receiverNickname = receiverNicknameValue.replacingOccurrences(of: " 팀", with: "")
            thisCallTeamname = receiverNickname
            
        }
    }
    func checkIamLeader(teamname: String) {
        db.child("Team").child(teamname).child("leader").observeSingleEvent(of: .value) { [self] snapshot in
            var leaderUid: String! = snapshot.value as? String
            if leaderUid == Auth.auth().currentUser!.uid {
                amiLeader = true
            }
            checkIamCaller()
        }
    }
    func checkIamCaller() {
        db.child("Call").child(teamIndex).child("callerUid").observeSingleEvent(of: .value) { [self] snapshot in
            var callerUid: String! = snapshot.value as? String
            if callerUid == Auth.auth().currentUser!.uid {
                amiCaller = true
            }
            else {
                amiCaller = false
            }
        }
    }
    
    
    
}
extension ChannelTeamViewController: AgoraRtcEngineDelegate {
    //Agora안에 듣는 사람이나 말하는 사람 정보가 바뀌었을때
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStateChangedOfUid uid: UInt, state: AgoraAudioRemoteState, reason: AgoraAudioRemoteStateReason, elapsed: Int) {
        switch state {
            // 말하기를 시작할때
        case .decoding, .starting:
            // 듣는 사람에서 뺴주고
            self.activeAudience.remove(uid)
            // 말하는 사람들에 넣어준다.
            if !activeSpeakers.contains(uid) {
                self.activeSpeakers.append(uid)
            }
            //멈췄을때
        case .stopped, .failed:
            // 말하는 사람에서 삭제한다.
            for i in 0..<activeSpeakers.count {
                if activeSpeakers[i] == uid {
                    activeSpeakers.remove(at: i)
                }
            }
        default:
            return
        }
        self.collection.reloadData()
    }
    
    // 현재 말하는 사람 설정
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        //현재 말하는 사람으로 설정해준다.
        self.activeSpeaker = speakerUid
        self.collection.reloadData()
    }
}
extension ChannelTeamViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //듣는 사람과 말하는 사람 섹션 2개를 만들어줌.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if participantList.isEmpty {
            return 1
        }
        else {
            return participantList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! UserCollectionViewCell

        // 서버 받아오는게 느릴 시 기본으로 띄워줌
        if participantList.isEmpty {
            cell.setUI(image: user.profileImg, nickname: user.nickname, position: user.position)
        }
        else {
            cell.setUI(image: participantList[indexPath.row].profileImg, nickname: participantList[indexPath.row].nickname, position: participantList[indexPath.row].position)
            
            if !activeSpeakers.isEmpty || activeSpeakers != nil {
                print("activeSpeakers.count \(activeSpeakers.count)")
                if indexPath.row <= activeSpeakers.count-1 {
                    if activeSpeakers[indexPath.row] == activeSpeaker {
                        print("participantList[indexPath.row].nickname \(participantList[indexPath.row].nickname)")
                    }
                }
            }
        }
        
        return cell
    }
    
    
}


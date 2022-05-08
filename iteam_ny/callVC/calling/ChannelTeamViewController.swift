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
    var activeSpeakers: Set<UInt> = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        
        
        collection.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        if let flowLayout = collection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        
        addParticipant()
        fetchParticipant()
        
        fetchNickname(userUID: Auth.auth().currentUser!.uid)
        requestMicrophonePermission()
        connectAgora()
        joinChannel()
        
        setUI()
        
        fetchNickNameToUID(nickname: nickname)
        
    }
    
    func setUI() {
        for i in 0..<callButtons.count {
            callButtons[i].layer.cornerRadius = callButtons[0].frame.height/2
        }
        leaveButton.layer.cornerRadius = leaveButton.frame.height/2
        
        
    }
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
    func fetchParticipant() {
        
        var updateString: String = ""
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        db.child("Call").child(teamIndex).child("participant").observeSingleEvent(of: .value) { [self] snapshot in
            var lastDatas: [String] = []
            var lastData: String! = snapshot.value as? String
            if lastData  != nil {
                lastDatas = lastData.components(separatedBy: ", ")
                for i in 0..<lastDatas.count {
                    fetchUser(userUID: lastDatas[i])
                }
            }
        }
    }
    // uid로 user 정보 받기
    func fetchUser(userUID: String) {
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
            
            var person = Person(nickname: nickname, position: partDetail, callStm: "", profileImg: "")
            
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
        agkit?.joinChannel(byToken: "0061bc8bc4e2bff4c63a191db9a6fc44cd8IACYcpozxkwAhBzDg/2gXB7Q/fwjwwehN+mn7DnGZnm9BzfvbuoAAAAAEAA/6Ep2Q+x3YgEAAQBD7Hdi", channelId: "testToken11", info: nil, uid: userID,
                           joinSuccess: {(_, uid, elapsed) in
            self.userID = uid
            if self.role == .audience {
                self.activeAudience.insert(uid)
            } else {
                self.activeSpeakers.insert(uid)
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
    
    // uid로 닉네임 반환
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
            print("user \(user.nickname) \(user.position)")
            users.append(user)
        }
    }
    
    @IBAction func leaveChannel(_ sender: UIButton) {
        self.agkit?.createRtcChannel("testToken11")?.leave()
        self.agkit?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "CallClosedVC") as! CallClosedViewController
        print("channelViewController : \(otherPersonUID) ")
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
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
            self.activeSpeakers.insert(uid)
            //멈췄을때
        case .stopped, .failed:
            // 말하는 사람에서 삭제한다.
            self.activeSpeakers.remove(uid)
        default:
            return
        }
        self.collection.reloadData()
    }
    
    // 현재 말하는 사람 설정
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
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
        }
        
        return cell
    }
    
    
}
class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + cellSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}

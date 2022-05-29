//
//  ChannelViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/26.
//

import UIKit

import AgoraRtcKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var timeExplainLabel: UILabel!
    @IBOutlet var callButtons: [UIButton]!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var sameSchoolLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var otherImageView: UIImageView!
    
    let channelToken: String = "0061bc8bc4e2bff4c63a191db9a6fc44cd8IACsabbfj+i2SCjXLTFoBgofx3ezLSJ9jyha3LEyiNFt0zfvbuoAAAAAEAB9OJJ5bI+OYgEAAQBrj45i"
    
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    
    // 입장할 때 입력한 이름 받을 변수
    var name: String = ""
    
    var nickname: String = ""
    var position: String = ""
    var profile: String = ""
    
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
    
    // 상대 UID
    var otherPersonUID: String = ""
    
    // 말하는 사람인지 듣는 사람인지 역할
    lazy var role:AgoraClientRole = name == "speaker" || name == "speaker2" ? .broadcaster : .audience
    
    let db = Database.database().reference()
    
    
    // 타이머
    var secondsLeft: Int = 180
    var timer: Timer?
    
    var didMuteButtonTapped: Bool = false
    var didSpeakerButtonTapped: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        
        
        requestMicrophonePermission()
        connectAgora()
        joinChannel()
        
        setUI()
        
        fetchNickNameToUID(nickname: nickname)
        
    }
    
    func setUI() {
        sameSchoolLabel.layer.borderWidth = 0.5
        sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
        sameSchoolLabel.textColor = UIColor(named: "purple_184")
        
        sameSchoolLabel.layer.cornerRadius = sameSchoolLabel.frame.height/2
        sameSchoolLabel.text = "같은 학교"
        
        for i in 0..<callButtons.count {
            callButtons[i].layer.cornerRadius = callButtons[0].frame.height/2
        }
        nicknameLabel.text = nickname
        infoLabel.text = position
        
        timerButtonClicked()
        
        otherImageView.layer.cornerRadius = otherImageView.frame.height/2
        otherImageView.layer.masksToBounds = true
        
        // kingfisher 사용하기 위한 url
        let uid: String = otherPersonUID
        
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        print("uid \(uid)")
        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
            if let error = error {
            } else {
                otherImageView.kf.setImage(with: url)
            }
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
        agkit?.joinChannel(byToken: channelToken, channelId: "testToken11", info: nil, uid: userID,
                           joinSuccess: {(_, uid, elapsed) in
            self.userID = uid
            if self.role == .audience {
                self.activeAudience.insert(uid)
            } else {
                self.activeSpeakers.insert(uid)
            }
            print("joinChannel")
        })
    }
    func fetchNickNameToUID(nickname: String)  {
        print("fetchNickNameToUID")
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
    
    @IBAction func leaveChannel(_ sender: UIButton) {
        self.agkit?.createRtcChannel("testToken11")?.leave()
        self.agkit?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "CallClosedVC") as! CallClosedViewController
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
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
    
}
extension ChannelViewController: AgoraRtcEngineDelegate {
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
    }
    
    // 현재 말하는 사람 설정
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        self.activeSpeaker = speakerUid
    }
}

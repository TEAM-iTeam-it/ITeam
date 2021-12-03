//
//  ChannelViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/26.
//

import UIKit
import AgoraRtcKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var collection: UICollectionView!
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    // 입장할 때 입력한 이름 받을 변수
    var name: String = ""
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
    // 말하는 사람인지 듣는 사람인지 역할
    lazy var role:AgoraClientRole = name == "speaker" ? .broadcaster : .audience
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        requestMicrophonePermission()
        connectAgora()
        joinChannel()
        // Do any additional setup after loading the view.
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
        agkit?.joinChannel(byToken: "0061bc8bc4e2bff4c63a191db9a6fc44cd8IADU0N/x7sNzOArjdiHIf0VBvRLpckkdCHuA+mv7mHmYN5N+wrQAAAAAEADxtVSH/HmnYQEAAQD7eadh", channelId: "testToken1", info: nil, uid: userID,
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
    @IBAction func leaveChannel(_ sender: UIButton) {
        self.agkit?.createRtcChannel("haha")?.leave()
        self.agkit?.leaveChannel()
        AgoraRtcEngineKit.destroy()
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        self.collection.reloadData()
    }
    
    // 현재 말하는 사람 설정
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        self.activeSpeaker = speakerUid
        self.collection.reloadData()
    }
}
extension ChannelViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //듣는 사람과 말하는 사람 섹션 2개를 만들어줌.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? activeSpeakers.count : activeAudience.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! UserCollectionViewCell
        
        if indexPath.section == 0 {
            cell.setUI(isSpeaker:true)
        }else{
            cell.setUI(isSpeaker:false)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ChannelSectionHeader", for: indexPath) as! ChannelSectionHeader
        
        sectionHeader.headerLabel.text = indexPath.section == 0 ? "Speakers" : "Audience"
        
        return sectionHeader
        
    }
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "CallClosedVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
}

//
//  ChannelWaitingViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import Kingfisher
import FirebaseStorage
import FirebaseDatabase

class ChannelWaitingViewController: UIViewController {

    @IBOutlet weak var teamProfileCollectionView: UICollectionView!
    var nickname: String = ""
    var position: String = ""
    var name: String = ""
    var profile: String = ""
    var callTime: String = ""
    var questionArr: [String] = []
    var fromPerson: String = ""
    var toPerson: String = ""
    var teamMemberUid: [String] = [] {
        willSet {
            teamProfileCollectionView.reloadData()
        }
    }
    let db = Database.database().reference()
    var didQuestionConfig: Bool = false
    var teamIndex: String = ""
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var callTimeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var sameSchoolLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    func setUI() {
        teamProfileCollectionView.delegate = self
        teamProfileCollectionView.dataSource = self
        teamProfileCollectionView.backgroundColor = .clear
        
        sameSchoolLabel.layer.borderWidth = 0.5
        sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
        sameSchoolLabel.textColor = UIColor(named: "purple_184")
        
        sameSchoolLabel.layer.cornerRadius = sameSchoolLabel.frame.height/2
        sameSchoolLabel.text = "같은 학교"
        
        positionLabel.text = position
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        
        
        // kingfisher 사용하기 위한 url
        // 개인 사용자와 통화일 때
        if profile != "" {
            teamProfileCollectionView.isHidden = true
            nicknameLabel.text = nickname
            print("profile \(profile)")
            let uid: String = profile
            
            let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
            
            // Fetch the download URL
            starsRef.downloadURL { [self] url, error in
                if let error = error {
                } else {
                    profileImg.kf.setImage(with: url)
                }
            }
        }
        else {
            profileImg.isHidden = true
            nicknameLabel.text = nickname + " 팀"
            sameSchoolLabel.isHidden = true
            fetchTeamUid(teamname: nickname)

        }
        callTimeLabel.text = "\(callTime)에"
        name = "speaker"
    }
    
    
    func fetchTeamUid(teamname: String) {
        let justTeamname = teamname.replacingOccurrences(of: " 팀", with: "")
        let userdb = db.child("Team").child(justTeamname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            print("here \(teamname)")
            var teamname: String = justTeamname
            var memberString: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? String
                
                if snap.key == "memberList" {
                    memberString = value ?? ""
                    teamMemberUid = memberString.components(separatedBy: ", ")
                }
            }
        }
    }
    @IBAction func backBtn(_ sender: UIButton) {
        
        if didQuestionConfig {
            let values: [String: String] = [ "stmt": "통화" ]
            db.child("Call").child(teamIndex).updateChildValues(values)
        }
         
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func showQuestionAction(_ sender: UIButton) {
        let waitingRoomQuestionVC = storyboard?.instantiateViewController(withIdentifier: "waitingRoomQuestionVC") as! CallWaitingRoomQuestionViewController
        didQuestionConfig = true
        waitingRoomQuestionVC.question = questionArr
        waitingRoomQuestionVC.fromPerson = fromPerson
        waitingRoomQuestionVC.toPerson = toPerson
        // MDC 바텀 시트로 설정
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: waitingRoomQuestionVC)
        if questionArr.count > 3 {
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = CGFloat(49*questionArr.count + 84)
        }
        else {
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = CGFloat(49*questionArr.count + 84)
        }
        
        present(bottomSheet, animated: true, completion: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChannelViewController" {
            let vc = segue.destination as! ChannelViewController
            vc.name = name
            
            if let destination = segue.destination as? ChannelViewController {
                destination.nickname = nickname
                destination.position = position
            }
        }
        if segue.identifier == "showQuestionVC" {
            let vc = segue.destination as! QuestionnaireViewController
            vc.nickname = nickname
        }
    }


}
extension ChannelWaitingViewController: MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        print("바트 시트 닫힘")
    }
    
    func bottomSheetControllerDidChangeYOffset(_ controller: MDCBottomSheetController, yOffset: CGFloat) {
        // 바텀 시트 위치
        print(yOffset)
    }
}
extension ChannelWaitingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if teamMemberUid.count <= 3 {
            return teamMemberUid.count
        }
        else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waitingTeamProfileCell", for: indexPath) as! TeamProfileImageCollectionViewCell
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
        cell.userImage.layer.masksToBounds = true
        cell.layer.masksToBounds = true
        cell.userImage.backgroundColor = .clear
        cell.gradientView.layer.cornerRadius =  cell.gradientView.frame.height/2
        cell.gradientView.layer.masksToBounds = true
        cell.gradientView.isHidden = true
        
        // kingfisher 사용하기 위한 url
        let uid: String = teamMemberUid[indexPath.row]
        
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        starsRef.downloadURL { [self] url, error in
            if let error = error {
                cell.userImage.image = UIImage()
            } else {
                cell.userImage.kf.setImage(with: url)
            }
        }
        
        // Fetch the download URL
        if teamMemberUid.count > 3  {
            if indexPath.row == 2 {
                cell.userImage.isHidden = true
                cell.gradientView.isHidden = false
                cell.memberCountLabel.text = "+\(teamMemberUid.count-2)"
            }
        }
        return cell
    }
}
extension ChannelWaitingViewController: UICollectionViewDelegateFlowLayout {
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -10
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
            let dataSourceCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: section),
            dataSourceCount > 0 else {
                return .zero
        }

        let cellCount = CGFloat(dataSourceCount)
        let itemSpacing = -10.0
        let cellWidth = flowLayout.itemSize.width + itemSpacing
        var insets = flowLayout.sectionInset

        let totalCellWidth = (cellWidth * cellCount) - itemSpacing
        let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

        guard totalCellWidth < contentWidth else {
            return insets
        }

        let padding = (contentWidth - totalCellWidth) / 2.0
        insets.left = padding
        insets.right = padding
        return insets
    }
}


//
//  TeamProfileViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/31.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import MaterialComponents.MaterialBottomSheet


class TeamProfileViewController: UIViewController {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamPurposeLabel: UILabel!
    @IBOutlet weak var teamPartLabel: UILabel!
    @IBOutlet weak var teamIntroduceLabel: UILabel!
    @IBOutlet weak var callRequestBtn: UIButton!
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var teamImageColl: UICollectionView!
    @IBOutlet weak var profileImagesColl: UICollectionView!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var detailPartLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var callTimeLabel: UILabel!
    @IBOutlet weak var contactLinkLabel: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var favorButton: UIButton!
    
    @IBOutlet weak var profileViewHeight: NSLayoutConstraint!

    
    // 테이블뷰에서 셀 선택시 팀 이름을 넘겨주기 때문에 서버에서 팀 이름을 검색해서 팀 데이터를 받아옴
    var teamName: String = ""
    var teamProfile: TeamProfile = TeamProfile(purpose: "", serviceType: "", part: "", detailPart: "", introduce: "", contactLink: "", callTime: "", activeZone: "", memberList: "")
    
    var team: Team = Team(teamName: "", purpose: "", part: "", images: [])
    
    // @나연 : 삭제할 더미데이터 -> 추후 서버에서 받아와야함
    let teamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
    // 서버에서 받아 올 사용자 이미지 데이터
    var teamImageData: [Data] = []
    var resizedImage: UIImage = UIImage()
    let db = Database.database().reference()
    var favorTeamList: [String] = []
    var likeBool: Bool = false {
        willSet(newValue) {
            if newValue {
                favorButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favorButton.tintColor = UIColor(named: "purple_184")
            }
            else {
                favorButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favorButton.tintColor = UIColor(named: "gray_196")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        setUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setStatusBarColor()
    }
    
    func setUI() {
        navigationBar.shadowImage = UIImage()
        
        teamImageColl.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft

        callRequestBtn.layer.cornerRadius = 8
        callRequestBtn.layer.masksToBounds = true
        
        teamView.backgroundColor = .white
        teamView.layer.cornerRadius = 20
        teamView.layer.borderWidth = 0
        teamView.layer.borderColor = UIColor.black.cgColor
        teamView.layer.shadowColor = UIColor.black.cgColor
        teamView.layer.shadowOffset = CGSize(width: 0, height: 0)
        teamView.layer.shadowOpacity = 0.2
        teamView.layer.shadowRadius = 10
        teamView.layer.masksToBounds = true
        teamView.layer.masksToBounds = false
        
        
        teamNameLabel.text = teamName 
        teamPurposeLabel.text = teamProfile.purpose
        let teamPartString = teamProfile.part
        teamPartLabel.text = "\(teamPartString) 구인 중"
        detailPartLabel.text = teamProfile.detailPart
        let introduceString = teamProfile.introduce
        if teamProfile.introduce == nil || teamProfile.introduce == "" {
            teamIntroduceLabel.isHidden = true
            profileViewHeight.constant = 219
        }
        else {
            teamIntroduceLabel.text = " \"\(introduceString)\""
        }
        serviceTypeLabel.text = teamProfile.serviceType
        regionLabel.text = teamProfile.activeZone
        callTimeLabel.text = teamProfile.callTime
        contactLinkLabel.text = teamProfile.contactLink
        
        teamImageData = teamImageData.reversed()
        
        if favorTeamList.contains( teamNameLabel.text!) {
            favorButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favorButton.tintColor = UIColor(named: "purple_184")
            likeBool = true
        }
        else {
            favorButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favorButton.tintColor = UIColor(named: "gray_196")
            likeBool = false
        }
    }
    @IBAction func favorBtnAction(_ sender: UIButton) {
        if likeBool {
            likeBool = false
            removeDataAcion()
        }
        else {
            likeBool = true
            pullDataAcion()
        }
    }
    
    
    // 관심있는 팀에 추가
    func pullDataAcion() {
        var updateString: String = ""
        
        // 데이터 받아와서 이미 있으면 합쳐주기
        db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) { [self] snapshot in
            var lastDatas: [String] = []
            let lastData: String! = snapshot.value as? String
            lastDatas = lastData.components(separatedBy: ", ")
            if !lastDatas.contains(teamNameLabel.text!) {
                if snapshot.value as? String == nil || snapshot.value as? String == "" {
                    var lastData: String! = snapshot.value as? String
                    updateString = teamNameLabel.text!
                }
                else {
                    var lastData: String! = snapshot.value as? String
                    lastData += ", \(teamNameLabel.text!)"
                    updateString = lastData
                }
                let values: [String: Any] = [ "teamName": updateString ]
                // 데이터 추가
                db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").updateChildValues(values)
            }
        }
    }
    
    // 관심있는 팀에서 삭제
    func removeDataAcion() {
        var updateString: String = ""
        var lastDatas: [String] = []
        
        // 데이터 받아와서 이미 있으면 지워주기
        db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").child("teamName").observeSingleEvent(of: .value) { [self] snapshot in
            if snapshot.value as? String != nil {
                var lastData: String! = snapshot.value as? String
                lastDatas = lastData.components(separatedBy: ", ")
                
                for i in 0..<lastDatas.count {
                    if lastDatas[i] == teamNameLabel.text! {
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
            let values: [String: Any] = [ "teamName": updateString ]
            // 데이터 추가
            db.child("user").child(Auth.auth().currentUser!.uid).child("likeTeam").updateChildValues(values)
        }
    }
    

    
    // 상태바 흰색으로 채우기
    func setStatusBarColor() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.white
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
        }
        
    }
    
    @IBAction func teamListBtnAction(_ sender: UIButton) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "TeamPages_AllTeams", bundle: nil)
            
        // 바텀 시트로 쓰일 뷰컨트롤러 생성
        let teamListVC = thisStoryboard.instantiateViewController(withIdentifier: "teamListVC") as? TeamProfileTeamListViewController
        teamImageData = teamImageData.reversed()
        teamListVC?.teamImageData = teamImageData
        teamListVC?.teamMemberUID = teamProfile.memberList
        
        // teamListVC?.delegate = self
        
        // MDC 바텀 시트로 설정
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: teamListVC!)
        
        // bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 320
        
        
        // 보여주기
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil
        )
    }
    
    // 연락 요청 버튼
    @IBAction func callRequestBtnAction(_ sender: Any) {
        print("통화요청됨")
        let teamCallRequestStoryboard: UIStoryboard = UIStoryboard(name: "TeamCallRequest", bundle: nil)
        
        
        if let nextView = teamCallRequestStoryboard.instantiateViewController(withIdentifier: "teamCallRequestNC") as? UINavigationController,
           let nextViewChild = nextView.viewControllers.first as? TeamCallRequestViewController
        {
            // 수정 필요! -> nickname에 팀 이름 넣어도 되는지?
            nextViewChild.receiverNickname = teamName
            nextViewChild.receiverType = "team"
            
            nextView.modalPresentationStyle = .fullScreen
            present(nextView, animated: true, completion: nil)
        }
        
        
    }
    
    
}

extension TeamProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var memberUID = teamProfile.memberList.components(separatedBy: ", ")
        if memberUID.count <= 3 {
            return memberUID.count
        }
        else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 커스텀 셀 따로 만들지 않고 어차피 이미지만 들어간 셀이라 그냥 사용
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailTeamProfileCell", for: indexPath) as! TeamProfileImageCollectionViewCell
        
        // 셀 세팅
        cell.userImage.isHidden = false
        cell.gradientView.isHidden = true
        cell.memberCountLabel.isHidden = true
        
        var memberUID = teamProfile.memberList.components(separatedBy: ", ")
        
        
        let uid: String =  memberUID[indexPath.row]
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")
        starsRef.downloadURL { [self] url, error in
            if let error = error {
                cell.userImage.image = UIImage()
            } else {
                cell.userImage.kf.setImage(with: url)
            }
        }
        if memberUID.count > 3  {
            if indexPath.row == 0 {
                cell.userImage.isHidden = true
                cell.gradientView.isHidden = false
                cell.memberCountLabel.isHidden = false
                cell.memberCountLabel.text = "+\(memberUID.count-2)"
            }
        }
        
        
        // 셀 디자인 및 데이터 세팅
        cell.layer.cornerRadius = cell.frame.height/2
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor(ciColor: .white).cgColor
    
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    // 이미지 리사이징
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
extension TeamProfileViewController: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -30.0
        
    }

    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = 75
        let height = 75
        

        let size = CGSize(width: width, height: height)
        return size
    }
    
    // 중앙 정렬
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth = 75
        let spacingWidth = -20
        let numberOfItems = collectionView.numberOfItems(inSection: section)
        let cellSpacingWidth = numberOfItems * spacingWidth
        let totalCellWidth = numberOfItems * itemWidth + cellSpacingWidth
        let inset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
        return UIEdgeInsets(top: 5, left: inset, bottom: 5, right: inset)
    }
}




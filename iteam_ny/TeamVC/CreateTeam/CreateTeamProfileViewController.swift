//
//  CreateTeamProfileViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialBottomSheet

class CreateTeamProfileViewController: UIViewController {

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var teamTitleLabel: UILabel!
    @IBOutlet weak var teamExplainLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var leaderLabel: UILabel!
    @IBOutlet weak var profileImageColl: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var purposeBtn: UIButton!
    @IBOutlet weak var introduceTF: UITextField!
    @IBOutlet weak var contactLinkTF: UITextField!
    @IBOutlet weak var teamNameTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var callTimeBtn: UIButton!
    @IBOutlet weak var partLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var partLabelConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var partLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var regionLabelConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var regionLabelHeight: NSLayoutConstraint!
    @IBOutlet var serviceTypeBtns: [UIButton]!
    
    // MARK: - Properties
    let db = Database.database().reference()
    var didTeamNameWrote: Int = 0
    var didContactLinkWrote: Int = 0
    var didPurpleWrote: Int = 0
    var didPartWrote: Bool = false
    var didRegionWrote: Bool = false
    var didCallTimeWrote: Bool = false
    var partString: String = ""
    // 팀원이 있다면 넘어올 팀원 uid 배열
    var memberList: [String]?
    var haveTeamProfile: Bool = false
    
    var didWroteAllAnswer: Int = 0 {
        willSet(newValue) {
            print("newValue \(newValue)")
            if newValue >= 7
                && !serviceType.isEmpty
                && !serviceType.contains("")
                && partLabel.text != ""
                && regionLabel.text != ""
                && contactLinkTF.hasText  {
                saveBtn.backgroundColor = UIColor(named: "purple_184")
                saveBtn.setTitleColor(UIColor.white, for: .normal)
                saveBtn.isEnabled = true
            }
            else {
                saveBtn.backgroundColor = UIColor(named: "gray_196")
                saveBtn.setTitleColor(UIColor.white, for: .normal)
                saveBtn.isEnabled = false
            }
        }
    }
  
    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    var didSameTeamNameExist: Bool = false

    // 서비스 유형
    var serviceType: [String] = []
    
    // @나연 : 여기서 내 팀 데이터를 받아서 팀원의 "UID.png"제목의 프로필 사진들을 받아옴
    let teamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
    var teamMembers: [CustomUser] = []
    var didfetchedAllMembers: Bool = false {
        willSet {
            if newValue == true {
                DispatchQueue.main.async {
                    self.fetchTemaInfo()
                }
            }
        }
    }
    var teamname: String?
    var teamProfile: TeamProfile = TeamProfile(purpose: "", serviceType: "", part: "", detailPart: "", introduce: "", contactLink: "", callTime: "", activeZone: "", memberList: "", createDate: nil)
    var designerDetailPart: [String] = ["UI/UX 디자이너", "일러스트레이터", "모델러"]
    
    
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
    var fetchCharatorCount: Int = 0 {
        
        willSet {
            if newValue == memberList?.count {
                configTeamTypeLoad()
            }
        }
    }
    
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       setLayout()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
     
    }
    
    // MARK: - Functions
    func setLayout() {
        // 데이터 기입 여부에 따라 constraint 변경
        // 라벨 세팅
        if partLabel.text == "" {
            partLabel.isHidden = true
            partLabelConstraintTop.constant = 0
            partLabelHeight.constant = 0
        }
        else {
            partLabel.isHidden = false
            partLabelConstraintTop.constant = 15
            partLabelHeight.constant = 25
        }
        if regionLabel.text == "" {
            regionLabel.isHidden = true
            regionLabelConstraintTop.constant = 0
            regionLabelHeight.constant = 0
        }
        else {
            regionLabel.isHidden = false
            regionLabelConstraintTop.constant = 15
            regionLabelHeight.constant = 25
        }
    }
    
    func setUI() {
        navigationBar.shadowImage = UIImage()
        
        if !(memberList?.contains(Auth.auth().currentUser!.uid))! {
            memberList?.insert(Auth.auth().currentUser!.uid, at: 0)
        }
        
        // 유저 프로필(사진, 이름) 세팅 - 나, 다른 팀원들
        DispatchQueue.main.async {
            for i in 0..<self.memberList!.count {
                self.fetchNickname(userUID: self.memberList![i])
            }
            self.profileImageColl.reloadData()
        }
        
        // 버튼 디자인 세팅
        saveBtn.layer.cornerRadius = 8
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.backgroundColor = UIColor(named: "gray_196")
        saveBtn.isEnabled = false
        
        for i in 0..<serviceTypeBtns.count {
            serviceTypeBtns[i].layer.cornerRadius = serviceTypeBtns[i].frame.height/2
            serviceTypeBtns[i].layer.borderWidth = 0.5
            serviceTypeBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
            // serviceTypeBtns[i]
        }
        
        purposeBtn.layer.borderWidth = 0.5
        purposeBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        purposeBtn.layer.cornerRadius = 8
        
        
        callTimeBtn.layer.borderWidth = 0.5
        callTimeBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        callTimeBtn.layer.cornerRadius = 8
        
        //purposeBtn.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        purposeBtn.changesSelectionAsPrimaryAction = true
        
        
        // 팀 이름, 한 줄 소개, 팀 연락 링크 세팅
        introduceTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        introduceTF.leftViewMode = .always
        
        introduceTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        introduceTF.layer.borderWidth = 0.5
        introduceTF.layer.cornerRadius = 8
        
        contactLinkTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        contactLinkTF.leftViewMode = .always
        
        contactLinkTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        contactLinkTF.layer.borderWidth = 0.5
        contactLinkTF.layer.cornerRadius = 8
        
        teamNameTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        teamNameTF.leftViewMode = .always
        
        teamNameTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        teamNameTF.layer.borderWidth = 0.5
        teamNameTF.layer.cornerRadius = 8
        
        
        // 팀빌딩 목적 세팅
        let purposeTitleMenu = UIAction(title: "팀빌딩을 진행하는 목적을 선택해 주세요",attributes: .hidden, state: .off, handler: {_ in
            self.detailPartPullDownBtnSetting()
        })
        let portfolio = UIAction(title: "포트폴리오", handler: { _ in
            self.detailPartPullDownBtnSetting()
        })
        let contest = UIAction(title: "공모전", handler: { _ in
            self.detailPartPullDownBtnSetting()
        })
        let hackathon = UIAction(title: "해커톤", handler: { _ in
            self.detailPartPullDownBtnSetting()
        })
        let startup = UIAction(title: "창업", handler: { _ in
            self.detailPartPullDownBtnSetting()
        })
        let etc = UIAction(title: "기타", handler: { _ in
            self.detailPartPullDownBtnSetting()
        })
        let purposeMenu = UIMenu(title: "파트" ,children: [purposeTitleMenu, portfolio, contest, hackathon,startup, etc ])
        purposeBtn.menu = purposeMenu
        
        
        // 라벨 세팅
        partLabel.text = ""
        partLabel.isHidden = true
        partLabelConstraintTop.constant = 0
        partLabelHeight.constant = 0
        
        regionLabel.text = ""
        regionLabel.isHidden = true
        regionLabelConstraintTop.constant = 0
        regionLabelHeight.constant = 0
        
        leaderLabel.textColor = UIColor.white
        leaderLabel.backgroundColor = UIColor(named: "purple_184")
        leaderLabel.layer.cornerRadius = leaderLabel.frame.height/2
        leaderLabel.layer.masksToBounds = true
        
        // texfield 사용 중 스크롤시 키보드 내리기 위함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCalled(gestureRecognizer:)))
        profileImageColl.addGestureRecognizer(longPressGesture)
        
        configTeamType()
        // 팀 알고리즘 적용
    }
    // 팀 알고리즘
    func configTeamType() {
        var userPurposeCopy: [String] = []

        for i in 0..<memberList!.count {
            db.child("user").child(memberList![i]).child("userProfileDetail").child("character").observeSingleEvent(of: .value) { [self] snapshot in
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
                fetchCharatorCount += 1
                userPurpose = userPurposeCopy
            }
        }
    }
    func configTeamTypeLoad() {
        print(userPurpose)
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
        teamTitleLabel.text = teamTitle + " 팀"
        
    }
    
    // 팀프로필 있을 때 가져오기
    func fetchTemaInfo() {
        guard let teamname = teamname else {
            return
        }
        db.child("Team").child(teamname).observeSingleEvent(of: .value) { [self] snapshot in
            
            let value = snapshot.value as? [String : String]
            teamProfile = TeamProfile(
                purpose: value?["purpose"] ?? "",
                serviceType: value?["serviceType"] ?? "",
                part: value?["part"] ?? "",
                detailPart: value?["detailPart"] ?? "",
                introduce: value?["introduce"] ?? "",
                contactLink: value?["contactLink"] ?? "",
                callTime: value?["callTime"] ?? "",
                activeZone: value?["activeZone"] ?? "",
                memberList: value?["memberList"] ?? "",
                createDate: value?["createDate"] ?? ""
            )
            
            // 뷰 세팅
            DispatchQueue.main.async { [self] in
                // 데이터 불러와 세팅
                self.teamNameTF.text = self.teamname
                self.purposeBtn.setTitle(self.teamProfile.purpose, for: .normal)
                switch self.teamProfile.serviceType {
                case "앱 서비스":
                    self.serviceTypeBtns[0].layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[0].setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    self.serviceTypeBtns[0].layer.borderWidth = 0.5
                    self.serviceTypeBtns[0].layer.borderColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[0].titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
                    self.serviceType.append("앱 서비스")
                case "웹 서비스":
                    self.serviceTypeBtns[1].layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[1].setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    self.serviceTypeBtns[1].layer.borderWidth = 0.5
                    self.serviceTypeBtns[1].layer.borderColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[1].titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
                    self.serviceType.append("웹 서비스")
                default:
                    self.serviceTypeBtns[2].layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[2].setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    self.serviceTypeBtns[2].layer.borderWidth = 0.5
                    self.serviceTypeBtns[2].layer.borderColor = UIColor(named: "purple_247")?.cgColor
                    self.serviceTypeBtns[2].titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
                    self.serviceType.append("게임")
                }
                self.partLabel.text = self.teamProfile.detailPart
                self.regionLabel.text = self.teamProfile.activeZone
                if self.teamProfile.introduce != "" {
                    self.introduceTF.text = self.teamProfile.introduce
                }
                if self.teamProfile.callTime != "" {
                    self.callTimeBtn.setTitle(self.teamProfile.callTime, for: .normal)
                }
                if self.teamProfile.contactLink != "" {
                    self.contactLinkTF.text = self.teamProfile.contactLink
                }
                
                
                // 디자인 세팅
                self.didWroteAllAnswer = 6
               
                didPurpleWrote = 1
                didPartWrote = true
                didRegionWrote = true
                didContactLinkWrote = 1
                self.saveBtn.isEnabled = true
                self.teamNameTF.textColor = UIColor(named: "gray_196")
                self.teamNameTF.isEnabled = false
                purposeBtn.setTitleColor(.black, for: .normal)
                callTimeBtn.setTitleColor(.black, for: .normal)
                setLayout()
                
                var leaderUserInfo = CustomUser(userName: "", imageName: "", uid: "")
                // 팀장 맨 앞에 배치
                for i in 0..<teamMembers.count {
                    if self.teamMembers[i].uid == value?["leader"] {
                        leaderUserInfo = self.teamMembers[i]
                        teamMembers.remove(at: i)
                        break
                    }
                }
                teamMembers.insert(leaderUserInfo, at: 0)
                profileImageColl.reloadData()
            }
            
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
                            let user = CustomUser(userName: content as! String, imageName: teamImages[0], uid: userUID)
                            teamMembers.append(user)
                            profileImageColl.reloadData()
                           
                        }
                    }
                }
            }
        }
        if userUID == memberList?.last {
            didfetchedAllMembers = true
        }
    }
    func snapShotOfCall(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
            
        return cellSnapshot
    }
    
    // [Button Action] 뒤로 가기
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
    
        // 필수 항목 기입 확인
        if teamNameTF.text!.isEmpty || purposeBtn.titleLabel?.text == "팀빌딩을 진행하는 목적을 선택해 주세요" || serviceType.isEmpty || partLabel.text == "" || regionLabel.text == "" {
            saveBtn.backgroundColor = UIColor(named: "gray_196")
            saveBtn.isEnabled = false
            // showAlertAction()
        }
        else {
            // 팀 이름 중복 검사
            saveBtn.backgroundColor = UIColor(named: "purple_184")
            saveBtn.isEnabled = true
            if let teamName = self.teamNameTF {
                if let teamNameText = teamName.text {
                    
                    // 팀 이름이 이미 있는지 확인 (오류)
                    ref = Database.database().reference()
                    let teamItemRef = ref.child("Team")
                    // let query2 = teamItemRef..queryEqual(toValue: teamNameText)
                    self.saveDataAction()
//                    teamItemRef.observe(.value) { snapshot in
//                        for childSnapshot in snapshot.children {
//                            print(childSnapshot)
//                            print("same teamname boolean =" + "\(self.didSameTeamNameExist)")
//                            self.didSameTeamNameExist = true
//                            if self.didSameTeamNameExist {
//                                self.showAlertAction()
//                                break
//                            }
//                        }
//                        if !self.didSameTeamNameExist {
//                            self.saveDataAction()
//                        }
//
//                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 필수 항목 입력되지 않았을 때 alert
    func showAlertAction() {
        let alert = UIAlertController(title: "저장 실패", message: "필수 입력 항목을 확인해주세요", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in  }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
        
    }
    // 데이터 저장
    func saveDataAction() {
        
        var memberListString: String = ""
        guard var memberList = memberList else {
            return
        }

        if !memberList.contains(Auth.auth().currentUser!.uid) {
            memberList.insert( Auth.auth().currentUser!.uid, at: 0)
        }
        
        for i in 0..<memberList.count {
            if i == 0 {
                memberListString = memberList[0]
            }
            else {
                memberListString += ", \(memberList[i])"
            }
        }
        if partString == "" {
            var partArr: [String] = []
            var newPartString: String = ""
            if let partLabelText = partLabel.text {
                if partLabelText.contains("기획자") {
                    partArr.append("기획자")
                    
                }
                if partLabelText.contains("개발") {
                    partArr.append("개발자")
                }
                for designPart in designerDetailPart {
                    if partLabelText.contains(designPart) {
                        partArr.append("디자이너")
                        break
                    }
                }
            }
            for i in 0..<partArr.count {
                if i == 0 {
                    newPartString = partArr[0]
                }
                else {
                    newPartString += ", \(partArr[i])"
                }
            }
            partString = newPartString
        }
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let currentTeam: [String: Any] = [ "currentTeam": teamNameTF.text]
        let purpose: [String: Any] = [ "purpose": purposeBtn.titleLabel?.text]
        let serviceType: [String: Any] = [ "serviceType": serviceType[0]]
        let leader: [String: Any] = ["leader": teamMembers[0].uid]
        let part: [String: Any] = [ "part": partString]
        let activeZone: [String: Any] = [ "activeZone": regionLabel.text]
        let introduce: [String: Any] = [ "introduce": introduceTF.text]
        let callTime: [String: Any] = [ "callTime": callTimeBtn.titleLabel?.text]
        let contactLink: [String: Any] = [ "contactLink": contactLinkTF.text]
        let memberListValue: [String: Any] = [ "memberList": memberListString]
        let detailPart: [String: Any] = ["detailPart": partLabel.text]
        
        ref = Database.database().reference()
        // 데이터 추가
        if let teamNameTF = teamNameTF.text {
            
            ref.child("Team").child(teamNameTF).updateChildValues(purpose)
            ref.child("Team").child(teamNameTF).updateChildValues(serviceType)
            ref.child("Team").child(teamNameTF)
                .updateChildValues(part)
            ref.child("Team").child(teamNameTF).updateChildValues(detailPart)
            ref.child("Team").child(teamNameTF).updateChildValues(activeZone)
            ref.child("Team").child(teamNameTF).updateChildValues(introduce)
            ref.child("Team").child(teamNameTF).updateChildValues(leader)
            ref.child("Team").child(teamNameTF).updateChildValues(callTime)
            ref.child("Team").child(teamNameTF).updateChildValues(contactLink)
            ref.child("Team").child(teamNameTF).updateChildValues(memberListValue)
        }
        // 현재 팀 이름은 각 팀원에게 전부 추가해줘야함
        for i in 0..<memberList.count {
            ref.child("user").child(memberList[i]).updateChildValues(currentTeam)            
        }
    }
    
    // [Button Action] 서비스 유형 선택 - 단일 선택 처리
    @IBAction func serviceTypeAction(_ sender: UIButton) {
        // 이미 클릭한 경우 -> 클릭 취소
        if serviceType.contains((sender.titleLabel?.text)!) {
            sender.layer.backgroundColor = UIColor.clear.cgColor
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
            didWroteAllAnswer -= 1
            for i in 0...serviceType.count-1 {
                if serviceType[i] == sender.titleLabel?.text {
                    serviceType.remove(at: i)
                }
            }
        }
        // 새로 클릭하는 경우
        else {
            // 선택된게 없는 경우
            if serviceType.isEmpty {
                sender.layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
                sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)

                serviceType.append((sender.titleLabel?.text)!)
                didWroteAllAnswer += 1
            }
            // 이미 다른 버튼이 선택된 경우
            else {
                serviceType.removeAll()
                for i in 0...serviceTypeBtns.count-1 {
                    serviceTypeBtns[i].layer.backgroundColor = UIColor.clear.cgColor
                    serviceTypeBtns[i].setTitleColor(UIColor.black, for: .normal)
                    serviceTypeBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
                    serviceTypeBtns[i].titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
                }
                sender.layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
                sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
                
                serviceType.append((sender.titleLabel?.text)!)
                
            }
        }
    }
    
    // 통화 가능 시간 bottom sheet 띄우기
    @IBAction func callTimeSettingAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "TeamPages", bundle: nil)
            
        // 바텀 시트로 쓰일 뷰컨트롤러 생성
        let callTimeVC = thisStoryboard.instantiateViewController(withIdentifier: "callTimeVC") as? CallTimePickerViewController
        
        callTimeVC?.delegate = self
        
        // MDC 바텀 시트로 설정
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: callTimeVC!)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 320
        
        
        // 보여주기
        present(bottomSheet, animated: true, completion: nil)
    }

    
    // [PullDownButton setting] 타이틀 색상 변경
    func detailPartPullDownBtnSetting() {
        if let purposeBtn = self.purposeBtn {
            purposeBtn.setTitleColor(.black, for: .normal)
            
            if didPurpleWrote != 1 {
                didPurpleWrote = 1
                didWroteAllAnswer += 1
            }
        }
    }
}

// textfield, 스크롤 제어
// 텍스트 필드가 키보드에 가려지지 않도록 하기 위해 스크롤 내릶
extension CreateTeamProfileViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    // [Keyboard setting] return시 제거,
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contactLinkTF {
            scrollView.scroll(to: .bottom)
        }
        addFillCount()
        addFillCountContactLink()
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == contactLinkTF {
            scrollView.scroll(to: .bottom250)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == contactLinkTF {
            scrollView.scroll(to: .bottom )
        }
    }
    
    @objc func TapMethod(sender: UITapGestureRecognizer) {
        addFillCount()
        addFillCountContactLink()
        self.view.endEditing(true)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        addFillCount()
        addFillCountContactLink()
        self.view.endEditing(true)
    }
    
    // 완료 버튼을 제어하기 위해 텍스트 필드 입력을 감지하는 함수
    func addFillCount() {
        if teamNameTF.hasText {
            if didTeamNameWrote == 1 {
            }
            else {
                didTeamNameWrote = 1
                didWroteAllAnswer += didTeamNameWrote
            }
        }
        else {
            if didTeamNameWrote == 1 {
                didWroteAllAnswer -= 1
                didTeamNameWrote = 0
            }
            
        }
    }
    func addFillCountContactLink() {
        if contactLinkTF.hasText {
            if didContactLinkWrote == 1 {
            }
            else {
                didContactLinkWrote = 1
                didWroteAllAnswer += didContactLinkWrote
            }
        }
        else {
            if didContactLinkWrote == 1 {
                didWroteAllAnswer -= 1
                didContactLinkWrote = 0
            }
            
        }
    }
}


extension CreateTeamProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingMyTeamProfileCell", for: indexPath) as! CreateTeamProfileImageCollectionViewCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height/2
        if teamMembers[indexPath.row].uid == Auth.auth().currentUser!.uid {
            cell.nameLabel.text = "나"
        }
        else {
            cell.nameLabel.text = teamMembers[indexPath.row].userName
        }
        
        let uid: String = teamMembers[indexPath.row].uid
        let starsRef = Storage.storage().reference().child("user_profile_image/\(uid).jpg")

        // Fetch the download URL
        starsRef.downloadURL { [self] url, error in
          if let error = error {
              print("에러 \(error.localizedDescription)")
          } else {
              cell.profileImage.kf.setImage(with: url)
          }
        }
        cell.profileImage.layer.masksToBounds = true
        cell.layer.masksToBounds = true
        cell.nameLabel.sizeToFit()
        return cell
        
    }
}

extension CreateTeamProfileViewController: UICollectionViewDelegateFlowLayout {

    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -15.0
        
    }
}

// 삭제할 클래스
class CustomUser {
    var userName: String = ""
    var imageName: String = ""
    var uid: String = ""
    
    init(userName: String, imageName: String, uid: String) {
        self.userName = userName
        self.imageName = imageName
        self.uid = uid
    }
}
enum FontType {
    case regular, bold, medium, light, semibold
}
extension UIFont {
    static func fontWithName(type: FontType, size: CGFloat) -> UIFont {
        var fontName = ""
        switch type {
            case .regular: fontName = "AppleSDGothicNeo-Regular"
            case .light: fontName = "AppleSDGothicNeo-Light"
            case .medium: fontName = "AppleSDGothicNeo-Medium"
            case .semibold: fontName = "AppleSDGothicNeo-SemiBold"
            case .bold: fontName = "AppleSDGothicNeo-Bold"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}


// 다른 화면에서 데이터 넘겨받고 뷰 세팅
extension CreateTeamProfileViewController: SendPartDataDelegate, SendRegionDataDelegate, SendCallTimeDataDelegate {
    
    
    func sendData(data: [[String]]) {
        partString = ""
        var detailPart: String = ""
        for i in 0..<data[0].count {
            if data[0][i] == data[0].last {
                partString += "\(data[0][i])"
            }
            else {
                partString += "\(data[0][i]), "
            }
        }
        for i in 0..<data[1].count {
            if data[1][i] == data[1].last {
                detailPart += "\(data[1][i])"
            }
            else {
                detailPart += "\(data[1][i]), "
            }
        }
        
        
        self.partLabel.isHidden = false
        self.partLabel.text = detailPart
      
        // 포지션이 채워지면 카운트를 올려줌
        if !self.partLabel.text!.isEmpty || partLabel.text != "" {
            if !didPartWrote {
                didWroteAllAnswer += 1
                didPartWrote = true
            }
        }
        else {
            // 포지션을 채웠다가 비우면 카운트를 내려줌
            // 처음 입력 시부터 입력하지 않았다면 카운트 변경 없음
            if didPartWrote {
                didWroteAllAnswer -= 1
                didPartWrote = false
            }
        }
    }
    
    func sendRegionData(data: [String]) {
        var region: String = ""
        for i in 0..<data.count {
            if data[i] == data.last {
                region += "\(data[i])"
            }
            else {
                region += "\(data[i]), "
            }
            
        }
        self.regionLabel.isHidden = false
        self.regionLabel.text = region
        
        // 지역이 채워지면 카운트를 올려줌
        if !self.regionLabel.text!.isEmpty || regionLabel.text != "" {
            if !didRegionWrote {
                didWroteAllAnswer += 1
                didRegionWrote = true
            }
        }
        else {
            // 포지션을 채웠다가 비우면 카운트를 내려줌
            // 처음 입력 시부터 입력하지 않았다면 카운트 변경 없음
            if didRegionWrote {
                didWroteAllAnswer -= 1
                didRegionWrote = false
            }
        }
    }
    func sendCallTimeData(data: String) {
        self.callTimeBtn.setTitle(data, for: .normal)
        self.callTimeBtn.setTitleColor(UIColor.black, for: .normal)
        
        // 지역이 채워지면 카운트를 올려줌
        if !self.callTimeBtn.titleLabel!.text!.isEmpty || callTimeBtn.titleLabel!.text != "통화하기 좋은 시간을 선택해 주세요" {
            if !didCallTimeWrote {
                didWroteAllAnswer += 1
                didCallTimeWrote = true
            }
        }
        else {
            // 포지션을 채웠다가 비우면 카운트를 내려줌
            // 처음 입력 시부터 입력하지 않았다면 카운트 변경 없음
            if didRegionWrote {
                didWroteAllAnswer -= 1
                didCallTimeWrote = false
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "CreateTeamPartVC" {
            let createTeamPartViewController: CreateTeamPartViewController = segue.destination as! CreateTeamPartViewController
            createTeamPartViewController.delegate = self
            
        }
        else if segue.identifier == "regionVC" {
            let createTeamRegionViewController: CreateTeamRegionViewController = segue.destination as! CreateTeamRegionViewController
            createTeamRegionViewController.delegate = self
        }
        

       }
}
extension CreateTeamProfileViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {

    }
}

extension CreateTeamProfileViewController {
    @objc func longPressCalled(gestureRecognizer: UIGestureRecognizer) {
        guard let longPress = gestureRecognizer as? UILongPressGestureRecognizer else { return }
        let state = longPress.state
        let locationInView = longPress.location(in: profileImageColl)
        let indexPath = profileImageColl.indexPathForItem(at: locationInView)
    
        
        // 최초 indexPath 변수
        struct Initial {
            static var initialIndexPath: IndexPath?
        }
        
        // 스냅샷
        struct MyCell {
            static var cellSnapshot: UIView?
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
        }
        
        // UIGestureRecognizer 상태에 따른 case 분기처리
        switch state {
            
        // longPress 제스처가 시작할 때 case
        case UIGestureRecognizer.State.began:
            if indexPath != nil {
                Initial.initialIndexPath = indexPath
                var cell: UICollectionViewCell? = UICollectionViewCell()
                cell = profileImageColl.cellForItem(at: indexPath!)
                
                MyCell.cellSnapshot = snapShotOfCall(cell!)
                
                var center = cell?.center
                MyCell.cellSnapshot!.center = center!
                // 원래 처음 꾹 누른 부분의 기존 row는 가려준다.
                MyCell.cellSnapshot!.alpha = 0.0
                profileImageColl.addSubview(MyCell.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    MyCell.cellIsAnimating = true
                    MyCell.cellSnapshot!.center = center!
                    MyCell.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    MyCell.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        MyCell.cellIsAnimating = false
                        if MyCell.cellNeedToShow {
                            MyCell.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        // longPress 제스처가 변경될 때 case
        case UIGestureRecognizer.State.changed:
            if MyCell.cellSnapshot != nil {
                var center = MyCell.cellSnapshot!.center
                center.y = locationInView.y
                MyCell.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Initial.initialIndexPath)) && Initial.initialIndexPath != nil {
                    // 메모리 관련 이슈때문에 바꿔준 부분
                    teamMembers.insert(self.teamMembers.remove(at: Initial.initialIndexPath!.row), at: indexPath!.row)
                    profileImageColl.moveItem(at: Initial.initialIndexPath!, to: indexPath!)
                    Initial.initialIndexPath = indexPath
                }
            }
        // longPress 제스처가 끝났을 때 case
        default:
            if Initial.initialIndexPath != nil {
                let cell = profileImageColl.cellForItem(at: Initial.initialIndexPath!)
                if MyCell.cellIsAnimating {
                    MyCell.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    MyCell.cellSnapshot!.center = (cell?.center)!
                    MyCell.cellSnapshot!.transform = CGAffineTransform.identity
                    MyCell.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Initial.initialIndexPath = nil
                        MyCell.cellSnapshot!.removeFromSuperview()
                        MyCell.cellSnapshot = nil
                    }
                })
            }
        }
    }
}

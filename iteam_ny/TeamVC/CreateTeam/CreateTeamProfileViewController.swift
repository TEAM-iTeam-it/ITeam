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
    
    let db = Database.database().reference()
    
    var didTeamNameWrote: Int = 0
    var didPurpleWrote: Int = 0
    var didPartWrote: Bool = false
    var didRegionWrote: Bool = false
    var partString: String = ""
    // 팀원이 있다면 넘어올 팀원 uid 배열
    var memeberList: [String]?
    
    var didWroteAllAnswer: Int = 0 {
        willSet(newValue) {
            print("newvalue = \(newValue)")
            if newValue >= 5 {
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
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       setLayout()

    }
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        navigationBar.shadowImage = UIImage()
        
        
        // 유저 프로필(사진, 이름) 세팅 - 나, 다른 팀원들
        let myself = CustomUser(userName: "나", imageName: teamImages[0])
        teamMembers.append(myself)
        print("memeberList \(memeberList)")
        
        DispatchQueue.main.async {
            for i in 0..<self.memeberList!.count {
                self.fetchNickname(userUID: self.memeberList![i])
                print(self.teamMembers.count)
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
                            let user = CustomUser(userName: content as! String, imageName: teamImages[0])
                            teamMembers.append(user)
                            print("user.userName \(user.userName)")
                            profileImageColl.reloadData()
                           
                        }
                    }
                }
            }
        }
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
        guard let user = Auth.auth().currentUser else {
            return
        }
        // 현재 팀은 각 팀원에게 전부 추가해줘야함
        let currentTeam: [String: Any] = [ "currentTeam": teamNameTF.text]
        let purpose: [String: Any] = [ "purpose": purposeBtn.titleLabel?.text]
        let serviceType: [String: Any] = [ "serviceType": serviceType[0]]
        let leader: [String: Any] = ["leader": ""]
        let part: [String: Any] = [ "part": partString]
        let activeZone: [String: Any] = [ "activeZone": regionLabel.text]
        let introduce: [String: Any] = [ "introduce": introduceTF.text]
        let callTime: [String: Any] = [ "callTime": callTimeBtn.titleLabel?.text]
        let contactLink: [String: Any] = [ "contactLink": contactLinkTF.text]
        let memberList: [String: Any] = [ "memberList": user.uid]
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
            ref.child("Team").child(teamNameTF).updateChildValues(memberList)
        }
        // 현재 팀 이름은 각 팀원에게 전부 추가해줘야함
        //ref.child("user").child(Auth.auth().currentUser?.uid).updateChildValues(currentTeam)
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
        print("serviceType : \(serviceType)")
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
        self.view.endEditing(true)
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        addFillCount()
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
}


extension CreateTeamProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "makingMyTeamProfileCell", for: indexPath) as! CreateTeamProfileImageCollectionViewCell
        
        cell.nameLabel.text = teamMembers[indexPath.row].userName
        cell.profileImage.image = UIImage(named: teamMembers[indexPath.row].imageName)
        cell.profileImage.layer.masksToBounds = true
        cell.layer.masksToBounds = true
        cell.profileImage.layer.masksToBounds = true
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
    
    init(userName: String, imageName: String) {
        self.userName = userName
        self.imageName = imageName
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
        if !self.partLabel.text!.isEmpty {
            didWroteAllAnswer += 1
            didPartWrote = true
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
        if !self.regionLabel.text!.isEmpty {
            didWroteAllAnswer += 1
            didRegionWrote = true
        }
        else {
            // 포지션을 채웠다가 비우면 카운트를 내려줌
            // 처음 입력 시부터 입력하지 않았다면 카운트 변경 없음
            if didRegionWrote {
                didWroteAllAnswer -= 1
                didPartWrote = false
            }
        }
    }
    func sendCallTimeData(data: String) {
        self.callTimeBtn.setTitle(data, for: .normal)
        self.callTimeBtn.setTitleColor(UIColor.black, for: .normal)
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


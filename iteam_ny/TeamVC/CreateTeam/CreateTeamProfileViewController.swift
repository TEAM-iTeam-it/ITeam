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

class CreateTeamProfileViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, SendCallTimeDataDelegate {
    

    @IBOutlet weak var saveBtn: UIButton!
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
    
    @IBOutlet var serviceTypeBtns: [UIButton]!
  
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
        
        setUI()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스크롤뷰에서 texfield사용시 키보드를 내리기 위함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
        partLabel.isHidden = true
        regionLabel.isHidden = true
    }
    
    func setUI() {
        navigationBar.shadowImage = UIImage()
        
        
        // @나연 : 유저 프로필(사진, 이름) 세팅
        let user1 = CustomUser(userName: "나", imageName: teamImages[0])
        let user2 = CustomUser(userName: "케빈", imageName: teamImages[1])
        let user3 = CustomUser(userName: "제이크", imageName: teamImages[2])
        
        teamMembers.append(user1)
        teamMembers.append(user2)
        teamMembers.append(user3)
        
        // 버튼 디자인 세팅
        saveBtn.layer.cornerRadius = 8
        
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
        
        
        
    }
    
    // [Button Action] 뒤로 가기
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveBtnAction(_ sender: UIButton) {
    
        // 필수 항목 기입 확인
        if teamNameTF.text!.isEmpty || purposeBtn.titleLabel?.text == "팀빌딩을 진행하는 목적을 선택해 주세요" || serviceType.isEmpty || partLabel.text == "" || regionLabel.text == "" {
            showAlertAction()
        }
        else {
            // 팀 이름 중복 검사
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
        
        let purpose: [String: Any] = [ "purpose": purposeBtn.titleLabel?.text]
        let serviceType: [String: Any] = [ "serviceType": serviceType[0]]
        let part: [String: Any] = [ "part": partLabel.text]
        let activeZone: [String: Any] = [ "activeZone": regionLabel.text]
        let introduce: [String: Any] = [ "introduce": introduceTF.text]
        let callTime: [String: Any] = [ "callTime": callTimeBtn.titleLabel?.text]
        let contactLink: [String: Any] = [ "contactLink": contactLinkTF.text]
        let memberList: [String: Any] = [ "memberList": user.uid]
        
        
        ref = Database.database().reference()
        // 데이터 추가
        if let teamNameTF = teamNameTF.text {
            ref.child("Team").child(teamNameTF).updateChildValues(purpose)
            
            ref.child("Team").child(teamNameTF).updateChildValues(serviceType)
            
            ref.child("Team").child(teamNameTF)
                .updateChildValues(part)
            
            ref.child("Team").child(teamNameTF).updateChildValues(activeZone)
            
            ref.child("Team").child(teamNameTF).updateChildValues(introduce)
            
            ref.child("Team").child(teamNameTF).updateChildValues(callTime)
            
            ref.child("Team").child(teamNameTF).updateChildValues(contactLink)
            
            ref.child("Team").child(teamNameTF).updateChildValues(memberList)
            
        }
        
    }
    
    // [Button Action] 서비스 유형 선택 - 단일 선택 처리
    @IBAction func serviceTypeAction(_ sender: UIButton) {
        if serviceType.contains((sender.titleLabel?.text)!) {
            sender.layer.backgroundColor = UIColor.clear.cgColor
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
            
            for i in 0...serviceType.count-1 {
                if serviceType[i] == sender.titleLabel?.text {
                    serviceType.remove(at: i)
                }
            }
        }
        else {
            if serviceType.isEmpty {
                sender.layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
                sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                sender.layer.borderWidth = 0.5
                sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
                sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)

                serviceType.append((sender.titleLabel?.text)!)
            }
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
    
    @IBAction func callTimeSettingAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "TeamPages", bundle: nil)
        let callTimeVC = thisStoryboard.instantiateViewController(withIdentifier: "callTimeVC") as? CallTimePickerViewController
        callTimeVC?.delegate = self
        
        
        present(callTimeVC!, animated: true, completion: nil)
    }
    func sendCallTimeData(data: String) {
        self.callTimeBtn.setTitle(data, for: .normal)
        self.callTimeBtn.setTitleColor(UIColor.black, for: .normal)
    }

    
    
    // [PullDownButton setting] 타이틀 색상 변경
    func detailPartPullDownBtnSetting() {
        if let purposeBtn = self.purposeBtn {
            purposeBtn.setTitleColor(.black, for: .normal)
        }
    }
    
    
    // [Keyboard setting] return시 제거
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func TapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.view.endEditing(true)
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

extension CreateTeamProfileViewController: SendPartDataDelegate, SendRegionDataDelegate {
    
    
    
    func sendData(data: [String]) {
        var part: String = ""
        for i in 0..<data.count {
            if data[i] == data.last {
                part += "\(data[i])"
            }
            else {
                part += "\(data[i]), "
            }
            
        }
        self.partLabel.isHidden = false
        self.partLabel.text = part
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


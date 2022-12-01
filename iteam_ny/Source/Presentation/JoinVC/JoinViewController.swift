//
//  JoinViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/17.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class JoinViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 이메일 Textfield
    @IBOutlet weak var emailTF: UITextField!
    // 비밀번호 Textfield
    @IBOutlet weak var passwordTF: UITextField!
    // 닉네임 Textfield
    @IBOutlet weak var nicknameTF: UITextField!
    // 이메일 view nextBtn
    @IBOutlet weak var emailViewNextBtn: UIButton!
    // 이메일 인증 확인 멘트 label
    @IBOutlet weak var emailVFLabel: UILabel!
    // 프로필 사진 선택 button
    @IBOutlet weak var profileImageButton: UIButton!
    // 프로필 사진 편집 image
    @IBOutlet weak var editImageBtn: UIButton!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var profileImageEditView: UIView!
    @IBOutlet weak var partBtn: UIButton!
    // 파트 선택 button
    @IBOutlet weak var detailPartBtn: UIButton!
    // 다음 button
    @IBOutlet var nextBtns: [UIButton]!
    // 인증 메일 받기 button
    @IBOutlet weak var emailVFBtn: UIButton!
    // 인증 확인 버튼
    @IBOutlet weak var emailVFAfter: UIButton!
    // 비밀번호 view nextBtn
    @IBOutlet weak var passwordNextBtn: UIButton!
    // 비밀번호 확인 멘트 label
    @IBOutlet weak var passwordLabel: UILabel!
    // 닉네임 view nextBtn
    @IBOutlet weak var nicknameNextBtn: UIButton!
    // 닉네임 확인 멘트 label
    @IBOutlet weak var nicknameLabel: UILabel!
    // 이미지 view nextBtn
    @IBOutlet weak var imageNextBtn: UIButton!
    // 파트 view nextBtn
    @IBOutlet weak var partNextBtn: UIButton!
    // 파트 선택 완료를 위한 변수
    var partSuccess: Int = 0
    // 프로필 이미지 URL을 위한 변수
    var imageURL: URL  = NSURL() as URL
    // 닉네임 중복 검사를 위한 변수
    var nicknameCount: Bool = false
    
    var handle: AuthStateDidChangeListenerHandle!
    
    
    // Firebase Realtime Database 루트
    var ref: DatabaseReference! = Database.database().reference()
    
    
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }

    // UI setting
    func setUI() {
        // 다음 버튼 디자인
        
        
        DispatchQueue.main.async {
            if self.nextBtns != nil {
                for i in 0...self.nextBtns.count-1 {
                    self.nextBtns[i].layer.cornerRadius = 8
                    if self.nextBtns[i].titleLabel?.text != "시작하기" {
                        self.nextBtns[i].layer.backgroundColor = UIColor(named: "gray_196")?.cgColor
                    }
                }
            }
            if let emailBtn = self.emailViewNextBtn  {
                emailBtn.isEnabled = false
                emailBtn.isHidden = true
                emailBtn.backgroundColor = UIColor(named: "gray_196")
            }
            if let emailVFBtn = self.emailVFBtn {
                emailVFBtn.titleLabel?.numberOfLines = 1
                emailVFBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
                // 0.4 이하는 너무 작게 표시됨
                emailVFBtn.titleLabel!.minimumScaleFactor = 0.5
                emailVFBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                emailVFBtn.backgroundColor = UIColor.white
                emailVFBtn.layer.borderWidth = 1
                emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                emailVFBtn.layer.cornerRadius = 8
                
                
            }
            if let emailVFAfter = self.emailVFAfter {
                emailVFAfter.isHidden = true
            }
            if let pwdBtn = self.passwordNextBtn  {
                pwdBtn.isEnabled = false
            }
            if let nicknameBtn = self.nicknameNextBtn  {
                nicknameBtn.isEnabled = false
            }
            if let imageBtn = self.imageNextBtn {
                imageBtn.isEnabled = false
            }
            if let partNextBtn = self.partNextBtn {
                partNextBtn.isEnabled = false
            }
            if let emailLabel = self.emailVFLabel  {
                emailLabel.isHidden = true
                emailLabel.sizeToFit()
            }
            if let pwdLabel = self.passwordLabel  {
                pwdLabel.isHidden = true
            }
            if let nicknameLabel = self.nicknameLabel  {
                nicknameLabel.isHidden = true
            }
            if let partBtn = self.partBtn, let detailPartBtn = self.detailPartBtn {
                partBtn.layer.cornerRadius = 8
                detailPartBtn.layer.cornerRadius = 8
            }
            
            
            // textfield 좌측 공백
            if let email = self.emailTF {
                email.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                email.layer.cornerRadius = 8
            }
            if let password = self.passwordTF {
                password.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                password.layer.cornerRadius = 8
            }
            if let nickname = self.nicknameTF {
                nickname.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                nickname.layer.cornerRadius = 8
                nickname.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            }
            if let profileImage = self.profileImageButton, let profileImageEditView = self.profileImageEditView {
                profileImage.layer.borderWidth = 0.5
                profileImage.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                profileImage.layer.backgroundColor = UIColor(named: "purple_light")?.cgColor
                profileImage.layer.cornerRadius = 75
                profileImageEditView.isHidden = true
            }
             
            // 파트에 따른 세부 파트 설정
          
            let aa = UIAction(title: "위 파트를 먼저 선택해주세요", handler: { _ in print("기획자") })
            var detailPartMenu = UIMenu(title: "알림", children: [aa])
            let partTitleMenu = UIAction(title: "파트",attributes: .hidden, state: .off, handler: {_ in })
            let organizerMenu = UIAction(title: "기획자", handler: { _ in
                print("기획자")
                let detailDefault = UIAction(title:"세부 포지션", attributes: .hidden, state: .off, handler: { _ in })
                let app = UIAction(title:"앱 기획자", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let web = UIAction(title:"웹 기획자", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let game = UIAction(title:"게임 기획자", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                detailPartMenu = UIMenu(title: "기획자", children: [detailDefault, app, web, game])
                self.partPullDownBtnSetting()
                self.detailPartBtn.menu = detailPartMenu
                
            })
            let designerMenu = UIAction(title: "디자이너", handler: { _ in
                print("디자이너")
                let detailDefault = UIAction(title:"세부 포지션", attributes: .hidden, state: .off, handler: { _ in })
                
                let uiux = UIAction(title:"UI/UX 디자이너", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let illust = UIAction(title:"일러스트레이터", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let modeler = UIAction(title:"모델러", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                detailPartMenu = UIMenu(title: "디자이너", children: [detailDefault, uiux, illust, modeler])
                
                self.partPullDownBtnSetting()
                self.detailPartBtn.menu = detailPartMenu
            })
            let developerMenu = UIAction(title: "개발자", handler: { _ in
                print("개발자")
                let detailDefault = UIAction(title:"세부 포지션", attributes: .hidden, state: .off, handler: { _ in })
                
                let android = UIAction(title:"Android", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let ios = UIAction(title:"iOS", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let web = UIAction(title:"웹", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let backend = UIAction(title:"백엔드", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                let game = UIAction(title:"게임", handler: { _ in
                    self.detailPartPullDownBtnSetting()
                })
                detailPartMenu = UIMenu(title: "개발자", children: [detailDefault, android, ios, web, backend, game])
                
                self.partPullDownBtnSetting()
                self.detailPartBtn.menu = detailPartMenu
            })
            
            let partMenu = UIMenu(title: "파트" ,children: [partTitleMenu, organizerMenu, designerMenu, developerMenu])
            if let partBtn = self.partBtn {
                partBtn.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                // 오류 발생
                partBtn.changesSelectionAsPrimaryAction = true
                partBtn.setTitle("파파", for: .normal)
                
                partBtn.menu = partMenu
            }
            if let detailPartBtn = self.detailPartBtn {
                detailPartBtn.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
                detailPartBtn.changesSelectionAsPrimaryAction = false
                
                self.detailPartBtn.menu = detailPartMenu
            }
        }
        Auth.auth().currentUser?.reload()
        
    }
    // 삭제얘정
    @IBAction func testLogout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("logout")
        } catch let signOutError as NSError {
            print(signOutError)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // 회원탈퇴
    @IBAction func userDelete(_ sender: UIButton) {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if error != nil {
              print(error?.localizedDescription)
          } else {
            print("탈퇴완료")
          }
        }
    }
    
    // [Button action] 이메일 인증
    @IBAction func emailVF(_ sender: UIButton) {
        self.emailVFLabel.isHidden = false
        guard let id = self.emailTF.text else {
            return
        }
        let pw = "11111111111"
        // [수정 필요] 학교 이메일만 가능하도록 처리
        if id.contains("swu.ac.kr") || id.contains("naver.com") || id.contains("gmail.com") {
            Auth.auth().createUser(withEmail: id, password: pw) { authResult, error in
                if(error != nil) {
                    print("회원가입 실패")
                    let errorCode = AuthErrorCode(AuthErrorCode.Code(rawValue: error!._code)!)
                    print("-> errorCode -> \(errorCode)")
                    switch errorCode {
                    case AuthErrorCode.quotaExceeded:
                        self.emailVFLabel.text = "이미 가입된 이메일입니다."
                    case AuthErrorCode.invalidEmail:
                        self.emailVFLabel.text = "올바르지 않은 이메일 주소입니다."
                    default:
                        self.emailVFLabel.text = "다시 입력해주세요."
                    }
                    return
                }
                else {
                    
                    print("회원가입 성공")
                    
                    // [서버 생성]
                    // [이메일 데이터 추가]
                    // 최상위 ref 연결
                    // ref > user > user.uid > values
                    
                    // Firebase Realtime Database 루트
                    var ref: DatabaseReference!
                    
                    ref = Database.database().reference()
                    let userItemRef = ref.child("user")
                    guard let user = Auth.auth().currentUser else {
                        return
                    }
                    let userRef = userItemRef.child(user.uid)
                    let uidValues: [String: Any] = [ "email": Auth.auth().currentUser?.email]
                    userRef.setValue(uidValues)
                    
                    // [학교 데이터 추가]
                    var schoolValues: [String: Any] = [ "schoolName": "서울여자대학교"]
                    if let email = Auth.auth().currentUser?.email {
                        
                        if email.contains("swu") {
                            schoolValues = [ "schoolName": "서울여자대학교"]
                        }
                        else if email.contains("naver") {
                            schoolValues = [ "schoolName": "네이버대학교"]
                        }
                    }
                    ref.child("user").child(user.uid).child("userProfile").updateChildValues(schoolValues)
                    
                    
                    // [이메일 인증]
                    self.emailVFLabel.text = "인증 메일이 발송되었습니다."
                    self.emailVFLabel.textColor = UIColor(named: "purple_184")
                    self.emailVFLabel.isHidden = false
                    self.emailVFAfter.isHidden = false
                    self.emailVFAfter.backgroundColor = UIColor(named: "gray_93")
                    self.emailVFBtn.setTitle("인증 재요청", for: .normal)
                    
                    
                    // 이메일 보내는 부분
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            
                        }
                    })
                    Auth.auth().currentUser?.reload()
                    self.emailVertify()
                }
            }
        }
        else if id == "" {
            self.emailVFLabel.text = "이메일을 입력해주세요."
        }
        else if id.contains("@") {
            self.emailVFLabel.text = "학교 이메일을 입력해주세요."
        }
        else {
            self.emailVFLabel.text = "올바르지 않은 이메일 주소입니다"
        }
 
        
    }

    
    
    // [Button action] 이전으로
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
    // [Button action] 이메일 인증 확인하기
    @IBAction func emailVFAfterBtn(_ sender: UIButton) {
        Auth.auth().currentUser?.reload()
        emailVertify()
        
        Auth.auth().currentUser?.reload()
        emailVertify()
    }
    
    
    // [Button action] 이메일 다음
    @IBAction func emailNextBtn(_ sender: UIButton) {
        let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "passwordVC")
        self.navigationController?.pushViewController(passwordVC!, animated: true)
    }
    // [Button action] 비밀번호 다음
    @IBAction func passwdBtn(_ sender: UIButton) {
        guard let passwd = self.passwordTF.text else{
            return
        }
        Auth.auth().currentUser?.updatePassword(to: passwd, completion: { (error) in
            if error != nil {
                print("error")
                print(error?.localizedDescription)
            }
        })
        print("비밀번호 변경 완료 : \(passwd)")
        // DB에도 추가 [오류! 추가되지 않음/암호화]
        guard let user = Auth.auth().currentUser else {
            return
        }
        ref.child("user").child(user.uid).updateChildValues(["password": passwd])
        ref.child("user").child(user.uid).updateChildValues(["rank": 200])
        let nicknameVC = self.storyboard?.instantiateViewController(withIdentifier: "nicknameVC")
        self.navigationController?.pushViewController(nicknameVC!, animated: true)
        
    }
    // [Button action] 닉네임 다음
    @IBAction func nicknameBtn(_ sender: UIButton) {
        guard let nickname = self.nicknameTF.text else{
            return
        }
        guard let user = Auth.auth().currentUser else {
            return
        }
        let values: [String: Any] = [ "nickname": nickname]
        
        ref = Database.database().reference()
        // 데이터 추가
        ref.child("user").child(user.uid).child("userProfile").updateChildValues(values)
        
        nicknameLabel.text = ""
        nicknameLabel.isHidden = true
        
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "imageVC")
        self.navigationController?.pushViewController(imageVC!, animated: true)
        
    }
    // [Button action] 이미지 다음
    @IBAction func imageBtn(_ sender: UIButton) {
        let partVC = self.storyboard?.instantiateViewController(withIdentifier: "partVC")
        self.navigationController?.pushViewController(partVC!, animated: true)
    }

    
    
    // [Button action] 시작화면으로
    @IBAction func goBackToFirstBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // [Button action] 회원가입 완료 팝업
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let values: [String: Any] = [ "part": partBtn.currentTitle, "partDetail": detailPartBtn.currentTitle]

        
        ref = Database.database().reference()
        // 데이터 추가
        ref.child("user").child(user.uid).child("userProfile").updateChildValues(values)
        
        
        
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "JoinSuccessVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    
    // [Button action] 프로필 이미지 설정 버튼
    @IBAction func profileImageSetBtn(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    
    
    // [Keyboard setting] 화면 클릭시 제거
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        // 이메일 인증 button setting
        if let email = self.emailTF {
            self.emailVFLabel.isHidden = false
            if let emailText = email.text {
                if emailText.isEmpty {
                    self.emailVFBtn.backgroundColor = UIColor.white
                    self.emailVFBtn.layer.borderWidth = 1
                    self.emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                    self.emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                }
                else {
                    self.emailVFBtn.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    // 학교 이메일로 수정 필요 ("ac.kr")
                    if !emailText.contains("@") {
                        self.emailVFLabel.text = "올바르지 않은 이메일 주소입니다."
                        self.emailVFBtn.backgroundColor = UIColor.white
                        self.emailVFBtn.layer.borderWidth = 1
                        self.emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                        self.emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                        
                    }
                    else {
                        self.emailVFLabel.text = ""
                        self.emailVFBtn.backgroundColor = UIColor.white
                        self.emailVFBtn.layer.borderWidth = 1
                        self.emailVFBtn.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                        self.emailVFBtn.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    }
                }
            }
        }
        
        // 비밀번호 다음 button setting
        if let passwd = self.passwordTF {
            if let passwdText = passwd.text {
                if passwdText == "" {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.passwordNextBtn.isEnabled = false
                    self.passwordLabel.isHidden = true
                }
                else if Array(passwdText).count < 7 {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.passwordNextBtn.isEnabled = false
                    self.passwordLabel.isHidden = false
                }
                else {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "purple_184")
                    self.passwordNextBtn.isEnabled = true
                    self.passwordLabel.isHidden = true
                    self.passwordTF.setIcon(UIImage(systemName: "checkmark")!)
                }
            }
        }
        
        // 닉네임 다음 button setting
        if let nickname = self.nicknameTF {
            if let nicknameText = nickname.text {
                
                
                // 닉네임이 이미 있는지 확인
                ref = Database.database().reference()
                let userItemRef = ref.child("user")
                let query = userItemRef.queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nicknameText)
                
                query.observe(.value) { snapshot in
                    for childSnapshot in snapshot.children {
                        if snapshot.childSnapshot(forPath: "email") == Auth.auth().currentUser?.email as!
                            NSObject {
                            print("me")
                        }
                        self.nicknameCount = true
                        print(childSnapshot)
                        print("same nickname boolean =" + "\(self.nicknameCount)")
                        
                        if self.nicknameCount {
                            self.nicknameNextBtn.backgroundColor = UIColor(named: "gray_196")
                            self.nicknameLabel.isHidden = false
                            self.nicknameNextBtn.isEnabled = false
                            self.nicknameTF.setIcon(nil)
                        }
                    }
                }
                if self.nicknameCount || self.nicknameTF.text == "" {
                    self.nicknameNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.nicknameLabel.isHidden = false
                    if self.nicknameTF.text == "" {
                        self.nicknameLabel.text = "닉네임을 입력해주세요."
                    }
                    self.nicknameNextBtn.isEnabled = false
                }
                else {
                    self.nicknameNextBtn.backgroundColor = UIColor(named: "purple_184")
                    self.nicknameNextBtn.isEnabled = true
                    self.nicknameLabel.isHidden = true
                    self.nicknameTF.setIcon(UIImage(systemName: "checkmark")!)
                }
            }
        }
        self.view.endEditing(true)
    }
    
    // [Keyboard setting] return시 제거
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // 이메일 인증 button setting
        if let email = self.emailTF {
            self.emailVFLabel.isHidden = false
            if let emailText = email.text {
                self.emailVFBtn.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                if emailText.isEmpty {
                    self.emailVFBtn.backgroundColor = UIColor.white
                    self.emailVFBtn.layer.borderWidth = 1
                    self.emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                    self.emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                }
                else {
                    // 학교 이메일로 수정 필요 ("ac.kr")
                    if !emailText.contains("@") {
                        self.emailVFLabel.text = "올바르지 않은 이메일 주소입니다."
                        self.emailVFBtn.backgroundColor = UIColor.white
                        self.emailVFBtn.layer.borderWidth = 1
                        self.emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                        self.emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                    }
                    else {
                        self.emailVFLabel.text = ""
                        self.emailVFBtn.backgroundColor = UIColor.white
                        self.emailVFBtn.layer.borderWidth = 1
                        self.emailVFBtn.layer.borderColor = UIColor(named: "purple_184")?.cgColor
                        self.emailVFBtn.setTitleColor(UIColor(named: "purple_184"), for: .normal)
                    }
                }
            }
        }
        
        // 비밀번호 다음 button setting
        if let passwd = self.passwordTF {
            if let passwdText = passwd.text {
                if passwdText == "" {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.passwordNextBtn.isEnabled = false
                    self.passwordLabel.isHidden = true
                }
                else if Array(passwdText).count < 7 {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.passwordNextBtn.isEnabled = false
                    self.passwordLabel.isHidden = false
                }
                else {
                    self.passwordNextBtn.backgroundColor = UIColor(named: "purple_184")
                    self.passwordNextBtn.isEnabled = true
                    self.passwordLabel.isHidden = true
                    self.passwordTF.setIcon(UIImage(systemName: "checkmark")!)
                }
            }
        }
        
        // 닉네임 다음 button setting
        if let nickname = self.nicknameTF {
            if let nicknameText = nickname.text {
                
                
                // 닉네임이 이미 있는지 확인
                let userItemRef = ref.child("user")
                let query = userItemRef.queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nicknameText)
                
                query.observe(.value) { snapshot in
                    for childSnapshot in snapshot.children {
                        self.nicknameCount = true
                        print(childSnapshot)
                        print("same nickname boolean =" + "\(self.nicknameCount)")
                        
                        if self.nicknameCount {
                            self.nicknameNextBtn.backgroundColor = UIColor(named: "gray_196")
                            self.nicknameLabel.isHidden = false
                            self.nicknameNextBtn.isEnabled = false
                            self.nicknameTF.setIcon(nil)
                        }
                    }
                }
                if self.nicknameCount || self.nicknameTF.text == "" {
                    self.nicknameNextBtn.backgroundColor = UIColor(named: "gray_196")
                    self.nicknameLabel.isHidden = false
                    if self.nicknameTF.text == "" {
                        self.nicknameLabel.text = "닉네임을 입력해주세요."
                    }
                    self.nicknameNextBtn.isEnabled = false
                }
                else {
                    self.nicknameNextBtn.backgroundColor = UIColor(named: "purple_184")
                    self.nicknameNextBtn.isEnabled = true
                    self.nicknameLabel.isHidden = true
                    self.nicknameTF.setIcon(UIImage(systemName: "checkmark")!)
                }
                
            
                 
            }
        }
        
        return true
    }
    
    // [image picker setting] firebase storage에 추가
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        guard let editedImage: UIImage = info[.editedImage] as? UIImage else { return }
        guard let imageData: Data = editedImage.jpegData(compressionQuality: 0.0) else {return }
    
        let imageName = Auth.auth().currentUser!.uid + ".jpg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        let ref = Storage.storage().reference().child("user_profile_image").child(imageName)
        ref.putData(imageData as Data, metadata: metaData) { (metaData,error) in
            if let error = error {
                //실패
                print(error)
                return
                
            }else{
                //성공
                print("성공")
                self.loadImageFromFirebase()
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        
                        let resizedImage = self.resizeImage(image: editedImage, width: 150, height: 150)
                        self.profileImageButton.setImage(resizedImage, for: .normal)
                       // self.profileImageButton.setImage(UIImage(data: data!), for: .normal)
                        self.profileImageButton.clipsToBounds = true
                        self.profileImageButton.layer.borderWidth = 0.0
                        self.imageNextBtn.backgroundColor = UIColor(named: "purple_184")
                        self.imageNextBtn.isEnabled = true
                    }
                }
            }
        }
        editImage.isHidden = false
    }
    
    
    
    
    // [PullDownButton setting] 선택 항목을 타이틀에 반영, 타이틀 색상 변경
    func partPullDownBtnSetting() {
        if let partBtn = self.partBtn {
            partBtn.changesSelectionAsPrimaryAction = true
            partBtn.setTitleColor(.black, for: .normal)
        }
        if let detailPartBtn = self.detailPartBtn {
            detailPartBtn.changesSelectionAsPrimaryAction = true
        }
        partSuccess += 1
    }
    
    // [PullDownButton setting] 타이틀 색상 변경
    func detailPartPullDownBtnSetting() {
        if let detailPartBtn = self.detailPartBtn {
            detailPartBtn.setTitleColor(.black, for: .normal)
        }
        partSuccess += 1
        if partSuccess >= 2 {
            self.partNextBtn.backgroundColor = UIColor(named: "purple_184")
            self.partNextBtn.isEnabled = true
        }
    }
    
    // [profile Image setting] 설정한 프로필 이미지 불러오기
    func loadImageFromFirebase() {
        let storage = Storage.storage().reference().child("user_profile_image").child(Auth.auth().currentUser!.uid + ".jpg")
        storage.downloadURL { (url, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            print("다운로드 성공")
            self.dismiss(animated: true, completion: nil)
            self.imageURL = url!
            self.profileImageEditView.isHidden = false
        }
    }
    
    // [Image setting] 이미지 사이즈 조절
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // [nickname checking] 닉네임 중복 감지
    @objc func textFieldDidChange(textField: UITextField) {
        self.nicknameCount = false
        print(self.nicknameCount)
    }
    
    // [email checking] 이메일 인증 확인
    func emailVertify() {
        Auth.auth().addStateDidChangeListener({(user, error) in
            if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
                print("이메일 인증됨")
                self.emailVFLabel.textColor = UIColor(named: "purple_184")
                self.emailVFLabel.text = "인증이 완료되었습니다."
                
                self.emailTF.setIcon(UIImage(systemName: "checkmark")!)
                
                self.emailVFBtn.isEnabled = false
                self.emailVFBtn.backgroundColor = UIColor.white
                self.emailVFBtn.layer.borderWidth = 1
                self.emailVFBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
                self.emailVFBtn.setTitleColor(UIColor(named: "gray_196"), for: .normal)
                
                self.emailVFAfter.isEnabled = false
                self.emailVFAfter.backgroundColor = UIColor(named: "gray_196")
                
                self.emailViewNextBtn.isEnabled = true
                self.emailViewNextBtn.backgroundColor = UIColor(named: "purple_184")
                self.emailViewNextBtn.isHidden = false
                self.emailVFLabel.isHidden = false
                self.emailTF.isEnabled = false
           
                
            } else {
                print("이메일 인증 실패")
                print("currentUser" + String(Auth.auth().currentUser != nil) )
                print("isEmailvertify \( String(describing: Auth.auth().currentUser?.isEmailVerified))")
            }

        })
    }
}


// [TextField setting] 체크 아이콘
extension UITextField {
func setIcon(_ image: UIImage?) {
   let iconView = UIImageView(frame:
                  CGRect(x: -30, y: 10, width: 17, height: 10))
   iconView.image = image
   let iconContainerView: UIView = UIView(frame:
                  CGRect(x: 20, y: 0, width: 20, height: 30))
   iconContainerView.addSubview(iconView)
   rightView = iconContainerView
   rightViewMode = .always
}
}

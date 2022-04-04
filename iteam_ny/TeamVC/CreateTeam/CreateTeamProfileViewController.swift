//
//  CreateTeamProfileViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/02.
//

import UIKit

class CreateTeamProfileViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileImageColl: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var purposeBtn: UIButton!
    @IBOutlet weak var introduceTF: UITextField!
    @IBOutlet weak var contactLinkTF: UITextField!
    @IBOutlet weak var teamNameTF: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var serviceTypeBtns: [UIButton]!

    // 서비스 유형
    var serviceType: [String] = []
    
    // @나연 : 여기서 내 팀 데이터를 받아서 팀원의 "UID.png"제목의 프로필 사진들을 받아옴
    let teamImages: [String] = ["imgUser10.png", "imgUser5.png", "imgUser4.png"]
    var teamMembers: [CustomUser] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        
        //purposeBtn.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        purposeBtn.changesSelectionAsPrimaryAction = true
        
        
        // 팀 이름, 한 줄 소개, 팀 연락 링크 세팅
        introduceTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        introduceTF.leftViewMode = .always
        contactLinkTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 0.0))
        contactLinkTF.leftViewMode = .always
        teamNameTF.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0))
        teamNameTF.leftViewMode = .always
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스크롤뷰에서 texfield사용시 키보드를 내리기 위함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)


    
    }
    
    // [Button Action] 뒤로 가기
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    // [Button Action] 서비스 유형 선택
    @IBAction func serviceTypeAction(_ sender: UIButton) {
        if serviceType.contains((sender.titleLabel?.text)!) {
            sender.layer.backgroundColor = UIColor.clear.cgColor
            sender.setTitleColor(UIColor.black, for: .normal)
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            
            for i in 0...serviceType.count-1 {
                if serviceType[i] == sender.titleLabel?.text {
                    serviceType.remove(at: i)
                }
            }
        }
        else {
            sender.layer.backgroundColor = UIColor(named: "purple_247")?.cgColor
            sender.setTitleColor(UIColor(named: "purple_184"), for: .normal)
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
            serviceType.append((sender.titleLabel?.text)!)
        }
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

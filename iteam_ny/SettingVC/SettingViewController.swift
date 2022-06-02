//
//  SettingViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/18.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingViewController: UIViewController {

    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    // 지역 클릭 제어를 위한 변수
    var checkedBtn_region: [String] = []
    
    // 수식어 클릭 제어를 위한 변수
    var checkedBtn_property: [String] = []
    
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    
    // 지역, 수식어 다음 버튼
    @IBOutlet var nextBtn: [UIButton]!
    
    // 지역 다음 버튼
    @IBOutlet weak var regionBtn: UIButton!
    
    // 수식어 다음 버튼
    @IBOutlet weak var propertyBtn: UIButton!
    
    // 지역 버튼 일괄 관리
    @IBOutlet var regionBtns: [UIButton]!
    // 수식어 버튼 일괄 관리
    @IBOutlet var propertyBtns: [UIButton]!
    // 지역 상관없이 버튼
    @IBOutlet weak var regionCheckedBtn: UIButton!
    // 지역탭 다음으로 넘어가기 위한 변수

    
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    // [Button action] 이전으로
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
    
    // [Button action] 지역 선택 제어
    @IBAction func regionBtn(_ sender: UIButton) {
        if !checkedBtn_region.contains((sender.titleLabel?.text)!) {
            checkedBtn_region.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_247")
            sender.layer.borderWidth = 0.5
            sender.layer.cornerRadius = sender.frame.height/2
            sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
            sender.configuration?.baseForegroundColor = UIColor(named: "purple_184")
            sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
            
            
        }
        else {
            if let firstIndex = checkedBtn_region.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_region.remove(at: firstIndex)
            }
            sender.layer.borderWidth = 0.5
            sender.layer.cornerRadius = sender.frame.height/2
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?.baseForegroundColor  = .black
            sender.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
            
            
        }
        if checkedBtn_region.count >= 1 {
            self.regionBtn.backgroundColor = UIColor(named: "purple_184")
            self.regionBtn.isEnabled = true
        }
        else {
            self.regionBtn.backgroundColor = UIColor(named: "gray_196")
            self.regionBtn.isEnabled = false
        }
        
     print(checkedBtn_region)
    }
    
    // [Button action] 수식어 선택 제어
    @IBAction func propertyBtn(_ sender: UIButton) {
        // 클릭 제어
        if !checkedBtn_property.contains((sender.titleLabel?.text)!) {
            checkedBtn_property.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_247")
           
            sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
            sender.configuration?.baseForegroundColor = UIColor(named: "purple_184")
            sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
            
        }
        else {
            if let firstIndex = checkedBtn_property.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_property.remove(at: firstIndex)
            }
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?
                .baseForegroundColor  = .black
            sender.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
            
        }
        // 선택 개수 제어 - 3개 이상이면 선택퇸 항목 제외 비활성화
        if checkedBtn_property.count >= 3 {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = false
            }
            for i in 0...propertyBtns.count-1 {
                if checkedBtn_property.contains((propertyBtns[i].titleLabel?.text)!) {
                    propertyBtns[i].isEnabled = true
                }
            }
            
            propertyBtn.backgroundColor = UIColor(named: "purple_184")
            propertyBtn.isEnabled = true
        }
        else {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = true
            }
            propertyBtn.backgroundColor = UIColor(named: "gray_196")
            propertyBtn.isEnabled = false
        }
        
     print(checkedBtn_property)
    }
    
    
    // [Button action] 지역 상관없이 버튼 제어
    @IBAction func noRegion(_ sender: UIButton) {
        sender.setImage(UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        if isRegionON {
            sender.tintColor = UIColor(named: "purple_184")
            isRegionON = false
            // 버튼 비활성화 및 초기화
            checkedBtn_region.removeAll()
            for i in 0...regionBtns.count-1 {
                regionBtnInit()
                regionBtns[i].isEnabled = false
            }
            self.regionBtn.backgroundColor = UIColor(named: "purple_184")
            self.regionBtn.isEnabled = true
        }
        else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "gray_229")
            isRegionON = true
            // 버튼 활성화
            for i in 0...regionBtns.count-1 {
                regionBtns[i].isEnabled = true
            }
            self.regionBtn.backgroundColor = UIColor(named: "gray_196")
            self.regionBtn.isEnabled = false
        }
        print(isRegionON)
    }
    @IBAction func regionNextBtn(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        var regionString: String = ""
        for i in 0..<checkedBtn_region.count {
            if i == checkedBtn_region.count-1 {
                regionString += checkedBtn_region[i]
            }
            else {
                regionString += "\(checkedBtn_region[i]), "
            }
        }
        let values: [String: String] = [ "activeZone": regionString]
        
        ref = Database.database().reference()
        // [ 지역 데이터 추가 ]
        ref.child("user").child(user.uid).child("userProfileDetail").updateChildValues(values)
        
        let purposeVC = self.storyboard?.instantiateViewController(withIdentifier: "purposeVC")
        self.navigationController?.pushViewController(purposeVC!, animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<nextBtn.count {
            nextBtn[i].layer.cornerRadius = 8
        }
        if let regionBtns = regionBtns {
            regionBtnInit()
        }
        if let propertyBtns = propertyBtns {
            propertyBtnInit()
        }
        if let regionBtn = regionBtn {
            regionBtn.backgroundColor = UIColor(named: "gray_196")
            regionBtn.isEnabled = false
        }
        if let propertyBtn = propertyBtn {
            propertyBtn.backgroundColor = UIColor(named: "gray_196")
            propertyBtn.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    // [Button design init] 버튼 디자인 초기화
    func regionBtnInit() {
        for i in 0...regionBtns.count-1 {
            regionBtns[i].layer.borderWidth = 0.5
            regionBtns[i].layer.cornerRadius = regionBtns[i].frame.height/2
            regionBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
            regionBtns[i].configuration?.background.backgroundColor = .white
            regionBtns[i].configuration?
                .baseForegroundColor  = .black
         
            regionBtns[i].titleLabel?.numberOfLines = 2
            regionBtns[i].titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
            regionBtns[i].titleLabel?.adjustsFontSizeToFitWidth = true
            regionBtns[i].titleLabel!.minimumScaleFactor = 0.1
            
        }
    }
    func propertyBtnInit() {
        for i in 0...propertyBtns.count-1 {
            propertyBtns[i].layer.borderWidth = 0.5
            propertyBtns[i].layer.cornerRadius = propertyBtns[i].frame.height/2
            propertyBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
            propertyBtns[i].configuration?.background.backgroundColor = .white
            propertyBtns[i].configuration?
                .baseForegroundColor  = .black
        }
    }
    func resolutionFontSize(size: CGFloat) -> CGFloat {
        let size_formatter = size/900
        let result = UIScreen.main.bounds.width * size_formatter
        return result
    }
    
    
    // [Button action] 수식어 설정 완료, 조건 설정 완료 팝업
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        // [수식어 데이터 추가]
        guard let user = Auth.auth().currentUser else {
            return
        }
        var propertyString: String = ""
        for i in 0..<checkedBtn_property.count {
            if i == checkedBtn_property.count-1 {
                propertyString += checkedBtn_property[i]
            }
            else {
                propertyString += "\(checkedBtn_property[i]), "
            }
        }
        let values: [String: String] = [ "character": propertyString]
        
        ref = Database.database().reference()
        // [ 수식어 데이터 추가 ]
        ref.child("user").child(user.uid).child("userProfileDetail").updateChildValues(values)
        addAlertData()
        
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "SettingSuccessVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    func addAlertData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let currentDateString = formatter.string(from: Date())

        ref.child("user").child(Auth.auth().currentUser!.uid).child("memberRequest").child("0").child("requestStmt").setValue("기본")
        ref.child("user").child(Auth.auth().currentUser!.uid).child("memberRequest").child("0").child("requestTime").setValue(currentDateString)
        ref.child("user").child(Auth.auth().currentUser!.uid).child("memberRequest").child("0").child("requestUID").setValue("기본")
        ref.child(Auth.auth().currentUser!.uid).child("userTeam").setValue("")
    }
}

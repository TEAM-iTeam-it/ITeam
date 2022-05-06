//
//  resetRegionViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/26.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetRegionViewController: UIViewController {

    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    // 지역 클릭 제어를 위한 변수
    var checkedBtn_region: [String] = []
    
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    // 지역 다음 버튼
    @IBOutlet weak var regionBtn: UIButton!
    // 지역 버튼 일괄 관리
    @IBOutlet var regionBtns: [UIButton]!
    // 수식어 버튼 일괄 관리
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
    
    @IBAction func regionSaveBtn(_ sender: Any) {
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
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()


        if let regionBtns = regionBtns {
            regionBtnInit()
        }
        if let regionBtn = regionBtn {
            regionBtn.backgroundColor = UIColor(named: "gray_196")
            regionBtn.isEnabled = false
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
    func resolutionFontSize(size: CGFloat) -> CGFloat {
        let size_formatter = size/900
        let result = UIScreen.main.bounds.width * size_formatter
        return result
    }
}

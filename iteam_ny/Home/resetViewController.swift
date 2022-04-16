//
//  resetViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetViewController: UIViewController {

    // Firebase Realtime Database 루트
//    var ref: DatabaseReference!
    
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // 수식어 클릭 제어를 위한 변수
    var checkedBtn_property: [String] = []
    
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    
    
    // 수식어 다음 버튼
    @IBOutlet weak var propertyBtn: UIBarButtonItem!
    

    // 수식어 버튼 일괄 관리
    @IBOutlet var propertyBtns: [UIButton]!
    // 지역 상관없이 버튼
    // 지역탭 다음으로 넘어가기 위한 변수

    
    // [Button action] 수식어 선택 제어
    @IBAction func propertyBtn(_ sender: UIButton) {
        // 클릭 제어
        if !checkedBtn_property.contains((sender.titleLabel?.text)!) {
            checkedBtn_property.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_184")
           
            sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            sender.configuration?.baseForegroundColor = .white
        }
        else {
            if let firstIndex = checkedBtn_property.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_property.remove(at: firstIndex)
            }
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?
                .baseForegroundColor  = .black
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
        
            propertyBtn.isEnabled = true
        }
        else {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = true
            }
            propertyBtn.isEnabled = false
        }
        
     print(checkedBtn_property)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let propertyBtns = propertyBtns {
            propertyBtnInit()
        }
        if let propertyBtn = propertyBtn {
            propertyBtn.isEnabled = false
        }
        // Do any additional setup after loading the view.
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
    
}

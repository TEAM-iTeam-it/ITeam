//
//  SettingViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/18.
//

import UIKit

class SettingViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    // 지역 클릭 제어를 위한 변수
    var checkedBtn_region: [String] = []
    
    // 수식어 클릭 제어를 위한 변수
    var checkedBtn_property: [String] = []
    
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    
    
    // 지역 버튼 일괄 관리
    @IBOutlet var regionBtns: [UIButton]!
    // 수식어 버튼 일괄 관리
    @IBOutlet var propertyBtns: [UIButton]!
    
    

    
    // [Button action] 이전으로
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }
    
    // [Button action] 지역 선택 제어
    @IBAction func regionBtn(_ sender: UIButton) {
        if !checkedBtn_region.contains((sender.titleLabel?.text)!) {
            checkedBtn_region.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = .lightGray
            sender.configuration?.baseForegroundColor  = .white
        }
        else {
            if let firstIndex = checkedBtn_region.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_region.remove(at: firstIndex)
            }
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?.baseForegroundColor  = .black
        }
     print(checkedBtn_region)
    }
    
    // [Button action] 수식어 선택 제어
    @IBAction func propertyBtn(_ sender: UIButton) {
        // 클릭 제어
        if !checkedBtn_property.contains((sender.titleLabel?.text)!) {
            checkedBtn_property.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = .lightGray
            sender.configuration?.baseForegroundColor  = .white
        }
        else {
            if let firstIndex = checkedBtn_property.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_property.remove(at: firstIndex)
            }
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?.baseForegroundColor  = .black
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
        }
        else {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = true
            }
        }
     print(checkedBtn_property)
    }
    
    
    // [Button action] 지역 상관없이 버튼 제어
    @IBAction func noRegion(_ sender: UIButton) {
        if isRegionON {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            isRegionON = false
            // 버튼 비활성화 및 초기화
            checkedBtn_region.removeAll()
            for i in 0...regionBtns.count-1 {
                regionBtns[i].configuration?.background.backgroundColor = .white
                regionBtns[i].configuration?.baseForegroundColor  = .black
                regionBtns[i].isEnabled = false
            }
        }
        else {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            isRegionON = true
            // 버튼 활성화
            for i in 0...regionBtns.count-1 {
                regionBtns[i].isEnabled = true
            }
        }
        print(isRegionON)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
        
        // Do any additional setup after loading the view.
    }
    
    // [Button action] 조건 설정 완료 팝업
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "SettingSuccessVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
}

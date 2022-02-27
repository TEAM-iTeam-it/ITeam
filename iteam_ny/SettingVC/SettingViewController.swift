//
//  SettingViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/18.
//

import UIKit

class SettingViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    // 지역 클릭 제어를 위한 변수
    var checkedBtn_region: [String] = []
    
    // 수식어 클릭 제어를 위한 변수
    var checkedBtn_property: [String] = []
    
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    
    @IBOutlet weak var nextBtn: UIButton!
    
    // 지역 버튼 일괄 관리
    @IBOutlet var regionBtns: [UIButton]!
    // 수식어 버튼 일괄 관리
    @IBOutlet var propertyBtns: [UIButton]!
    // 지역 상관없이 버튼
    @IBOutlet weak var regionCheckedBtn: UIButton!
    

    
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
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_dark")
            sender.layer.borderWidth = 0.5
            sender.layer.cornerRadius = sender.frame.height/2
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            sender.configuration?.baseForegroundColor = .white
        }
        else {
            if let firstIndex = checkedBtn_region.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_region.remove(at: firstIndex)
            }
            sender.layer.borderWidth = 0.5
            sender.layer.cornerRadius = sender.frame.height/2
            sender.layer.borderColor = UIColor(named: "gray_light")?.cgColor
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
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_dark")
           
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            sender.configuration?.baseForegroundColor = .white
        }
        else {
            if let firstIndex = checkedBtn_property.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_property.remove(at: firstIndex)
            }
            sender.layer.borderColor = UIColor(named: "gray_light")?.cgColor
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
        sender.setImage(UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        if isRegionON {
            sender.tintColor = UIColor(named: "purple_dark")
            isRegionON = false
            // 버튼 비활성화 및 초기화
            checkedBtn_region.removeAll()
            for i in 0...regionBtns.count-1 {
                regionBtnInit()
                regionBtns[i].isEnabled = false
            }
        }
        else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "gray_light")
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

        nextBtn.layer.cornerRadius = 8
        if let regionBtns = regionBtns {
            regionBtnInit()
        }
        if let propertyBtns = propertyBtns {
            propertyBtnInit()
        }
        // Do any additional setup after loading the view.
    }
    // [Button design init] 버튼 디자인 초기화
    func regionBtnInit() {
        for i in 0...regionBtns.count-1 {
            regionBtns[i].layer.borderWidth = 0.5
            regionBtns[i].layer.cornerRadius = regionBtns[i].frame.height/2
            regionBtns[i].layer.borderColor = UIColor(named: "gray_light")?.cgColor
            regionBtns[i].configuration?.background.backgroundColor = .white
            regionBtns[i].configuration?
                .baseForegroundColor  = .black
        }
    }
    func propertyBtnInit() {
        for i in 0...propertyBtns.count-1 {
            propertyBtns[i].layer.borderWidth = 0.5
            propertyBtns[i].layer.cornerRadius = propertyBtns[i].frame.height/2
            propertyBtns[i].layer.borderColor = UIColor(named: "gray_light")?.cgColor
            propertyBtns[i].configuration?.background.backgroundColor = .white
            propertyBtns[i].configuration?
                .baseForegroundColor  = .black
        }
    }
    // [Button action] 조건 설정 완료 팝업
    @IBAction func showPopupViewBtn(_ sender: UIButton) {
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "SettingSuccessVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
}

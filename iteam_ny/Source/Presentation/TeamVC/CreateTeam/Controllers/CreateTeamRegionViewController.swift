//
//  CreateTeamRegionViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/05.
//

import UIKit

class CreateTeamRegionViewController: UIViewController {

    var delegate: SendRegionDataDelegate?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    // 지역 클릭 제어를 위한 변수
    var checkedBtn_region: [String] = [] {
        didSet {
            if !checkedBtn_region.isEmpty {
                saveButton.tintColor = UIColor(named: "purple_184")
                saveButton.isEnabled = true
            } else {
                saveButton.tintColor = UIColor(named: "gray_196")
                saveButton.isEnabled = false
            }
        }
    }
    // 지역 버튼 일괄 관리
    @IBOutlet var regionBtns: [UIButton]!
    // 지역 상관없이 버튼
    @IBOutlet weak var regionCheckedBtn: UIButton!
    // 지역 선택 활성화를 위한 변수
    var isRegionON: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionBtnInit()
        navigationBar.shadowImage = UIImage()
        saveButton.tintColor = UIColor(named: "gray_196")
        
        regionCheckedBtn.setImage(UIImage(named: "btnCheckBox.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        delegate?.sendRegionData(data: checkedBtn_region)
        self.dismiss(animated: true, completion: nil)
    }
    
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
        
     print(checkedBtn_region)
    }
    
    // 지역 상관없이 버튼 제어
    @IBAction func noRegion(_ sender: UIButton) {
        // btnCheckBox.png
  
        if isRegionON {
            sender.tintColor = UIColor(named: "purple_184")
            isRegionON = false
            // 버튼 비활성화 및 초기화
            checkedBtn_region.removeAll()
            for i in 0...regionBtns.count-1 {
                regionBtnInit()
                regionBtns[i].isEnabled = false
            }
        }
        else {
            sender.tintColor = UIColor(named: "gray_229")
            isRegionON = true
            // 버튼 활성화
            for i in 0...regionBtns.count-1 {
                regionBtns[i].isEnabled = true
            }
        }
        print(isRegionON)
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
            regionBtns[i].titleLabel!.font = UIFont.fontWithName(type: .regular, size: 14)
            
        }
    }
}
protocol SendRegionDataDelegate {
    func sendRegionData(data: [String])
}

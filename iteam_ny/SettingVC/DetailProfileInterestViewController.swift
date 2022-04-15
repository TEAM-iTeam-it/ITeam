//
//  DetailProfileInterestViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/11.
//

import UIKit

class DetailProfileInterestViewController: UIViewController {

    var delegate: SendDataDelegate?

    @IBOutlet weak var interestNavigationBar: UINavigationBar!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet var interestBtns: [UIButton]!
    // 관심사 클릭 제어를 위한 변수
    var checkedBtn_interest: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let interestBtns = interestBtns {
            interestBtnInit()
        }
        interestNavigationBar.shadowImage = UIImage()

    }
    @IBAction func interestBtnAction(_ sender: UIButton) {
        // 클릭 제어
        if !checkedBtn_interest.contains((sender.titleLabel?.text)!) {
            checkedBtn_interest.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_247")
           
            sender.layer.borderColor = UIColor(named: "purple_247")?.cgColor
            sender.configuration?.baseForegroundColor = UIColor(named: "purple_184")
            sender.titleLabel?.font = UIFont.fontWithName(type: .medium, size: 14)
            
        }
        else {
            if let firstIndex = checkedBtn_interest.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_interest.remove(at: firstIndex)
            }
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?
                .baseForegroundColor  = .black
            sender.titleLabel?.font = UIFont.fontWithName(type: .regular, size: 14)
            
        }
        // 선택 개수 제어 - 3개 이상이면 선택퇸 항목 제외 비활성화
        if checkedBtn_interest.count >= 3 {
            for i in 0...interestBtns.count-1 {
                interestBtns[i].isEnabled = false
            }
            for i in 0...interestBtns.count-1 {
                if checkedBtn_interest.contains((interestBtns[i].titleLabel?.text)!) {
                    interestBtns[i].isEnabled = true
                }
            }
        }
        else {
            for i in 0...interestBtns.count-1 {
                interestBtns[i].isEnabled = true
            }
        }
        if checkedBtn_interest.count >= 1 {
            saveBtn.tintColor = UIColor(named: "purple_184")
            saveBtn.isEnabled = true
        }
        else {
            saveBtn.tintColor = UIColor(named: "gray_196")
            saveBtn.isEnabled = false
        }
        
     print(checkedBtn_interest)
        
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        delegate?.sendData(data: checkedBtn_interest)
        dismiss(animated: true, completion: nil)
    }
    
    func interestBtnInit() {
        for i in 0...interestBtns.count-1 {
            interestBtns[i].layer.borderWidth = 0.5
            interestBtns[i].layer.cornerRadius = interestBtns[i].frame.height/2
            interestBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
            interestBtns[i].configuration?.background.backgroundColor = .white
            interestBtns[i].configuration?
                .baseForegroundColor  = .black
        }
    }
    

}
protocol SendDataDelegate {
    func sendData(data: [String])
}


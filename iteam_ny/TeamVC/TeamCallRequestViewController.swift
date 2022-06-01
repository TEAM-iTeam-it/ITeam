//
//  TeamCallRequestViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/03.
//
// TeamCallRequestViewController


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MaterialComponents.MaterialBottomSheet

class TeamCallRequestViewController: UIViewController{
    
    var senderid : String = ""
    var ref: DatabaseReference!
    //  @IBOutlet var TimeBtns: [UIButton]!
    @IBOutlet weak var selectTime_3: UIButton!
    @IBOutlet weak var selectTime_2: UIButton!
    @IBOutlet weak var selectTime_1: UIButton!
    @IBOutlet var buttons: Array<UIButton>!
    @IBOutlet var selectNumLabel: [UILabel]!
    @IBOutlet var dateLabel: [UILabel]!
    @IBOutlet weak var nextButton: UIButton!
    
    var selectTime: Date?
    var dateTimes: [String] = ["", "", ""]
    var count: Int = 0 {
        willSet(newValue) {
            if newValue >= 3 {
                nextButton.isEnabled = true
                nextButton.backgroundColor = UIColor(named: "purple_184")
            }
        }
    }
    var receiverNickname: String = ""
    var receiverType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in 0..<buttons.count {
            buttons[i].layer.cornerRadius = 16
            selectNumLabel[i].layer.cornerRadius = selectNumLabel[i].frame.height/2
            selectNumLabel[i].clipsToBounds = true
            selectNumLabel[i].textColor = UIColor(named: "purple_184")
            selectNumLabel[i].backgroundColor = UIColor(named: "purple_247")
            selectNumLabel[i].isHidden = true
        }
        for i in 0..<dateLabel.count {
            dateLabel[i].sizeToFit()
        }
        nextButton.layer.cornerRadius = 8
        nextButton.isEnabled = false
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setTitleColor(.white, for: .disabled)
        
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //첫번째, 두번째 세번째버튼을 선택했을 때
    @IBAction func btnClicked(_ sender: UIButton) {
        
        let btnNumber = buttons.firstIndex(of: sender)
        var buttonTitle: String = ""
        
        switch btnNumber {
        case 0:
            buttonTitle = "첫번째"
        case 1:
            buttonTitle = "두번째"
        case 2:
            buttonTitle = "세번째"
        default:
            buttonTitle = ""
        }
       
        let stroyboard = UIStoryboard.init(name: "TeamCallRequest", bundle: nil)
        let vc1 = stroyboard.instantiateViewController(withIdentifier: "callTimeVC") as! CallDateNTimeViewController
        
        vc1.buttonIndex = buttonTitle
        vc1.delegate = self
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: vc1)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 300
        present(bottomSheet, animated: true, completion: nil)
        
    }
    
    
    //다음 버튼 클릭했을때
    @IBAction func TimeNextBtn(_ sender: UIButton) {
        
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "TeamCallRequestQuestionViewController") as? TeamCallRequestQuestionViewController else {
            return
        }
        vc.dateTimes = dateTimes
        vc.receiverNickname = receiverNickname
        vc.receiverType = receiverType
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}


extension TeamCallRequestViewController: SendCallTimeNDateDataDelegate {
    func sendCallTimeNDateData(data: String) {
        let dateNTimeString = data
        let index = dateNTimeString.index(dateNTimeString.startIndex, offsetBy: 3)
        var result = dateNTimeString.substring(from: index)
        if result.last == " " {
            result = String(result.dropLast()).replacingOccurrences(of: " 0", with: " ")
        }
        print(result)
        
        if dateNTimeString.contains("첫번째") {
            
            selectNumLabel[0].isHidden = false
            dateLabel[0].isHidden = true
            dateLabel[1].textColor = .black
            
            dateLabel[1].text = result
            
            buttons[0].backgroundColor = .white
            buttons[0].layer.borderWidth = 0
            buttons[0].layer.borderColor = UIColor.black.cgColor
            buttons[0].layer.shadowColor = UIColor.black.cgColor
            buttons[0].layer.shadowOffset = CGSize(width: 0, height: 0)
            buttons[0].layer.shadowOpacity = 0.2
            buttons[0].layer.shadowRadius = 10
            buttons[0].layer.masksToBounds = false
            
            dateTimes[0] = result
            count += 1
            
        }
        else if dateNTimeString.contains("두번째") {
            selectNumLabel[1].isHidden = false
            dateLabel[2].isHidden = true
            dateLabel[3].textColor = .black
            
            dateLabel[3].text = result
            
            buttons[1].backgroundColor = .white
            buttons[1].layer.borderWidth = 0
            buttons[1].layer.borderColor = UIColor.black.cgColor
            buttons[1].layer.shadowColor = UIColor.black.cgColor
            buttons[1].layer.shadowOffset = CGSize(width: 0, height: 0)
            buttons[1].layer.shadowOpacity = 0.2
            buttons[1].layer.shadowRadius = 10
            buttons[1].layer.masksToBounds = false
            
            dateTimes[1] = result
            count += 1
        }
        else if dateNTimeString.contains("세번째") {
            selectNumLabel[2].isHidden = false
            dateLabel[4].isHidden = true
            dateLabel[5].textColor = .black
            
            dateLabel[5].text = result
            
            buttons[2].backgroundColor = .white
            buttons[2].layer.borderWidth = 0
            buttons[2].layer.borderColor = UIColor.black.cgColor
            buttons[2].layer.shadowColor = UIColor.black.cgColor
            buttons[2].layer.shadowOffset = CGSize(width: 0, height: 0)
            buttons[2].layer.shadowOpacity = 0.2
            buttons[2].layer.shadowRadius = 10
            buttons[2].layer.masksToBounds = false
            
            dateTimes[2] = result
            count += 1
        }
  
    }
}


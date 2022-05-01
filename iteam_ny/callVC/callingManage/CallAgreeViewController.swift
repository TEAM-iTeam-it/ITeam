//
//  CallAgreeViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/01.
//

import UIKit

class CallAgreeViewController: UIViewController {

    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet var selectNumLabel: [UILabel]!
    @IBOutlet var timeLabel: [UILabel]!
    
    var times: [String] = []
    var dismissTrigger: Bool = false {
        willSet(newValue) {
            print(newValue)
            if newValue {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    var questionArr: [String] = []
    var callerNickname: String = ""
    var selected: Bool = false {
        willSet(newValue) {
            print("newValue \(newValue)")
            if newValue {
                nextButton.backgroundColor = UIColor(named: "green_87")
                nextButton.isEnabled = true
            }
            else {
                nextButton.backgroundColor = UIColor(named: "gray_196")
                nextButton.isEnabled = false
                
            }
        }
    }
    var selectedTime: String = ""
    var teamName: String = ""
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "CallAgree", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    func setUI() {
        
        for i in 0...2 {
            buttons[i].layer.cornerRadius = 16
            selectNumLabel[i].layer.cornerRadius = selectNumLabel[i].frame.height/2
            selectNumLabel[i].clipsToBounds = true
            
        }
        nextButton.layer.cornerRadius = 8
        nextButton.backgroundColor = UIColor(named: "gray_196")
        nextButton.setTitleColor(.white, for: .disabled)
        nextButton.setTitleColor(.white, for: .normal)
        print(times.count)
        for i in 0..<times.count {
            timeLabel[i].text = times[i]
        }
        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextBtnAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let questionVC = storyboard.instantiateViewController(withIdentifier: "questionVC") as? QuestionnaireViewController
        questionVC!.questionArr = questionArr
        questionVC!.nickname = callerNickname
        questionVC!.teamName = teamName
        questionVC!.selectedTime = selectedTime
        
        
        navigationController?.pushViewController(questionVC!, animated: true)
      
    }
    @IBAction func timeButtonAction(_ sender: UIButton) {
        selected = true
        for i in 0..<buttons.count {
            buttons[i].backgroundColor = UIColor(named: "gray_245")
            buttons[i].layer.borderWidth = 0
            timeLabel[i].textColor = UIColor(named: "gray_121")
            selectNumLabel[i].textColor = UIColor(named: "gray_121")
            selectNumLabel[i].backgroundColor = UIColor(named: "gray_229")
            
        }
        sender.backgroundColor = UIColor(named: "green_243")
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = UIColor(named: "green_87")?.cgColor
        
        
        if sender == firstButton {
            timeLabel[0].textColor = UIColor(named: "green_87")
            selectNumLabel[0].textColor = .white
            selectNumLabel[0].backgroundColor = UIColor(named: "green_87")
            selectedTime = timeLabel[0].text!
        }
        else if sender == secondButton {
            timeLabel[1].textColor = UIColor(named: "green_87")
            selectNumLabel[1].textColor = .white
            selectNumLabel[1].backgroundColor = UIColor(named: "green_87")
            selectedTime = timeLabel[1].text!
        }
        else {
            timeLabel[2].textColor = UIColor(named: "green_87")
            selectNumLabel[2].textColor = .white
            selectNumLabel[2].backgroundColor = UIColor(named: "green_87")
            selectedTime = timeLabel[2].text!
        }
        
    }
    @IBAction func refuceBtnAction(_ sender: UIButton) {
        let refusePopUpVC = thisStoryboard.instantiateViewController(withIdentifier: "refusePopUpVC") as! CallRefusePopupViewController
        refusePopUpVC.modalPresentationStyle = .overFullScreen
        refusePopUpVC.teamIndex = teamName
        refusePopUpVC.delegate = self
        print("teamName \(teamName)")
        present(refusePopUpVC, animated: false, completion: nil)
    }
    


}
extension CallAgreeViewController: DissmissListner {
    func dismissRequest(data: Bool) {
        dismissTrigger = data
    }
    
    
}

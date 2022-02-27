//
//  SettingPassionViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit

class SettingPassionViewController: UIViewController {

    @IBOutlet var passionBtns: [UIButton]!
    // 성적 저장을 위한 변수
    var passions: [String] = []
    var passion: String?
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 8
        
        for i in 0...passionBtns.count-1 {
            passionBtns[i].layer.cornerRadius = 16
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func passionBtnClicked(_ sender: UIButton) {
        if passion == sender.titleLabel?.text {
            sender.backgroundColor = UIColor(named: "gray_light3")
            sender.layer.borderWidth = 0
            passion = nil
        }
        else if passion != nil {
            for i in 0...passionBtns.count-1 {
                if passionBtns[i].titleLabel?.text == passion {
                    passionBtns[i].backgroundColor = UIColor(named: "gray_light3")
                    passionBtns[i].layer.borderWidth = 0
                }
            }
            sender.backgroundColor = UIColor(named: "purple_light")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            passion = sender.titleLabel?.text!
        }
        else {
            sender.backgroundColor = UIColor(named: "purple_light")
            sender.layer.borderWidth = 0.5
            sender.layer.borderColor = UIColor(named: "purple_dark")?.cgColor
            passion = sender.titleLabel?.text!
        }
        print(passion)
    }
    @IBAction func goBackBtn(_ sender: UIBarButtonItem) {
        goBack()
    }
    @objc func goBack() {
           self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

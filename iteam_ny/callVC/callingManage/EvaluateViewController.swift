//
//  EvaluateViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/04.
//

import UIKit

class EvaluateViewController: UIViewController {

    @IBOutlet var evaluateBtns: [UIButton]!
    @IBOutlet weak var nextBtn: UIButton!
    var selectedBtn: [String] = []
    
    @IBOutlet var evaluLabel: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
        
    }
    @IBAction func evaluateBtn(_ sender: UIButton) {
   
        if sender.isSelected == true {
            sender.isSelected = false
           sender.setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "gray_light2")
            selectedBtn.removeAll()
            
        }
        else {
            if selectedBtn.count >= 1 {
                for i in 0...evaluateBtns.count-1 {
                    evaluateBtns[i].isSelected = false
                    evaluateBtns[i].setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    evaluateBtns[i].tintColor = UIColor(named: "gray_light2")
                    selectedBtn.removeAll()
                }
            }
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "purple_184")
            switch sender {
            case evaluateBtns[0]:
                selectedBtn.append(evaluLabel[0].text!)
            case evaluateBtns[1]:
                selectedBtn.append(evaluLabel[1].text!)
            case evaluateBtns[2]:
                selectedBtn.append(evaluLabel[2].text!)
            case evaluateBtns[3]:
                selectedBtn.append(evaluLabel[3].text!)
            default:
                selectedBtn.append(evaluLabel[4].text!)
                
            }
          
        }
        print(selectedBtn)
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

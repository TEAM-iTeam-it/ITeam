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
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func evaluateBtn(_ sender: UIButton) {
   
        if sender.isSelected == true {
            sender.isSelected = false
           sender.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = .lightGray
            selectedBtn.removeAll()
            
        }
        else {
            if selectedBtn.count >= 1 {
                for i in 0...evaluateBtns.count-1 {
                    evaluateBtns[i].isSelected = false
                    evaluateBtns[i].setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
                    evaluateBtns[i].tintColor = .lightGray
                    selectedBtn.removeAll()
                }
            }
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "purple_dark")
            selectedBtn.append((sender.titleLabel?.text)!.trimmingCharacters(in: .whitespaces))
          
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

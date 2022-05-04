//
//  PopupViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/12.
//

import UIKit

class PopupViewController: UIViewController {
    @IBOutlet weak var plannerBtn: UIButton!
    @IBOutlet weak var designerBtn: UIButton!
    @IBOutlet weak var developerBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var subscribeBtnCompletionClosure: (()-> Void)?
    var subscribeBtnCompletionClosure2: (()-> Void)?
    var subscribeBtnCompletionClosure3: (()-> Void)?
    var delegate : PickpartDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PopupViewController - viewDidLoad() called")
    }
    @IBAction func onBackBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPlannerClicked(_ sender: Any) {
        if let subscribeBtnCompletionClosure = subscribeBtnCompletionClosure {
            subscribeBtnCompletionClosure()
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func onDesignerClicked(_ sender: Any) {
        print("개발자 클릭")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeveloperClicked(_ sender: Any) {
    }
}

protocol PickpartDataDelegate {
    func SendTimeData(data: String)

}

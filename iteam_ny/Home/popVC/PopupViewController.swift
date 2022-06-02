//
//  PopupViewController.swift
//  iteam_ny
//
//  Created by 성나연 on 2022/04/12.
//

import UIKit

class PopupViewController: UIViewController {
    @IBOutlet weak var plannerBtn: UIButton!
    @IBOutlet weak var designerBtn: UIButton!
    @IBOutlet weak var developerBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var subscribeBtnCompletionClosure: (()-> Void)?
    var subscribeBtnCompletionClosure2: (()-> Void)?
    var subscribeBtnCompletionClosure3: (()-> Void)?
    var delegate : PickpartDataDelegate?
    var partCategory : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 16
        
        print("PopupViewController - viewDidLoad() called")
    }
    
    @IBAction func onBackBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onPlannerClicked(_ sender: Any) {
//        if let subscribeBtnCompletionClosure = subscribeBtnCompletionClosure {
//            subscribeBtnCompletionClosure()
//        }
        partCategory = "기획자"
        self.delegate?.SendCategoryData(data: partCategory)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func onDesignerClicked(_ sender: Any) {
        print("디자이너 클릭")
        partCategory = "디자이너"
        self.delegate?.SendCategoryData(data: partCategory)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeveloperClicked(_ sender: Any) {
        partCategory = "개발자"
        self.delegate?.SendCategoryData(data: partCategory)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol PickpartDataDelegate {
    func SendCategoryData(data: String)

}

//
//  DetailProfileViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/19.
//

import UIKit

class DetailProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var toolLangTF: UITextField!
    @IBOutlet weak var interestTF: UITextField!
    @IBOutlet weak var projectTF: UITextView!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var portfoliolinkTF: UITextField!
    @IBOutlet weak var callLinkTF: UITextField!
    
    @IBOutlet weak var successBtn: UIButton!
    @IBAction func goBackToPopupBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        successBtn.layer.cornerRadius = 8
        toolLangTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        interestTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        projectTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        
        timeTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        portfoliolinkTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        callLinkTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//
//  DetailProfileProjectExViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/12.
//

import UIKit

class DetailProfileProjectExViewController: UIViewController {


    @IBOutlet weak var startDateBtn: UIButton!
    @IBOutlet weak var endDateBtn: UIButton!
    @IBOutlet weak var projectTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var projectExNavigationBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    
    func setUI() {
        projectExNavigationBar.shadowImage = UIImage()
        
        startDateBtn.layer.cornerRadius = 8
        startDateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        startDateBtn.layer.borderWidth = 0.5
        endDateBtn.layer.cornerRadius = 8
        endDateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        endDateBtn.layer.borderWidth = 0.5
        
        projectTF.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        projectTF.layer.cornerRadius = 8
        projectTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        projectTF.layer.borderWidth = 0.5
    }
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension DetailProfileProjectExViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}

protocol SendProjectExDelegate {
    func sendData(data: [String])
}

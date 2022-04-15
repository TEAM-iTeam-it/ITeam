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
    
    
    var delegate: SendProjectExDelegate?
    
    var didTextFieldWrote: Bool = false {
        willSet(newValue) {
            if newValue == true {
                count += 1
            }
            else {
                count -= 1
            }
        }
    }
    
    var count: Int = 0 {
        willSet(newValue) {
            print(newValue)
            if newValue >= 3{
                saveBtn.isEnabled = true
                saveBtn.tintColor = UIColor(named: "purple_184")
            }
            else {
                saveBtn.isEnabled = false
                saveBtn.tintColor = UIColor(named: "gray_196")
            }
        }
    }
    var didStartDateWrote: Bool = false
    var didEndDateWrote: Bool = false

    
    
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
    
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        var fullExString: [String] = []
        fullExString.append((self.startDateBtn.titleLabel?.text!)!)
        fullExString.append((self.endDateBtn.titleLabel?.text!)!)
        fullExString.append(projectTF.text!)
        self.delegate?.sendProjectExData(data: fullExString)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func setStartDateAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let dateVC = thisStoryboard.instantiateViewController(withIdentifier: "dateVC") as? DetailProfileProjectStartDateViewController
        dateVC?.delegate = self
        dateVC?.startOREnd = "start"
        
        present(dateVC!, animated: true, completion: nil)
    }
    @IBAction func setEndDateAction(_ sender: UIButton) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let dateVC = thisStoryboard.instantiateViewController(withIdentifier: "dateVC") as? DetailProfileProjectStartDateViewController
        dateVC?.delegate = self
        dateVC?.startOREnd = "end"
        if let startDate = self.startDateBtn.titleLabel?.text{
            if startDate != "시작일" {
                dateVC?.startDate = startDate
            }
        }
        present(dateVC!, animated: true, completion: nil)
    }
    

}

extension DetailProfileProjectExViewController: SendDateDataDelegate {
    func sendEndDate(data: String) {
        self.endDateBtn.setTitle(data, for: .normal)
        self.endDateBtn.setTitleColor(UIColor.black, for: .normal)
        
        if didEndDateWrote == false {
            didEndDateWrote = true
            count += 1
        }
    }
    func sendStartData(data: String) {
        self.startDateBtn.setTitle(data, for: .normal)
        self.startDateBtn.setTitleColor(UIColor.black, for: .normal)
        if didStartDateWrote == false {
            didStartDateWrote = true
            count += 1
            
        }
    }
}

extension DetailProfileProjectExViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.hasText {
            didTextFieldWrote = true
        }
        else {
            didTextFieldWrote = false
        }
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
}

protocol SendProjectExDelegate {
    func sendProjectExData(data: [String])
}

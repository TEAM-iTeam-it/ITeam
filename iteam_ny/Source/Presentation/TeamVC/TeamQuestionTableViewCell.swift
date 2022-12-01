//
//  TeamQuestionTableViewCell.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/04.
//

import UIKit

class TeamQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    var delegate: SendAddQuestionDataDelegate?
    var delegate2: SendButtonDataDelegate?
    var didSelected: Bool = false
    var questionCount = QuestionCount.shared.count
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func writeBtnAction(_ sender: UIButton) {
        textField.isHidden = false
        buttonView.isHidden = true
        self.delegate?.sendAddQuestionSignal()
    }
    @IBAction func selectBtnAction(_ sender: UIButton) {
        func setTrueButton() {
            sender.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "purple_184")
        }
        func setFalseButton() {
            sender.setImage(UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            sender.tintColor = UIColor(named: "gray_229")
        }
        
        if didSelected == false {
            if questionCount < 5 {
                print(questionCount)
                didSelected = true
                setTrueButton()
                questionCount += 1
                if self.textField.text != nil {
                    self.delegate2?.sendAddData(data: self.textField.text! )
                }
            }
            
        }
        else {
            didSelected = false
            setFalseButton()
            questionCount -= 1
            if self.textField.text != nil {
                self.delegate2?.sendRemoveData(data: self.textField.text! )
            }
        }
        
        
    }
    
    
}
extension TeamQuestionTableViewCell: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
}
protocol SendAddQuestionDataDelegate {
    func sendAddQuestionSignal()
}
protocol SendButtonDataDelegate {
    func sendAddData(data: String)
    func sendRemoveData(data: String)
}

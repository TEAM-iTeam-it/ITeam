//
//  resetCharacterView.swift
//  iteam_ny
//
//  Created by 성의연 on 2022/04/19.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class resetCharacterView: UIViewController {

    var ref: DatabaseReference!
    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var checkedBtn_property: [String] = []
    
    @IBOutlet weak var propertyBtn: UIBarButtonItem!
    
    @IBOutlet var propertyBtns: [UIButton]!

    @IBAction func propertyBtn(_ sender: UIButton) {
        // 클릭 제어
        if !checkedBtn_property.contains((sender.titleLabel?.text)!) {
            checkedBtn_property.append((sender.titleLabel?.text)!)
            
            sender.configuration?.background.backgroundColor = UIColor(named: "purple_184")
           
            sender.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            sender.configuration?.baseForegroundColor = .white
        }
        else {
            if let firstIndex = checkedBtn_property.firstIndex(of: (sender.titleLabel?.text)!) {
                checkedBtn_property.remove(at: firstIndex)
            }
            sender.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            sender.configuration?.background.backgroundColor = .white
            sender.configuration?
                .baseForegroundColor  = .black
        }
        // 선택 개수 제어 - 3개 이상이면 선택퇸 항목 제외 비활성화
        if checkedBtn_property.count >= 3 {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = false
            }
            for i in 0...propertyBtns.count-1 {
                if checkedBtn_property.contains((propertyBtns[i].titleLabel?.text)!) {
                    propertyBtns[i].isEnabled = true
                }
            }
        
            propertyBtn.isEnabled = true
        }
        else {
            for i in 0...propertyBtns.count-1 {
                propertyBtns[i].isEnabled = true
            }
            propertyBtn.isEnabled = false
        }
        
     print(checkedBtn_property)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let propertyBtns = propertyBtns {
            propertyBtnInit()
        }
        if let propertyBtn = propertyBtn {
            propertyBtn.isEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    func propertyBtnInit() {
        for i in 0...propertyBtns.count-1 {
            propertyBtns[i].layer.borderWidth = 0.5
            propertyBtns[i].layer.cornerRadius = propertyBtns[i].frame.height/2
            propertyBtns[i].layer.borderColor = UIColor(named: "gray_196")?.cgColor
            propertyBtns[i].configuration?.background.backgroundColor = .white
            propertyBtns[i].configuration?
                .baseForegroundColor  = .black
        }
    }
    func resolutionFontSize(size: CGFloat) -> CGFloat {
        let size_formatter = size/900
        let result = UIScreen.main.bounds.width * size_formatter
        return result
    }
    
    @IBAction func saveClicked(_ sender: Any) {

        guard let user = Auth.auth().currentUser else {
            return
        }
        var propertyString: String = ""
        for i in 0..<checkedBtn_property.count {
            if i == checkedBtn_property.count-1 {
                propertyString += checkedBtn_property[i]
            }
            else {
                propertyString += "\(checkedBtn_property[i]), "
            }
        }
        let values: [String: String] = [ "character": propertyString]
        
        ref = Database.database().reference()

        ref.child("user").child(user.uid).child("userProfileDetail").updateChildValues(values)
    }
}
    


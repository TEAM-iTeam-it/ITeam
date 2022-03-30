//
//  CallRequstHistoryViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/22.
//

import UIKit

class CallRequstHistoryViewController: UIViewController {
    @IBOutlet weak var sameSchoolLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sameSchoolLabel.layer.borderWidth = 0.5
        sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
        sameSchoolLabel.textColor = UIColor(named: "purple_184")
        
        sameSchoolLabel.layer.cornerRadius = sameSchoolLabel.frame.height/2
        sameSchoolLabel.text = "같은 학교"
        
        profileView.layer.borderWidth = 0
        profileView.layer.cornerRadius = 24
        profileView.layer.borderColor = UIColor.black.cgColor
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.2
        profileView.layer.shadowRadius = 8.0
        
        
        
        
        // navigation.barTintColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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



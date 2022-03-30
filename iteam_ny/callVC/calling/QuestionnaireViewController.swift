//
//  QuestionnaireViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/22.
//

import UIKit

class QuestionnaireViewController: UIViewController {

    
    var nickname: String = ""
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeBtn.layer.cornerRadius = 8
        titleLabel.text = "\(nickname) 님이 궁금해해요!"
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

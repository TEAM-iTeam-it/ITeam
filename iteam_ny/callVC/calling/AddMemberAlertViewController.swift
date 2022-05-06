//
//  AddMemberAlertViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit

class AddMemberAlertViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var okayBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        okayBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        // Do any additional setup after loading the view.
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

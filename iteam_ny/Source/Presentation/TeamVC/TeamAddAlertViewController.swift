//
//  TeamAddAlertViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/02.
//

import UIKit

class TeamAddAlertViewController: UIViewController {

    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 16
        alertButton.layer.cornerRadius = 8

    }
    @IBAction func alertBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    


}

//
//  ReportPersonAlertViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/08.
//

import UIKit

class ReportPersonAlertViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var okayBtn: UIButton!
    
    var otherPersonUID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        okayBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        
        print(otherPersonUID)
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false)
    }
    

}

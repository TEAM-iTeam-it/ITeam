//
//  CallReportViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/08.
//

import UIKit

class CallReportViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    var otherPersonUID: String = ""
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var yesBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        noBtn.layer.cornerRadius = 8
        yesBtn.layer.cornerRadius = 8
        
    }
    @IBAction func sendAlertMessage(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "reportAlertVC") as! ReportPersonAlertViewController
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

    
}

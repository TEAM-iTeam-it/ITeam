//
//  CallClosedViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit

class CallClosedViewController: UIViewController {

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
    
    // 팀원 추가 요청 팝업
    @IBAction func sendAddMemberMessage(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "AddMemberAlertVC") as! AddMemberAlertViewController
        print("callclosed : \(otherPersonUID) ")
        popupVC.otherPersonUID = otherPersonUID
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

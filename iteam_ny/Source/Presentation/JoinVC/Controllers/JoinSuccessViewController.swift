//
//  JoinSuccessViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/17.
//

import UIKit

class JoinSuccessViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    @IBOutlet weak var successBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        successBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
    }
    
    @IBAction func successBtn(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        let SettingStartVC = thisStoryboard.instantiateViewController(withIdentifier: "SettingRegionVC")
        SettingStartVC.modalPresentationStyle = .overFullScreen
        present(SettingStartVC, animated: false, completion: nil)
    }
    


}

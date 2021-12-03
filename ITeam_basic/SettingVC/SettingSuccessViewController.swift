//
//  SettingSuccessViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/18.
//

import UIKit

class SettingSuccessViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    @IBAction func goBackBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    


}

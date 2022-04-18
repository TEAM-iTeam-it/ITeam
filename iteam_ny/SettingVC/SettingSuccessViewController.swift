//
//  SettingSuccessViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/18.
//

import UIKit

class SettingSuccessViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
    @IBOutlet weak var fillProfileBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillProfileBtn.layer.cornerRadius = 8
        popupView.layer.cornerRadius = 16
        popupView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBackBtn(_ sender: UIButton) {
  

        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateInitialViewController() as? TabarController  {
           
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true, completion: nil)
           //  present(tabBarVC, animated: true, completion: nil)
        }
        
        // self.dismiss(animated: false, completion: nil)
    }
    
    


}

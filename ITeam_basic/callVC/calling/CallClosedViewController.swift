//
//  CallClosedViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/30.
//

import UIKit

class CallClosedViewController: UIViewController {

    let thisStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    // 팀원 추가 요청 팝업
    @IBAction func sendAddMemberMessage(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let popupVC = thisStoryboard.instantiateViewController(withIdentifier: "AddMemberAlertVC")
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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

//
//  CallRefusePopupViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/02.
//

import UIKit
import FirebaseDatabase

class CallRefusePopupViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var popupview: UIView!
    
    var teamIndex: String = ""
    var delegate: DissmissListner?
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    func setUI() {
        cancelBtn.layer.cornerRadius = 8
        refuseBtn.layer.cornerRadius = 8
        popupview.layer.cornerRadius = 16
        
        
    }
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func refuseBtnAction(_ sender: UIButton) {
        let values: [String: String] = [ "stmt": "요청거절됨" ]
        db.child("Call").child(teamIndex).updateChildValues(values)
        self.delegate?.dismissRequest(data: true)
        guard let presentingVC = self.presentingViewController else {
            return
        }
        presentingVC.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
        
       // self.dismiss(animated: false, completion: nil)
        
    }
    
}
protocol DissmissListner {
    func dismissRequest(data: Bool)
}

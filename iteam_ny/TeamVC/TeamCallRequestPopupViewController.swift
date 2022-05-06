//
//  TeamCallRequestPopupViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/04.
//

import UIKit

class TeamCallRequestPopupViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var delegate: SendCallPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    func setUI() {
        popUpView.layer.cornerRadius = 16
        cancelButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        
    }
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func checkBtnAction(_ sender: UIButton) {
        self.delegate?.sendGotoCallPageSignal()
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
protocol SendCallPageDelegate {
    func sendGotoCallPageSignal()
}

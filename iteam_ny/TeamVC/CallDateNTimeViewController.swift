//
//  CallDateNTimeViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/03.
//

import UIKit
import SwiftUI

class CallDateNTimeViewController: UIViewController {
    var delegate : SendCallTimeNDateDataDelegate?
    var buttonIndex: String = ""
    

    var fullTime: [String] = ["", "", "", "", ""]
    var callTime: String = ""
    var startDate: String = ""
    
    // 현재 년도 가져오기
    var formatter_year = DateFormatter()
    var formatter_month = DateFormatter()
    var formatter_date = DateFormatter()
    var current_year_Int: Int = 0
    var current_month_Int: Int = 0
    var current_date_Int: Int = 0

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        variableSetting()
        setUI()
        
    }
    func setUI() {
        self.view.layer.cornerRadius = 30
        self.view.layer.masksToBounds = true
        
        datePicker.minimumDate = Date()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(), .large()
            ]
            presentationController.preferredCornerRadius = 30
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            // grabber 속성 추가
            presentationController.prefersGrabberVisible = true
        }
    }
    func variableSetting() {
        formatter_year.dateFormat = "yyyy"
        formatter_month.dateFormat = "MM"
        formatter_date.dateFormat = "dd"
        current_year_Int = Int(formatter_year.string(from: Date()))!
        current_month_Int = Int(formatter_month.string(from: Date()))!
        current_date_Int = Int(formatter_date.string(from: Date()))!
    }

    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 a hh시 mm분"
        callTime = formatter.string(from: datePicker.date)
        
        self.delegate?.sendCallTimeNDateData(data: buttonIndex + callTime)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol SendCallTimeNDateDataDelegate {
    func sendCallTimeNDateData(data: String)
}

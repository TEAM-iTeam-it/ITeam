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
    
    var year: [String] = []
    var month: [String] = []
    var date: [String] = []
    var morningOrAfternoon: [String] = ["오전", "오후"]
    var time: [String] = []
    var minute: [String] = []
    
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
    var selectedMonth: Int = 0 {
        willSet {
            setPickerMonthIfCurrentYear()
        }
    }
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
        
        
        variableSetting()
        setPicker()
        setUI()
        setPickerMonthIfCurrentYear()
        
        picker.selectRow(1, inComponent: 2, animated: true)
        picker.selectRow(1, inComponent: 3, animated: true)
        
        fullTime[0] = "\(current_month_Int)월"
        fullTime[1] = "\(current_date_Int)일"
        fullTime[2] = "오후"
        fullTime[3] = "2시"
        fullTime[4] = ""
        
    }
    func setUI() {
        self.view.layer.cornerRadius = 30
        self.view.layer.masksToBounds = true
    }
    func variableSetting() {
        formatter_year.dateFormat = "yyyy"
        formatter_month.dateFormat = "MM"
        formatter_date.dateFormat = "dd"
        current_year_Int = Int(formatter_year.string(from: Date()))!
        current_month_Int = Int(formatter_month.string(from: Date()))!
        current_date_Int = Int(formatter_date.string(from: Date()))!
        
        
    }
    // 피커 세팅
    func setPicker() {
        
        // 뷰 세팅
        title = "프로젝트 "
        
        var pickerYearSelectedRow: Int = 0
        
        for i in current_year_Int-10...current_year_Int {
            year.append("\(String(i))년")
        }
        for i in 1...current_month_Int {
            month.append("\(String(i))월")
        }
        for i in 1...31 {
            date.append("\(String(i))일")
        }
        for i in 1...12 {
            time.append("\(String(i))시")
        }
        for i in 0...59 {
            minute.append("\(String(i))분")
        }
        pickerYearSelectedRow = year.count-1
        
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(), .large()
            ]
            presentationController.preferredCornerRadius = 30
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = false
            // grabber 속성 추가
            presentationController.prefersGrabberVisible = true
        }
        
        picker.selectRow(pickerYearSelectedRow, inComponent: 0, animated: true)

    }
    
    // 이번 달 이후만 띄워주고 월에 따라 마지막 날짜로 로드
    func setPickerMonthIfCurrentYear() {
        month.removeAll()
        date.removeAll()
        var dateString = ""
        
        // String -> Date()
        if fullTime[0] != "" {
            dateString = "\(current_year_Int)년 \(fullTime[0])월"
        }
        else {
            dateString = "\(current_year_Int)년 \(current_month_Int)월"
        }
        print(dateString)
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy년 MM월"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let monthYearDate: Date = dateFormatter.date(from: dateString)!
        
        // 이번 년도 선택한 월의 마지막 날짜
        let endDate: Date = monthYearDate.endOfMonth()

        // Date -> String -> Int
        let dateFormatterForEndDate = DateFormatter()
        dateFormatterForEndDate.dateFormat = "dd"
        let endDateInt: Int = Int(dateFormatterForEndDate.string(from: endDate))!
        
        
        for i in current_month_Int...12 {
            month.append("\(String(i))월")
        }
        
        for i in current_date_Int...endDateInt {
            date.append("\(String(i))일")
        }
        picker.reloadAllComponents()
    }

    
    @IBAction func saveBtn(_ sender: UIButton) {
       
        callTime = buttonIndex
        for i in 0..<fullTime.count {
            if i == 0 {
                callTime += "\(fullTime[i])"
            }
            else {
                callTime += " \(fullTime[i])"
            }
        }
        self.delegate?.sendCallTimeNDateData(data: callTime)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CallDateNTimeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return month[row]
        }
        else if component == 1 {
            return date[row]
        }
        else if component == 2 {
            return morningOrAfternoon[row]
        }
        else if component == 3 {
            return time[row]
        }
        else {
            return minute[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return month.count
        }
        else if component == 1 {
            return date.count
        }
        else if component == 2 {
            return morningOrAfternoon.count
        }
        else if component == 3 {
            return time.count
        }
        else if component == 4 {
            return minute.count
        }
        else {
            return 20
        }
    }
 
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
//            fullTime[0] = year[row]
//            let year = year[row].replacingOccurrences(of: "년", with: "")
//            selectedYear = Int(year)!
            fullTime[0] = month[row]
        }
        else if component == 1 {
            fullTime[1] = date[row]
        }
        else if component == 2 {
            fullTime[2] = morningOrAfternoon[row]
        }
        else if component == 3 {
            fullTime[3] = time[row]
        }
        else if component == 4 {
            fullTime[4] = minute[row]
        }
    }
    
}

protocol SendCallTimeNDateDataDelegate {
    func sendCallTimeNDateData(data: String)
}

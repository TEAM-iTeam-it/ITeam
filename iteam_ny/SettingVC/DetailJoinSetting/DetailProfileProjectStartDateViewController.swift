//
//  DetailProfileProjectStartDateViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/16.
//

import UIKit

class DetailProfileProjectStartDateViewController: UIViewController {

    var delegate : SendDateDataDelegate?
    var startOREnd: String = ""
    
    var day: [String] = []
    var morningOrAfternoon: [String] = []
    var time: [String] = []
    var fullTime: [String] = ["", "", ""]
    var callTime: String = ""
    var startDate: String = ""
    
    // 현재 년도 가져오기
    var formatter_year = DateFormatter()
    var formatter_month = DateFormatter()
    var current_year_Int: Int = 0
    var current_month_Int: Int = 0
    var selectedYear: Int = 0 {
        willSet(newValue) {
            if newValue == current_year_Int {
                setPickerMonthIfCurrentYear()
            }
            else {
                setPickerMonthNotCurrentYear()
            }
        }
    }
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter_year.dateFormat = "yyyy"
        formatter_month.dateFormat = "MM"
        current_year_Int = Int(formatter_year.string(from: Date()))!
        current_month_Int = Int(formatter_month.string(from: Date()))!
        
        setPicker()
    }
    
    // 피커 세팅
    func setPicker() {
        
        // 뷰 세팅
        title = "프로젝트 "
        
        print(current_year_Int)
        print(current_month_Int)
        var pickerYearSelectedRow: Int = 0
        
        
        if startOREnd == "start" {
            for i in current_year_Int-10...current_year_Int {
                day.append(String(i))
            }
            for i in 1...current_month_Int {
                morningOrAfternoon.append(String(i))
            }
            pickerYearSelectedRow = day.count-1
        }
        else {
            // 시작 날짜를 선택하지 않았으면 그대로
            if startDate == "" {
                for i in current_year_Int-10...current_year_Int {
                    day.append(String(i))
                }
                for i in 1...current_month_Int {
                    morningOrAfternoon.append(String(i))
                }
                pickerYearSelectedRow = day.count-1
            }
            // 시작 날짜가 정해졌으면
            else {
                var startDateArr = startDate.components(separatedBy: " ")
                startDateArr[0] = startDateArr[0].replacingOccurrences(of: "년", with: "")
                startDateArr[1] = startDateArr[1].replacingOccurrences(of: "월", with: "")
                print("startDateArr year= \(startDateArr[0])")
                print("startDateArr month= \(startDateArr[1])")
                for i in Int(startDateArr[0])!...current_year_Int {
                    day.append(String(i))
                }
                for i in Int(startDateArr[1])!...12 {
                    morningOrAfternoon.append(String(i))
                }
                pickerYearSelectedRow = 0
                
            }
        }
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
    
    // 현재 년도일 때 월 바꿔주기
    func setPickerMonthIfCurrentYear() {
        morningOrAfternoon.removeAll()
        for i in 1...current_month_Int {
            morningOrAfternoon.append(String(i))
        }
        picker.reloadAllComponents()
    }
    func setPickerMonthNotCurrentYear() {
        morningOrAfternoon.removeAll()
        for i in 1...12 {
            morningOrAfternoon.append(String(i))
        }
        picker.reloadAllComponents()
    }
    
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        if startOREnd == "start" {
            
        }
        // 년도를 선택하지 않았을 때
        if fullTime[0].isEmpty {
            if startOREnd == "start" {
                // 최근 년도로
                callTime += "\(day[day.count-1])년 "
            }
            else {
                // 시작 날짜로
                callTime += "\(day[0])년 "
            }
        }
        // 년도를 선택했을 때
        else {
            callTime += "\(fullTime[0])년 "
        }
        
        // 월을 선택하지 않았을 때
        if fullTime[1].isEmpty {
            callTime += "\(morningOrAfternoon[0])월 "
        }
        
        // 월을 선택했을 때
        else {
            callTime += "\(fullTime[1])월 "
        }
       
        if startOREnd == "start" {
            self.delegate?.sendStartData(data: callTime)
        }
        else {
            self.delegate?.sendEndDate(data: callTime)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
extension DetailProfileProjectStartDateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        let itemLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        if component == 0 {
            itemLabel.text = day[row]
        }
        else if component == 1 {
            itemLabel.text = morningOrAfternoon[row]
        }
        
        itemLabel.textAlignment = .center
        itemLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)

        view.addSubview(itemLabel)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return day.count
        }
        else if component == 1 {
            return morningOrAfternoon.count
        }
        else {
            return 20
        }
    }
 
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            fullTime[0] = day[row]
            selectedYear = Int(day[row])!
            
        }
        else if component == 1 {
            fullTime[1] = morningOrAfternoon[row]
        }
    }
}
protocol SendDateDataDelegate {
    func sendStartData(data: String)
    func sendEndDate(data: String)
}

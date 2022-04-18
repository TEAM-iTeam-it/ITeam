//
//  CallTimePickerViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/05.
//

import UIKit

class CallTimePickerViewController: UIViewController {

    var delegate : SendCallTimeDataDelegate?
    
    @IBOutlet weak var callTimePickerView: UIPickerView!
    
    var day: [String] = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    var morningOrAfternoon: [String] = ["오전", "오후"]
    var time: [String] = []
    var minute: [String] = []
    var fullTime: [String] = ["", "", "", ""]
    var callTime: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "통화 선호 시간"
        for i in 1...12 {
            time.append("\(String(i))시")
        }
        for i in stride(from: 0, to: 51, by: 10) {
            minute.append("\(String(i))분")
        }
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        
        // 피커 초기에 오후로 세팅
        callTimePickerView.selectRow(1, inComponent: 1, animated: true)
        
    }
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        callTime = ""
        if fullTime[0].isEmpty {
            fullTime[0] = "월요일"
        }
        if fullTime[1].isEmpty {
            fullTime[1] = "오후"
        }
        if fullTime[2].isEmpty {
            fullTime[2] = "1시"
        }
        if fullTime[3].isEmpty {
            fullTime[3] = "0분"
        }
        callTime += "\(fullTime[0]) "
        callTime += "\(fullTime[1]) "
        callTime += "\(fullTime[2]) "
        callTime += "\(fullTime[3])"
       
        
        self.delegate?.sendCallTimeData(data: callTime)
        print(callTime)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension CallTimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return day[row]
        }
        else if component == 1 {
            return morningOrAfternoon[row]
        }
        else if component == 2 {
            return time[row]
        }
        else {
            return minute[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return day.count
        }
        else if component == 1 {
            return morningOrAfternoon.count
        }
        else if component == 2 {
            return time.count
        }
        else if component == 3 {
            return minute.count
        }
        else {
            return 20
        }
    }
 
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            print(day[row])
            fullTime[0] = day[row]
        }
        else if component == 1 {
            print(morningOrAfternoon[row])
            fullTime[1] = morningOrAfternoon[row]
        }
        else if component == 2 {
            print(time[row])
            fullTime[2] = time[row]
        }
        else if component == 3 {
            print(minute[row])
            fullTime[3] = minute[row]
        }
    }
    
    
}

protocol SendCallTimeDataDelegate {
    func sendCallTimeData(data: String)
}


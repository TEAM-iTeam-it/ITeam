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
    var fullTime: [String] = ["", "", ""]
    var callTime: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "통화 선호 시간"
        for i in 1...12 {
            time.append(String(i))
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
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        callTime += "\(fullTime[0]) "
        callTime += "\(fullTime[1]) "
        callTime += "\(fullTime[2])시"
       
        
        self.delegate?.sendCallTimeData(data: callTime)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension CallTimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
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
        else if component == 2 {
            itemLabel.text = time[row]
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
        else if component == 2 {
            return time.count
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
    }
    
    
}

protocol SendCallTimeDataDelegate {
    func sendCallTimeData(data: String)
}


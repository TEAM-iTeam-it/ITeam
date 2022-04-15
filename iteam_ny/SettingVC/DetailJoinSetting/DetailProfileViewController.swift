//
//  DetailProfileViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/19.
//

import UIKit

class DetailProfileViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var callTimeBtn: UIButton!
    @IBOutlet weak var portfoliolinkTF: UITextField!
    @IBOutlet weak var callLinkTF: UITextField!
    @IBOutlet weak var successBtn: UIButton!
    @IBOutlet weak var exTableView: DetailProfileExTableView!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableviewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var intersetContraintTop: NSLayoutConstraint!
    @IBOutlet weak var interestLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var toolNLangConstraintTop: NSLayoutConstraint!
    var projects: [ProjectEx] = []
    
    @IBAction func goBackToPopupBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        settingViewDesign()
    
        exTableView.reloadData()
        tableviewHeight.constant = exTableView.intrinsicContentSize.height
        if projects.count >= 1 {
            tableviewConstraintTop.constant = 15
        }
        else {
            tableviewConstraintTop.constant = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewHeight.constant = 0
        
        interestLabel.text = ""
        intersetContraintTop.constant = 0
        interestLabelHeight.constant = 0

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func settingViewDesign() {
        successBtn.layer.cornerRadius = 8
        
        // 통화 선호 시간, 포트폴리오, 연락 링크 텍스트필드 디자인 세팅
        callTimeBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        callTimeBtn.layer.borderWidth = 0.5
        callTimeBtn.layer.cornerRadius = 8
        
        portfoliolinkTF.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        portfoliolinkTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        portfoliolinkTF.layer.borderWidth = 0.5
        portfoliolinkTF.layer.cornerRadius = 8
        
        callLinkTF.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        callLinkTF.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        callLinkTF.layer.borderWidth = 0.5
        callLinkTF.layer.cornerRadius = 8
        
    }
    @IBAction func addProjectExAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let projectExVC = thisStoryboard.instantiateViewController(withIdentifier: "projectExVC") as? DetailProfileProjectExViewController
        projectExVC?.modalPresentationStyle = .fullScreen
        projectExVC?.delegate = self
        present(projectExVC!, animated: true, completion: nil)
    }
    
    
}
extension DetailProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailProfileExCell", for: indexPath) as! DetailProfileProjectTableViewCell
        
        
        cell.cellView.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        cell.cellView.layer.borderWidth = 0.5
        cell.cellView.layer.cornerRadius = 8
        cell.cellView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        
        // 셀 데이터 세팅
        cell.dateLabel.text = projects[indexPath.section].date
        cell.detailLabel.text = projects[indexPath.section].details
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
}
class ProjectEx {
    var date: String
    var details: String
    
    init (date: String, details: String) {
        self.date = date
        self.details = details
    }
}
extension DetailProfileViewController: SendProjectExDelegate {
    func sendProjectExData(data: [String]) {
     
        let startDate: Date = StringToDateType(string: data[0])!
        let startDateString: String = dateToStringType(date: startDate)
        let endDate: Date = StringToDateType(string: data[1])!
        let endDateString: String = dateToStringType(date: endDate)
        
        let calendar = Calendar.current
        let dateGap = calendar.dateComponents([.year,.month], from: startDate, to: endDate)

        var dateGapString: String = ""
        if case let (y?, m?) = (dateGap.year , dateGap.month) {
            if y == 0 {
                dateGapString = "\(m)개월"
            }
            else {
                dateGapString = "\(y)년 \(m)개월"
            }
        }
        
        var fullDateString: String = ""
        fullDateString.append(startDateString)
        fullDateString.append("(\(dateGapString))")
        
        var project = ProjectEx(date: fullDateString, details: data[2])

        projects.append(project)
        exTableView.reloadData()
        
    }
    // "yyyy년 MM월" -> Date()
    func StringToDateType(string : String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.date(from: string)
    }
    // Date() -> "yyyy.MM"
    func dateToStringType(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter.string(from: date)
    }
  
}
extension DetailProfileViewController: SendDataDelegate {
    func sendData(data: [String]) {
        var interest: String = ""
        for i in 0..<data.count {
            if data[i] == data.last {
                interest += "\(data[i])"
            }
            else {
                interest += "\(data[i]), "
            }
            
        }
        self.interestLabel.text = interest
        if interest != "" {
            intersetContraintTop.constant = 15
            interestLabelHeight.constant = 18
        }
        else {
            intersetContraintTop.constant = 0
            interestLabelHeight.constant = 0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

           if segue.identifier == "show" {

               let DetailProfileInterestViewController: DetailProfileInterestViewController = segue.destination as! DetailProfileInterestViewController

               DetailProfileInterestViewController.delegate = self

           }

       }
}

//
//  DetailProfileViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/19.
//

import UIKit

class DetailProfileViewController: UIViewController  {


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
    @IBOutlet weak var projectExAddBtn: UIButton!
    @IBOutlet weak var projectExAddBtn2: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var projects: [ProjectEx] = []
    
    var fillCount: Int = 0 {
        willSet(newValue) {
           // if newValue ==
        }
    }
    
    
    @IBAction func goBackToPopupBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        settingViewDesign()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        firstSettingUI()
    }
    func settingViewDesign() {
        
        
        exTableView.reloadData()
        
        // 테이블뷰 높이 조정
        tableviewHeight.constant = exTableView.intrinsicContentSize.height
        if projects.count >= 1 {
            tableviewConstraintTop.constant = 15
            projectExAddBtn.isHidden = true
            projectExAddBtn2.isHidden = false
            
        }
        else {
            tableviewConstraintTop.constant = 0
            projectExAddBtn.isHidden = false
            projectExAddBtn2.isHidden = true
        }
        
    }
    
    func firstSettingUI() {
        
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
        
        tableviewHeight.constant = 0
        
        interestLabel.text = ""
        intersetContraintTop.constant = 0
        interestLabelHeight.constant = 0
        
        projectExAddBtn.isHidden = false
        projectExAddBtn2.isHidden = true
        
        // 완료버튼 속성
        successBtn.layer.cornerRadius = 8
        successBtn.setTitleColor(.white, for: .normal)
        successBtn.setTitleColor(.white, for: .disabled)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    
    
    // 프로젝트 추가 버튼
    @IBAction func addProjectExAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let projectExVC = thisStoryboard.instantiateViewController(withIdentifier: "projectExVC") as? DetailProfileProjectExViewController
        projectExVC?.modalPresentationStyle = .fullScreen
        projectExVC?.delegate = self
        present(projectExVC!, animated: true, completion: nil)
    }
    
    
    
}

// 텍스트 필드가 키보드에 가려지지 않도록 하기 위해 스크롤 내릶
extension DetailProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView.scroll(to: .bottom)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scroll(to: .bottom250)
    }
}



// 프로젝트 경험 테이블뷰
extension DetailProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 한 항목을 섹션으로 지정, footer로 간경을 줌
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

// 프로젝트 경험 테이블뷰에 사용될 데이터 구조 선언
class ProjectEx {
    var date: String
    var details: String
    
    init (date: String, details: String) {
        self.date = date
        self.details = details
    }
}

// 프로젝트 경험 받아오기
extension DetailProfileViewController: SendProjectExDelegate {
    func sendProjectExData(data: [String]) {
     
        // 받아온 날짜 계산
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

// 관심사 데이터 받아오기
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

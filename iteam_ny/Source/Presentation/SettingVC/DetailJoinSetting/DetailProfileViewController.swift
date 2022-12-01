//
//  DetailProfileViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/11/19.
//

import UIKit
import MaterialComponents.MaterialBottomSheet
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailProfileViewController: UIViewController  {


    @IBOutlet weak var callTimeBtn: UIButton!
    @IBOutlet weak var portfoliolinkTF: UITextField!
    @IBOutlet weak var callLinkTF: UITextField!
    @IBOutlet weak var successBtn: UIButton!
    @IBOutlet weak var exTableView: DetailProfileExTableView!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var toolNLangLabel: UILabel!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableviewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var intersetContraintTop: NSLayoutConstraint!
    @IBOutlet weak var interestLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var toolNLangConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var toolNLangLabelHeight: NSLayoutConstraint!
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
    // Firebase Realtime Database 루트
    var ref: DatabaseReference!
    
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
        
        toolNLangConstraintTop.constant = 0
        toolNLangLabelHeight.constant = 0
        
        projectExAddBtn.isHidden = false
        projectExAddBtn2.isHidden = true
        
        // 완료버튼 속성
        successBtn.layer.cornerRadius = 8
        successBtn.setTitleColor(.white, for: .normal)
        successBtn.setTitleColor(.white, for: .disabled)
        
        
        // texfield 사용 중 스크롤시 키보드 내리기 위함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        

    }
    
    
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        saveDataAction()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC = storyboard.instantiateInitialViewController() as? TabarController  {
           
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    func saveDataAction() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        var calltimeString: String = ""
        let toolNLanguage: [String: String] = [ "toolNLanguage": toolNLangLabel.text ?? ""]
        let interest: [String: String] = [ "interest": interestLabel.text ?? ""]
        calltimeString = callTimeBtn.titleLabel?.text ?? ""
        if !calltimeString.contains("분") {
            calltimeString += " 00분"
        }
        let calltime: [String: String] = [ "calltime": calltimeString]
        let portfolioLink: [String: String] = [ "portfolioLink": portfoliolinkTF.text ?? ""]
        let contactLink: [String: String] = [ "contactLink": callLinkTF.text ?? ""]
        let currentTeam: [String: String] = [ "currentTeam": ""]
        
        
        ref = Database.database().reference().child("user").child(Auth.auth().currentUser!.uid).child("userProfile")
        // 데이터 추가
        ref.child("portfolio").updateChildValues(toolNLanguage)
        ref.child("portfolio").updateChildValues(interest)
        ref.child("portfolio").updateChildValues(calltime)
        ref.child("portfolio").updateChildValues(portfolioLink)
        ref.child("portfolio").updateChildValues(contactLink)
        ref.child("portfolio").updateChildValues(toolNLanguage)
        
        let refMAin = Database.database().reference().child("user").child(Auth.auth().currentUser!.uid)
        refMAin.updateChildValues(currentTeam)
        
        for i in 0..<projects.count {
            let exDetail: [String: String] = [ "exDetail": projects[i].details]
            let date: [String: String] = [ "date": projects[i].date]
            ref.child("portfolio").child("ex\(i)").updateChildValues(exDetail)
            ref.child("portfolio").child("ex\(i)").updateChildValues(date)
        }
        
    }
    // 프로젝트 추가 버튼
    @IBAction func addProjectExAction(_ sender: Any) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let projectExVC = thisStoryboard.instantiateViewController(withIdentifier: "projectExVC") as? DetailProfileProjectExViewController
        projectExVC?.modalPresentationStyle = .fullScreen
        projectExVC?.delegate = self
        present(projectExVC!, animated: true, completion: nil)
    }
    @IBAction func addToolNLangAction(_ sender: UIButton) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
        let toolNLangVC = thisStoryboard.instantiateViewController(withIdentifier: "toolNLangVC") as? DetailProfileToolNLanguageViewController
        toolNLangVC?.modalPresentationStyle = .fullScreen
        toolNLangVC?.delegate = self
        present(toolNLangVC!, animated: true, completion: nil)
    }
    @IBAction func callTimeSettingAction(_ sender: UIButton) {
        let thisStoryboard: UIStoryboard = UIStoryboard(name: "JoinPages", bundle: nil)
            
        // 바텀 시트로 쓰일 뷰컨트롤러 생성
        let callTimeVC = thisStoryboard.instantiateViewController(withIdentifier: "callTimeVC") as? CallTimePickerViewController
        
        callTimeVC?.delegate = self
        
        // MDC 바텀 시트로 설정
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: callTimeVC!)
        bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 320
        
        
        // 보여주기
        present(bottomSheet, animated: true, completion: nil)
    }
    
    
    
}

// 텍스트 필드가 키보드에 가려지지 않도록 하기 위해 스크롤 내릶
extension DetailProfileViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    // [Keyboard setting] return시 제거
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView.scroll(to: .bottom)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scroll(to: .bottom250)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.scroll(to: .bottom)
    }
    
    @objc func TapMethod(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.view.endEditing(true)
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

// 통화 시간 받아오기
extension DetailProfileViewController: SendCallTimeDataDelegate {
    func sendCallTimeData(data: String) {
        let selectedTime = data.replacingOccurrences(of: "00분", with: "")
        self.callTimeBtn.setTitle(selectedTime, for: .normal)
        self.callTimeBtn.setTitleColor(UIColor.black, for: .normal)
    }
    
    
}

// 툴과 언어 받아오기
extension DetailProfileViewController: SendToolNLangDataDelegate {
    func sendToolNLangData(data: String) {
        self.toolNLangLabel.text = data
        
        if data != "" {
            toolNLangConstraintTop.constant = 15
            toolNLangLabelHeight.constant = 18
        }
        else {
            toolNLangConstraintTop.constant = 0
            toolNLangLabelHeight.constant = 0
        }
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

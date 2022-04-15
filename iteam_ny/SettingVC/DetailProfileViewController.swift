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
    var projects: [ProjectEx] = []
    
    @IBAction func goBackToPopupBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        settingViewDesign()
        
        let project1 = ProjectEx(date: "2021.06(2개월)", details: "환경을 위한 패션 앱 프로젝트")
        let project2 = ProjectEx(date: "2021.12(3개월)", details: "제로웨이스트 해커톤 참가")
        projects.append(project1)
        projects.append(project2)
        projects.append(project1)
        projects.append(project2)
        projects.append(project1)
        projects.append(project2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

           if segue.identifier == "show" {

               let DetailProfileInterestViewController: DetailProfileInterestViewController = segue.destination as! DetailProfileInterestViewController

               DetailProfileInterestViewController.delegate = self

           }

       }
}

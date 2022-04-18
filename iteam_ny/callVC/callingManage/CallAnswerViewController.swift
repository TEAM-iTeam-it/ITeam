//
//  CallAnswerViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit
import FirebaseAuth

class CallAnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var conditionChangeBtn: UIButton!
    var personList: [Person] = []
    @IBOutlet weak var answerListTableView: UITableView!
    var toGoSegue: String = "대기"
    
    // [삭제 예정] 시연을 위한 변수
    var counter:Int = 0
    var name: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        counter = 0
        name = "speaker"
        
        personList.append(Person(nickname: "레인", position: "백엔드 개발•포트폴리오/해커톤/창업", callStm: "요청됨", profileImg: "imgUser4"))
        personList.append(Person(nickname: "스카이", position: "Android 개발•포트폴리오/해커톤/창업", callStm: "요청수락", profileImg: "imgUser5"))
        personList.append(Person(nickname: "에일리", position: "Android 개발•공모전/해커톤/기타", callStm: "이전통화", profileImg: "imgUser10"))
        
        //let favorite = UIAction(title: "요청내역", image: UIImage(systemName: "heart"), handler: { _ in print("즐겨찾기") })
        let requestList = UIAction(title: "요청됨", handler: { _ in print("요청내역") })
        let denied = UIAction(title: "요청수락", handler: { _ in print("거절함") })
        let canceled = UIAction(title: "통화", handler: { _ in print("취소됨") })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })

        conditionChangeBtn.menu = UIMenu(title: "상태를 선택해주세요", image: UIImage(systemName: "heart.fill"), identifier: nil, options: .displayInline, children: [requestList, denied, canceled, cancel])
        // Do any additional setup after loading the view.
    }

    // 삭제할 코드 - 유닛 테스트
    @IBAction func testSignout(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("로그아웃됨. 앱이 종료됩니다")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        sleep(2)
        exit(0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AnswerPersonCell", for: indexPath) as! AnswerTableViewCell
        cell.nicknameLabel.text = personList[indexPath.row].nickname
        // 같은 학교 처리
        if cell.nicknameLabel.text == "레인" {
            cell.sameSchoolLabel.layer.borderWidth = 0.5
            cell.sameSchoolLabel.layer.borderColor = UIColor(named: "purple_184")?.cgColor
            cell.sameSchoolLabel.textColor = UIColor(named: "purple_184")
            
            cell.sameSchoolLabel.layer.cornerRadius = cell.sameSchoolLabel.frame.height/2
            cell.sameSchoolLabel.text = "같은 학교"
            cell.sameSchoolLabel.isHidden = false
            
        }
        else {
            cell.sameSchoolLabel.isHidden = true
        }
        cell.positionLabel.text = personList[indexPath.row].position
     //   cell.callStateBtn.titleLabel?.font = .systemFont(ofSize: 13)
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        cell.profileImg.image = UIImage(named: "\(personList[indexPath.row].profileImg)")
        cell.selectionStyle = .none
        // 버튼 색상 처리
        if personList[indexPath.row].callStm == "거절함" || personList[indexPath.row].callStm == "취소됨" {
            cell.callStateBtn.backgroundColor = .systemGray6
            cell.callStateBtn.setTitleColor(.lightGray, for: .normal)
            
            if personList[indexPath.row].callStm == "취소됨" {
                cell.nicknameLabel.textColor = .systemGray5
                cell.positionLabel.textColor = .systemGray5
                cell.profileImg.image?.withRenderingMode(.alwaysTemplate)
                cell.profileImg.tintColor = UIColor(named: "gray_light2")
            }
        }
        else if personList[indexPath.row].callStm == "요청수락" {
            cell.callStateBtn.layer.borderWidth = 0
            cell.callStateBtn.backgroundColor = UIColor(named: "green_dark")
            cell.callStateBtn.setTitleColor(.white, for: .normal)
        }
        else if personList[indexPath.row].callStm == "이전통화" {
            cell.callStateBtn.isHidden = true
        }
        else if personList[indexPath.row].callStm == "요청됨" {
            cell.callStateBtn.layer.borderWidth = 0.5
            cell.callStateBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
            cell.callStateBtn.setTitleColor(UIColor(named: "gray_51"), for: .normal)
            cell.callStateBtn.backgroundColor = nil
        }
        else if personList[indexPath.row].callStm == "통화대기" {
            cell.callStateBtn.isHidden = false
            cell.callStateBtn.setTitle("통화", for: .normal)
            cell.callStateBtn.setTitleColor(.white, for: .normal)
            cell.callStateBtn.backgroundColor = UIColor(named: "purple_184")
        }
        else if personList[indexPath.row].callStm == "통화시작" {
            cell.callStateBtn.isHidden = false
            cell.callStateBtn.setTitle("통화", for: .normal)
            cell.callStateBtn.setTitleColor(.white, for: .normal)
            cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
            cell.callStateBtn.translatesAutoresizingMaskIntoConstraints = false
            
            // 버튼 그라디언트
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = cell.callStateBtn.bounds
            gradientLayer.colors = [UIColor(named: "purple_184")?.cgColor, UIColor(named: "green_151")?.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = cell.callStateBtn.bounds
            cell.callStateBtn.layer.insertSublayer(gradientLayer, at: 0)
            cell.callStateBtn.layer.masksToBounds = true
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if personList[indexPath.row].callStm == "요청됨" {
            performSegue(withIdentifier: "HistoryVC", sender: indexPath.row)
        }
        else if personList[indexPath.row].callStm == "통화대기" {
            performSegue(withIdentifier: "waitingVC", sender: indexPath.row)
        }
        else if personList[indexPath.row].callStm == "통화시작" {
            performSegue(withIdentifier: "startVC", sender: indexPath.row)
        }
        return indexPath
    }
    
    // [삭제 예정] 시연을 위한 nextbutton
    @IBAction func nextBtn(_ sender: UIButton) {
        if counter == 0 {
            personList[0].callStm = "통화대기"
            toGoSegue = "통화대기"
            print(toGoSegue)
            print(counter)
            counter += 1
        }
        else if counter == 1{
            personList[0].callStm = "통화시작"
            toGoSegue = "통화시작"
            print(toGoSegue)
            print(counter)
        }
        print(personList[0].callStm)
        print(personList[0].callStm)
        answerListTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingVC" {
            if let destination = segue.destination as? ChannelWaitingViewController {
               // let cell = sender as! AnswerTableViewCell
                destination.nickname = personList[(sender as? Int)!].nickname
                // var position = personList[(sender as? Int)!].position.split(separator: "•")
                var position = personList[(sender as? Int)!].position
                destination.position = String(position)
                destination.profile = personList[(sender as? Int)!].profileImg
            }
        }
        else if segue.identifier == "startVC" {
            if let destination = segue.destination as? ChannelViewController {
               // let cell = sender as! AnswerTableViewCell
                destination.nickname = personList[(sender as? Int)!].nickname
                var position = personList[(sender as? Int)!].position
                destination.position = String(position)
                destination.name = name
                destination.profile = personList[(sender as? Int)!].profileImg
                
            }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

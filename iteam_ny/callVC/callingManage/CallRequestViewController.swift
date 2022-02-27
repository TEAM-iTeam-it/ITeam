//
//  CallRequestViewController.swift
//  ITeam_basic
//
//  Created by 김하늘 on 2021/12/03.
//

import UIKit

class CallRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var conditionChangeBtn: UIButton!
    var personList: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        personList.append(Person(nickname: "B", position: "iOS 개발•해커톤/포트폴리오/창업", callStm: "요청됨", profileImg: ""))
        personList.append(Person(nickname: "B 팀", position: "포트폴리오•디자이너 외 1", callStm: "요청됨", profileImg: ""))
        personList.append(Person(nickname: "F", position: "게임 기획자•포트폴리오/해커톤", callStm: "거절됨", profileImg: ""))
        personList.append(Person(nickname: "F", position: "게임 기획자•포트폴리오/해커톤", callStm: "취소됨", profileImg: ""))

        
        // Do any additional setup after loading the view.
        let requested = UIAction(title: "요청됨", handler: { _ in print("요청됨") })
        let denied = UIAction(title: "거절됨", handler: { _ in print("거절됨") })
        let canceled = UIAction(title: "취소됨", handler: { _ in print("취소됨") })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })

        conditionChangeBtn.menu = UIMenu(title: "상태를 선택해주세요", image: UIImage(systemName: "heart.fill"), identifier: nil, options: .displayInline, children: [requested, denied, canceled, cancel])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "requestPersonCell", for: indexPath) as! RequestTableViewCell
        
        
        cell.nicknameLabel.text = personList[indexPath.row].nickname
        cell.positionLabel.text = personList[indexPath.row].position
        cell.callStateBtn.titleLabel?.font = .systemFont(ofSize: 13)
        cell.callStateBtn.layer.cornerRadius = cell.callStateBtn.frame.height/2
        cell.callStateBtn.setTitle("\(personList[indexPath.row].callStm)", for: .normal)
        if personList[indexPath.row].callStm == "거절됨" || personList[indexPath.row].callStm == "취소됨" {
            cell.callStateBtn.backgroundColor = .systemGray6
            cell.callStateBtn.setTitleColor(.lightGray, for: .normal)
            
            if personList[indexPath.row].callStm == "취소됨" {
                cell.nicknameLabel.textColor = .systemGray5
                cell.positionLabel.textColor = .systemGray5
                cell.profileImg.image?.withRenderingMode(.alwaysTemplate)
                cell.profileImg.tintColor = UIColor(named: "gray_light2")
            }
        }
        cell.profileImg.image = UIImage(systemName: "person.crop.circle.fill")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 회색에서 다시 하얗게 변하도록 설정
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "waitingVC" {
            if let destination = segue.destination as? ChannelWaitingViewController {
                    let cell = sender as! RequestTableViewCell
                destination.nickname = cell.nicknameLabel.text!
                if cell.nicknameLabel.text!.contains("팀") {
                    destination.position = cell.positionLabel.text!
                }
                else {
                    let position = cell.positionLabel.text!.split(separator: "•")
                    destination.position = String(position[0])
                }
                
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

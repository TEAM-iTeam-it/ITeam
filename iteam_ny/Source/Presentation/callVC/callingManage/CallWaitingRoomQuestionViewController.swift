//
//  CallWaitingRoomQuestionViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/05/04.
//

import UIKit

class CallWaitingRoomQuestionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var question: [String] = []
    var fromPerson: String = ""
    var toPerson: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        view.layer.cornerRadius = 16
        titleLabel.text = "\(fromPerson)님이 \(toPerson)님에게"
    }
}
extension CallWaitingRoomQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waitingRoomQuestionListCell") as! CallWaitingRoomQuestionTableViewCell
        cell.questionLabel.text = question[indexPath.row]
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    
}

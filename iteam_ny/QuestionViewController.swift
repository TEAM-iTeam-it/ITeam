//
//  QuestionViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/12/06.
//

import UIKit

class QuestionViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    
    let asklist = ["프로젝트를 하는 목적이 무엇인가요?", "하고 싶은 주제가 있으신가요?","주로 작업하는 시간대가 어떻게 되시나요?","병행하고 있는 활동이 있으신가요?","주 사용 툴 혹은 언어는 무엇인가요?","이번 프로젝트에서 맡고 싶은 역할이 있으신가요?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

extension QuestionViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asklist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuesstionCell") as? QuesstionCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        cell.questionLable.text = asklist[index]
        return cell
    }
}

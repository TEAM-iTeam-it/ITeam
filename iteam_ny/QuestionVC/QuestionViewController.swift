//
//  QuestionViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/12/06.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class QuestionViewController: UIViewController{
    
    var IndexN : String = ""
    var ref: DatabaseReference!
    
    @IBAction func ClickfinishBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        
        var arr : [String] = []
        for i in 0...asklist.count-1{
            if asklist[i].isMarked {
                arr.append("\(asklist[i].title)")
            }
        }
        guard let user = Auth.auth().currentUser else {
            return
        }

        var stmtString: String = "요청됨"
        var QuestionString: String = ""
        for i in 0..<arr.count {
            if i == arr.count-1 {
                QuestionString += arr[i]
            }
            else {
                QuestionString += "\(arr[i]), "
            }
        }
        let Question: [String: String] = [ "Question": QuestionString]
        let stmt: [String: String] = ["stmt": stmtString]
        ref = Database.database().reference()
        ref.child("Call").child(IndexN).updateChildValues(Question)
        ref.child("Call").child(IndexN).updateChildValues(stmt)
    }
    @IBOutlet weak var tableView: UITableView!
    
    var asklist = [Todo(title: "프로젝트를 하는 목적이 무엇인가요?", isMarked: false),
                 Todo(title: "하고 싶은 주제가 있으신가요?", isMarked: false),
                 Todo(title: "주로 작업하는 시간대가 어떻게 되시나요?", isMarked: false),
                 Todo(title: "병행하고 있는 활동이 있으신가요?", isMarked: false),
                 Todo(title: "주 사용 툴 혹은 언어는 무엇인가요?", isMarked: false),
                 Todo(title: "이번 프로젝트에서 맡고 싶은 역할이 있으신가요?", isMarked: false)]
    
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
        
        let index = asklist[indexPath.row]
        cell.questionLable.text = index.title
        cell.checkButton.image = index.isMarked == true ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
//        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? QuesstionCell else { return }
        
        var index = asklist[indexPath.row]
        index.isMarked = !index.isMarked
        asklist.remove(at: indexPath.row)
        asklist.insert(index, at:indexPath.row)
        
        cell.checkButton.image = index.isMarked == true ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        
    }
}

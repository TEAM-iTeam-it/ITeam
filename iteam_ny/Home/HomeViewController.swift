//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.dummyUserLsit.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTableViewCell
        let target = User.dummyUserLsit[indexPath.row]
        
        cell.cellName.text = target.name
        cell.cellContents.text = target.content
        cell.cellImage.image = UIImage(systemName: "person.fill")
        //cell.cellImage.image =
        return cell
    }
    
    
}
    
    


//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.register(UINib(nibName: "memberCell", bundle: .main), forCellWithReuseIdentifier: "memberCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 100;
        
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTableViewCell
        let target = User.dummyUserLsit[indexPath.row]
        
        cell.cellName.text = target.name
        cell.cellContents.text = target.content
        cell.cellImage.image = UIImage(systemName: "person.fill")
        //cell.cellImage.image =
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.dummyUserLsit.count
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return User.dummymemverList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let FixedMemberCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FixedMemberCell", for: indexPath) as! FixedMemberCell
        let target = User.dummymemverList[indexPath.row]
        
        FixedMemberCell.memberRoleLable.text = target.content
        FixedMemberCell.membernameLable.text = target.name
        FixedMemberCell.memberImage.image = UIImage(systemName: "person.fill")
               return FixedMemberCell
    }
    
    
}
    
    


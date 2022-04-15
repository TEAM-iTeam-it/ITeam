//
//  DetailProfileToolNLanguageViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/12.
//

import UIKit

class DetailProfileToolNLanguageViewController: UIViewController {

    var toolNLangsIteams: [String] = []
    var searchText: String = ""
    var items: [String] = ["Adobe Photoshop", "Adobe Indesign", "Adobe Illustrator", "3dmax", "swift"]
    
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    

    override func viewWillAppear(_ animated: Bool) {
        toolNLangsIteams = items
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
extension DetailProfileToolNLanguageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolNLangsIteams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allToolNLangCell", for: indexPath) as! DetailProfileAllToolNLangCollectionViewCell
        cell.toolNLangBtn.setTitle(toolNLangsIteams[indexPath.row], for: .normal)
        //cell.toolNLangBtn.titleLabel?.text = toolNLangsIteams[indexPath.row]
        cell.toolNLangBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        cell.toolNLangBtn.layer.borderWidth = 0.5
        cell.toolNLangBtn.layer.cornerRadius = cell.toolNLangBtn.frame.height/2
        // cell.sizeToFit()
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allToolNLangCell", for: indexPath) as? DetailProfileAllToolNLangCollectionViewCell else {
            return .zero
        }
        print("yes")
        cell.toolNLangBtn.titleLabel?.text = toolNLangsIteams[indexPath.row]
        cell.toolNLangBtn.titleLabel!.sizeToFit()
        // cell.sizeToFit()
        let cellWidth = cell.toolNLangBtn.titleLabel!.frame.width + 30

        return CGSize(width: cellWidth, height: 28)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            return sectionInsets
//        }

    
}
extension DetailProfileToolNLanguageViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        var newArr: [String] = []
        
        for i in 0..<toolNLangsIteams.count {
            if toolNLangsIteams[i].contains(searchText) {
                newArr.append(toolNLangsIteams[i])
            }
        }
        toolNLangsIteams = newArr
        searchResultCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        toolNLangsIteams = items
        searchResultCollectionView.reloadData()
        return true
    }
}


//
//  DetailProfileToolNLanguageViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/04/12.
//

import UIKit

class DetailProfileToolNLanguageViewController: UIViewController {

    @IBOutlet weak var addedCollectionView: DetailProfileToolNLangCollectionView!
    @IBOutlet weak var searchResultCollectionView: DetailProfileToolNLangCollectionView!
    @IBOutlet weak var addedCollectionviewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var resultCollectionViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    var addCount: Int = 0
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    var delegate: SendToolNLangDataDelegate?
    
    var toolNLangsIteams: [String] = ["Adobe Photoshop", "Adobe Indesign", "Adobe Illustrator", "3dmax", "swift", "add"]
    var newValueCount: Int = 0
    
    // 리로드를 위한 선택되지 않은 항목들
    var oldValuetoolNLangsIteams: [String] = [] {
        willSet(newValue) {
            print(newValue)
        }
    }
    
    // 선택한 툴과 언어
    var toolNLangsIteamsAdded: [String] = [] {
       //  var newvalueString: String
        willSet(newValue) {
            newValueCount = newValue.count
            if newValue.count > 0 {
                saveBtn.tintColor = UIColor(named: "purple_184")
            }
            else {
                saveBtn.tintColor = UIColor(named: "gray_196")
            }
        }
        didSet(oldValue) {
            // 항목 추가에 따라 height 제어
            // 선택 취소됨
            if oldValue.count > newValueCount {
                addedCollectionviewConstraintHeight.constant -= 30
                
            }
            // 선택됨
            else if oldValue.count < newValueCount {
                addedCollectionviewConstraintHeight.constant += 30
            }
        }
    }
    var searchText: String = ""
    var items: [String] = ["Adobe Photoshop", "Adobe Indesign", "Adobe Illustrator", "3dmax", "swift", "add"]
    
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        toolNLangsIteams = items
        addedCollectionView.reloadData()
        searchResultCollectionView.reloadData()
        
        addedCollectionviewConstraintHeight.constant = addedCollectionView.intrinsicContentSize.height
        

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        addedCollectionviewConstraintHeight.constant = 0
    }
    
    func setUI() {
        searchTextField.addTarget(self, action: #selector(searchAction(textfield:)), for: .editingChanged)
        oldValuetoolNLangsIteams = toolNLangsIteams
    }
    
    // 뒤로가기
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 저장
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        var toolNLangString: String = ""
        for i in 0..<toolNLangsIteamsAdded.count {
            if i != toolNLangsIteamsAdded.count-1 {
                toolNLangString += "\(toolNLangsIteamsAdded[i]), "
            }
            else {
                toolNLangString += "\(toolNLangsIteamsAdded[i])"
            }
        }
        self.delegate?.sendToolNLangData(data: toolNLangString)
        self.dismiss(animated: true, completion: nil)
    }
    


}
extension DetailProfileToolNLanguageViewController: UITextFieldDelegate {
    
    // 값 비교해서 collection view 바꿔줌
    @objc func searchAction(textfield: UITextField) {
        if textfield.hasText {
            addCount = 0
            toolNLangsIteams = oldValuetoolNLangsIteams
            if let keyword = textfield.text {
                searchText = keyword.lowercased()
            }
            var newArr: [String] = []
            
            for i in 0..<toolNLangsIteams.count {
                if toolNLangsIteams[i].lowercased().contains(searchText) {
                    newArr.append(toolNLangsIteams[i])
                }
            }
          
            toolNLangsIteams = newArr
            
            
            for i in 0..<newArr.count {
                if  newArr[i].lowercased() != searchText {
                    addCount += 1
                }
            }
            if addCount >= newArr.count {
                toolNLangsIteams.append(textfield.text!)
            }
            
            
            searchResultCollectionView.reloadData()
        }
        else {

//            for i in 0..<oldValuetoolNLangsIteams.count {
//                if toolNLangsIteamsAdded.count > 0 {
//                    for j in 0..<toolNLangsIteamsAdded.count {
//                        if oldValuetoolNLangsIteams[i].contains(toolNLangsIteamsAdded[j]) {
//                            oldValuetoolNLangsIteams.remove(at: i)
//                        }
//                    }
//                }
//            }
            
            toolNLangsIteams = oldValuetoolNLangsIteams
            print(oldValuetoolNLangsIteams)
            
            searchResultCollectionView.reloadData()
        }
        
        
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
extension DetailProfileToolNLanguageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchResultCollectionView {
            return toolNLangsIteams.count
        }
        else {
            return toolNLangsIteamsAdded.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allToolNLangCell", for: indexPath) as! DetailProfileAllToolNLangCollectionViewCell
        cell.toolNLangBtn.layer.borderWidth = 0.5
        cell.toolNLangBtn.layer.cornerRadius =  cell.frame.height/2

        if collectionView == searchResultCollectionView {
            cell.toolNLangBtn.setTitle(toolNLangsIteams[indexPath.row], for: .normal)
            cell.toolNLangBtn.layer.borderColor = UIColor(named: "gray_196")?.cgColor
        }
        else {
            cell.toolNLangBtn.setTitle(toolNLangsIteamsAdded[indexPath.row], for: .normal)
            cell.toolNLangBtn.layer.borderColor = UIColor(named: "purple_184")?.cgColor
     
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
        let label = UILabel()
        if collectionView == searchResultCollectionView {
            label.text = toolNLangsIteams[indexPath.item]
        }
        else {
            label.text = toolNLangsIteamsAdded[indexPath.item]
        }
        label.font = UIFont(name: "Apple SD 산돌고딕 Neo 일반체", size: 14.0)
        label.sizeToFit()
        let size = label.frame.size
        
        
        return CGSize(width: size.width+40, height: size.height + 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("fdsafdsa")
        let cell = collectionView.cellForItem(at: indexPath) as! DetailProfileAllToolNLangCollectionViewCell
        if collectionView == searchResultCollectionView {
            addCount = 0
            if !toolNLangsIteamsAdded.contains((cell.toolNLangBtn.titleLabel?.text)!) {
                toolNLangsIteamsAdded.append((cell.toolNLangBtn.titleLabel?.text)!)
                
              
                toolNLangsIteams.remove(at: indexPath.row)
                print("yeyyeyeey \(oldValuetoolNLangsIteams.count)")
//                for i in 0..<oldValuetoolNLangsIteams.count {
//                    if oldValuetoolNLangsIteams[i] == cell.toolNLangBtn.titleLabel?.text?.lowercased() {
//                        print("nono \(i)")
//                        oldValuetoolNLangsIteams.remove(at: i)
//                    }
//                }
                
                // 수정 필요
                 // oldValuetoolNLangsIteams = toolNLangsIteams
                
                
                print("toolNLangsIteams : \(toolNLangsIteams)")
                
                addedCollectionView.reloadData()
                searchResultCollectionView.reloadData()
            }
        }
        else {
            toolNLangsIteamsAdded.remove(at: indexPath.row)
            toolNLangsIteams.append((cell.toolNLangBtn.titleLabel?.text)!)
            oldValuetoolNLangsIteams = toolNLangsIteams
            print("oldValuetoolNLangsIteams : \(oldValuetoolNLangsIteams)")
            
            
            addedCollectionView.reloadData()
            searchResultCollectionView.reloadData()
        }
    }
}

protocol SendToolNLangDataDelegate {
    func sendToolNLangData(data: String)
}



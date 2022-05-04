//
//  QuestionnaireViewController.swift
//  iteam_ny
//
//  Created by 김하늘 on 2022/03/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class QuestionnaireViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var questionTableView: UITableView!
    
    var nickname: String = ""
    var questionArr: [String] = []
    var selectedTime: String = ""
    let db = Database.database().reference()
    var resizedImage: UIImage = UIImage()
    var teamName: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
       
        fetchUID(nickname: nickname)
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }
    func setUI() {
        closeBtn.layer.cornerRadius = 8
        titleLabel.text = "\(nickname) 님이 궁금해해요!"
        
        
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.layer.masksToBounds = true
        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func agreeBtnAction(_ sender: UIButton) {
        
       
        let values: [String: String] = [ "callTime": selectedTime ]
        let stmt: [String: String] = [ "stmt": "대기 중" ]
       
        // 데이터 추가
        db.child("Call").child(teamName).updateChildValues(values)
        db.child("Call").child(teamName).updateChildValues(stmt)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // nickname으로 uid찾기
    func fetchUID(nickname: String) {
        let userdb = db.child("user").queryOrdered(byChild: "userProfile/nickname").queryEqual(toValue: nickname)
        userdb.observeSingleEvent(of: .value) { [self] snapshot in
            var userUID: String = ""
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                userUID = snap.key
            }
            fetchImages(uid: userUID)
        }
    }
    
    // cloud storage에서 사진 불러오기
    func fetchImages(uid: String) {
        
        let storage = Storage.storage().reference().child("user_profile_image").child(uid + ".jpg")
        
        storage.downloadURL { [self] url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // 다운로드 성공
                print("사진 다운로드 성공")
                let imageURL = url!
                let data = try? Data(contentsOf: imageURL)
                
                // 데이터 받아오기 전까지 기본 이미지
                if let fetchedImage = UIImage(data: data!) {
                    resizedImage = resizeImage(image: fetchedImage, width: 35, height: 35)
                    
                }
                else {
                    // 받아온 사진 리사이징, 셀에 설정
                    resizedImage = resizeImage(image: UIImage(named: "imgUser4.png")!, width: 35, height: 35)
                }
               
                
                // 비동기적으로 데이터 세팅 및 collectionview 리로드
                DispatchQueue.main.async {
                    userImage.image = resizedImage
                    
                }
            }
        }
    }

}
extension QuestionnaireViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! CallRequestHistoryQuestionTableViewCell
        cell.questionLabel.text = questionArr[indexPath.row]
        return cell
        
    }
    
    
}

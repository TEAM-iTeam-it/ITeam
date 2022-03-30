//
//  HomeViewController.swift
//  iteam_ny
//
//  Created by 성의연 on 2021/11/27.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addFriendButton: UIButton!
    
    var ref: DatabaseReference! //Firebase Realtime Database
    
    var userList: [UserProfile] = []
    var image = [UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser4"),UIImage(named: "imgUser5"),UIImage(named: "imgUser5")]
       
        override func viewDidLoad() {
            super.viewDidLoad()
            
           
            ref = Database.database().reference()
            
            //UITableView Cell Register
            let nibName = UINib(nibName: "UserListCell", bundle: nil)
            homeTableView.register(nibName, forCellReuseIdentifier: "UserListCell")
            
            homeTableView.rowHeight = UITableView.automaticDimension
            homeTableView.estimatedRowHeight = 70
            
            self.homeTableView.panGestureRecognizer.delaysTouchesBegan = true
            
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            
            
            //데이터 가져오기
            ref.observe(.value) { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value)
                    let userData = try JSONDecoder().decode([String: UserProfile].self, from: jsonData)
                    let showUserList = Array(userData.values)
                    self.userList = showUserList.sorted { $0.rank < $1.rank } //정렬 순서
                    
                    print("countentArray.cout : \(showUserList.count)")
                    
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                        print("countentArray3.cout : \(self.userList.count)")
                    }
                    
                }catch let DecodingError.dataCorrupted(context) {
                    print("error2 : ",context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                catch let error {
                    print("ERROR JSON parasing \(error.localizedDescription)")
                }
                
                print("countentArray2.cout : \(self.userList.count)")
                
            }
            
           
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "memberCell", bundle: .main), forCellWithReuseIdentifier: "memberCell")
            
            
            homeTableView.layer.shadowColor = UIColor.black.cgColor // 색깔
            homeTableView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
            homeTableView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
//            homeTableView.layer.borderWidth = 1
            homeTableView.layer.shadowRadius = 5 // 반경
            homeTableView.layer.shadowOpacity = 0.3 // alpha값
            self.homeTableView.layer.cornerRadius = 10.0
            homeTableView.contentInset = UIEdgeInsets(top: 20, left: .zero, bottom: 10, right: .zero)
    //
            addFriendButton.layer.shadowColor = UIColor.black.cgColor // 색깔
            addFriendButton.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
            addFriendButton.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
            addFriendButton.layer.shadowRadius = 5 // 반경
            addFriendButton.layer.shadowOpacity = 0.3 // alpha값
            
            
       }
    //
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
       }
    
        
}
        
    extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
        
        //배열의 인덱수 수가 테이블 뷰의 row 수
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.userList.count
           }
       
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell",for: indexPath) as? UserListCell else {return UITableViewCell()}
                
//           let cell = homeTableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
               cell.userImage.image = UIImage(systemName: "person.fill")
                cell.userName.text = "\(userList[indexPath.row].userprofileDetail.name)"
                cell.school.text = "\(userList[indexPath.row].rank)위"
                cell.partLabel.text = "\(userList[indexPath.row].userprofileDetail.part)"
                cell.userPurpose.text = "\(userList[indexPath.row].userprofileDetail.purpose)"
       
               return cell
           }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            print("You selected cell #\(indexPath.row)!")
            //상세페이지 이동
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let detailViewController = storyboard.instantiateViewController(identifier: "UserProfileController") as? UserProfileController else { return }
            
                detailViewController.userprofileDetail = userList[indexPath.row].userprofileDetail
                self.show(detailViewController, sender: nil)
            
            
            //                let userID = userList[indexPath.row].id
            //                ref.child("Item\(userID)/isSelected").setValue(true)
            
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
            FixedMemberCell.memberImage.image = self.image[indexPath.row]
            
            return FixedMemberCell
        }


    }

    @IBDesignable class PaddingLabel: UILabel {

        @IBInspectable var topInset: CGFloat = 5.0
        @IBInspectable var bottomInset: CGFloat = 5.0
        @IBInspectable var leftInset: CGFloat = 8.0
        @IBInspectable var rightInset: CGFloat = 8.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        
        override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
        }
}
    
    


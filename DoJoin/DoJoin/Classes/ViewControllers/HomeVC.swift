//
//  HomeVC.swift
//  DoJoin
//
//  Created by Ijaz on 02/10/2020.
//

import UIKit
import Alamofire
import SVProgressHUD

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var follersLbl: UILabel!
    
    
    var discussionsArr: [NSDictionary] = []
    var profileDictionary: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUIControls() // Set rounded corner of the user image
        getProfile()
        getDiscussions()
    }
    
    func setupUIControls(){
        userImgView.layer.cornerRadius = 5.0
        userImgView.layer.masksToBounds = true
    }
    
    // MARK: - Network Calls
    func getProfile(){
        NetworkManager.shared.getProfileRequest(success: { (data) in
            
            DispatchQueue.main.async {
                let response = data as! NSDictionary
                self.profileDictionary = response.value(forKey: "result") as! NSDictionary
                print("profileDictionary is: \(self.profileDictionary)")
                self.setupUserProfile() // Show the user details
                
            }
            
        }) { (errorCode, errorDescription) in
            
            DispatchQueue.main.async {
                let alert  = self.showAlert(message: errorDescription)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getDiscussions(){
        self.showProgressActivity(hide: false)
        NetworkManager.shared.getDiscussionsRequest(success: { (data) in
            
            DispatchQueue.main.async {
                self.showProgressActivity(hide: true)
                let response = data as! NSDictionary
                self.discussionsArr = response.value(forKey: "result") as! [NSDictionary]
                print("Success Response is: \(response)")
                print("discussionsArr count is: \(self.discussionsArr.count)")
                
                //self.setCategoriesDic()
                
                self.collectionView.reloadData()
            }
            
        }) { (errorCode, errorDescription) in
            
            DispatchQueue.main.async {
                self.showProgressActivity(hide: true)
                let alert  = self.showAlert(message: errorDescription)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- Helper methods
    func setupUserProfile(){
        self.userNameLbl.text = profileDictionary.value(forKey: "fullName") as? String
        let followingInt = profileDictionary.value(forKey: "followingsCount")
        self.followingLbl.text = String(describing: followingInt!)
        let followersInt = profileDictionary.value(forKey: "followersCount")
        self.follersLbl.text = String(describing: followersInt!)
        let imgURL = profileDictionary.value(forKey: "avatar") as? String
        
        let newURL = "http://208.109.13.111:7171" + imgURL!
        let url = URL(string: newURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        if (url != nil){
            self.userImgView.sd_setImage(with: url, completed: nil)
        }
    }
    
    // MARK:- Utility Methods
    func showAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "", message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    func showProgressActivity(hide: Bool){
        if(!hide){
            self.view.isUserInteractionEnabled = false
            SVProgressHUD.setBackgroundColor(UIColor.black)
            SVProgressHUD.setForegroundColor(UIColor.white)
            SVProgressHUD.show(withStatus: "Loading")
        }
        else{
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
}


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Products count: \(discussionsArr)")
        return discussionsArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscussionCVCell",
                                                         for: indexPath) as? DiscussionCVCell {
            let name = discussionsArr[indexPath.row].value(forKey: "title") as? String
            let urlString = discussionsArr[indexPath.row].value(forKey: "videoUrl") as? String
            
            cell.configureCell(DTitle: name!, discussionImgURL: urlString!)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

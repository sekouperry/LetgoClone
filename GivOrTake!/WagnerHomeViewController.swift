//
//  WagnerHomeViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import HMSegmentedControl
import Firebase

class WagnerHomeViewController: UIViewController {

    var databaseRef: FIRDatabaseReference! {
        
        return FIRDatabase.database().reference()
    }
    
    var segmentedControl: HMSegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.alpha = 0
        }
    }
    
    var usersArray = [Users]()
    var netService = NetworkingServices()
    var postsArray = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchAllUsers()
        setSegmentedControl()
        fetchAllPosts()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 592
    }
    //fetching user from firebase
    private func fetchAllUsers(){
        netService.fetchAllUsers { (users) in
            self.usersArray = users
            self.collectionView.reloadData()
        }
    }
    //fetching post from firebase
    private func fetchAllPosts(){
        netService.fetchAllPosts {(posts) in
            self.postsArray = posts
            self.postsArray.sort(by: { (post1, post2) -> Bool in
                Int(post1.postDate) > Int(post2.postDate)
            })
            
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func commentPostWithImageAction(_ sender: UIButton) {
        performSegue(withIdentifier: "showComments", sender: sender)
    }
    
    @IBAction func commentPostWithTextAction(_ sender: Any) {
        performSegue(withIdentifier: "showComments", sender: sender)
        
    }
    @IBAction func logOutAction(_ sender: UIButton) {
        netService.logOut {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! SignInViewController
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func unwindToHome(storyboardSegue: UIStoryboardSegue){}
    //Adding segmented feature
    func setSegmentedControl(){
        segmentedControl = HMSegmentedControl(frame: CGRect(x: 0, y: 99, width: self.view.frame.size.width, height: 60))
        segmentedControl.sectionTitles = ["WAGNER COLLEGE","USERS"]
        segmentedControl.backgroundColor = UIColor(colorWithHexValue: 0x009241)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), NSFontAttributeName: UIFont(name:"AppleSDGothicNeo-Medium", size: 18)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentedControl.selectionIndicatorColor = UIColor(red:1, green: 1, blue: 1, alpha: 0.5)
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionIndicatorLocation = .up
        segmentedControl.addTarget(self, action: #selector(WagnerHomeViewController.segmentedControlAction), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentedControl)
        
    }
    
    func segmentedControlAction(){
        if segmentedControl.selectedSegmentIndex == 0 {
            
            self.collectionView.alpha = 0
            self.tableView.alpha = 1.0
            
        } else {
            self.collectionView.alpha = 1.0
            self.tableView.alpha = 0
        }
    }
}


extension WagnerHomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    struct CellIdentifiers {
        var userCell = "userCell"
        var postImageCell = "imageCell"
        var postTextCell = "textCell"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if postsArray[indexPath.row].type == "IMAGE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postImageCell, for: indexPath) as! PostImagesTableViewCell
            cell.configureCell(post:postsArray[indexPath.row])
            cell.commentButton.tag = indexPath.row
            return cell
        } else if postsArray[indexPath.row].type == "VIDEO" {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postImageCell, for: indexPath) as! PostImagesTableViewCell
            cell.configureCell(post:postsArray[indexPath.row])
            cell.commentButton.tag = indexPath.row
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers().postTextCell, for: indexPath) as! PostTextsTableViewCell
            cell.configureCell(post:postsArray[indexPath.row])
            cell.commentButton.tag = indexPath.row
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuest" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let guestVC = segue.destination as! GuestUsersViewController
                guestVC.ref = usersArray[indexPath.row].ref
            }
        }else if segue.identifier == "showComments" {
            let sender = sender as? UIButton
            if let indexPath = sender?.tag  {
                let commentsVC = segue.destination as! CommentssTableViewController
                commentsVC.post = self.postsArray[indexPath]
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers().userCell, for: indexPath) as! UsersCollectionViewCell
        cell.configureCellForUser(user: self.usersArray[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGuest", sender: self)
        
    }

}

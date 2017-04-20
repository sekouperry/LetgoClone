//
//  CommentssTableViewController.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit
import Firebase

class CommentssTableViewController: UITableViewController {

    var post: Posts!
    var commentsArray = [Comments]()
    var netService = NetworkingServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 428
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        netService.fetchAllComments(postId: post.postId) { (comments) in
            self.commentsArray = comments
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentsArray.count
    }
    
    @IBAction func addCommentAction(_ sender: Any) {
        performSegue(withIdentifier: "addComment", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if commentsArray[indexPath.row].type == "IMAGE" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentImageCell", for: indexPath) as! CommentImagessTableViewCell
            cell.configureCell(comment:commentsArray[indexPath.row])
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentTextCell", for: indexPath) as! CommentsTextTableViewCell
            cell.configureCell(comment:commentsArray[indexPath.row])
            
            return cell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment"{
            let addCommentVC = segue.destination as! AddCommentssViewController
            addCommentVC.postId = post.postId
        }
    }
}

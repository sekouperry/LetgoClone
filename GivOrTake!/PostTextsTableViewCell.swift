//
//  PostTextsTableViewCell.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit

class PostTextsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var verifiedImageView: UIImageView!
    var netService = NetworkingServices()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func likePostAction(_ sender: UIButton) {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.usernameLabel.text = ""
        self.postTextLabel.text = ""
    }
    
    
    
    func configureCell(post: Posts){
        
        netService.fetchPostUserInfo(uid: post.userId) { (user) in
            if let user = user {
                self.userImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                self.usernameLabel.text = user.getFullname()
                self.verifiedImageView.isHidden = !user.isVerified
            }
        }
        
        netService.fetchNumberOfComments(postId: post.postId) { (numberOfComments) in
            self.numberOfCommentsLabel.text = "\(numberOfComments)"
        }
        
        self.postTextLabel.text = post.postText
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(post.postDate))
        let toDate = NSDate()
        
        let differenceOfDate = Calendar.current.dateComponents([.second,.minute,.hour,.day,.weekOfMonth], from: fromDate as Date, to: toDate as Date)
        if differenceOfDate.second! <= 0 {
            dateLabel.text = "now"
        } else if differenceOfDate.second! > 0 && differenceOfDate.minute! == 0 {
            dateLabel.text = "\(differenceOfDate.second!)secs."
            
        }else if differenceOfDate.minute! > 0 && differenceOfDate.hour! == 0 {
            dateLabel.text = "\(differenceOfDate.minute!)mins."
            
        }else if differenceOfDate.hour! > 0 && differenceOfDate.day! == 0 {
            dateLabel.text = "\(differenceOfDate.hour!)hrs."
            
        }else if differenceOfDate.day! > 0 && differenceOfDate.weekOfMonth! == 0 {
            dateLabel.text = "\(differenceOfDate.day!)dys."
            
        }else if differenceOfDate.weekOfMonth! > 0 {
            dateLabel.text = "\(differenceOfDate.weekOfMonth!)wks."
            
        }
        
        
        
        
    }
    

    

}

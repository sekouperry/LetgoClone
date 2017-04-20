//
//  CommentImagessTableViewCell.swift
//  GivOrTake!
//
//  Created by Kenneth Okereke on 3/24/17.
//  Copyright © 2017 Kenneth Okereke. All rights reserved.
//

import UIKit

class CommentImagessTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var verifiedImageView: UIImageView!
    var netService = NetworkingServices()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.usernameLabel.text = ""
        self.commentTextLabel.text = ""
        
        
    }
    
    func configureCell(comment: Comments){
        
        self.commentImageView.sd_setImage(with: URL(string: comment.commentImageURL), placeholderImage: UIImage(named: "default-thumbnail"))
        
        netService.fetchPostUserInfo(uid: comment.userId) { (user) in
            if let user = user {
                self.userImageView.sd_setImage(with: URL(string: user.profilePictureUrl), placeholderImage: UIImage(named: "default"))
                self.usernameLabel.text = user.getFullname()
                self.verifiedImageView.isHidden = !user.isVerified
            }
        }
        
        
        
        self.commentTextLabel.text = comment.commentText
        
        let fromDate = NSDate(timeIntervalSince1970: TimeInterval(comment.commentDate))
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

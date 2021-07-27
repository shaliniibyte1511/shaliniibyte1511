//
//  PostCommentsCell.swift
//  Alysei
//
//  Created by Shivani Vohra Gandhi on 11/07/21.
//

import UIKit

class SelfPostCommentsCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var viewReplyButton: UIButton!

    var model: PostComments.Comment.Response!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2.0
    }
}

class OtherUserPostCommentsCell: SelfPostCommentsCell {
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var likeButton: UIButton!
}

class PostCommentWithReplyCell: SelfPostCommentsCell {
    @IBOutlet var replyTableView: UITableView!
}

extension PostCommentWithReplyCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SelfPostCommentsCell else {
            return UITableViewCell()
        }
        let commentData = self.model.data[indexPath.row]
        let name = commentData.poster?.name ?? commentData.poster?.restaurantName ?? commentData.poster?.companyName ?? ""
        cell.descriptionLabel.text = "\(commentData.body)"
        cell.userNameLabel.text = "\(name)"
        cell.timeLabel.text = "\(commentData.convertDate())"
        //        cell.userImageView.setImage(withString: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=400")
        cell.userImageView.setImage(withString: "\(imageDomain)/\(commentData.poster?.avatarID?.attachmentUrl ?? "")")
        return cell
    }

}

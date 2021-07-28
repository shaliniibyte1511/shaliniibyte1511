//
//  NotificationTableCell.swift
//  ScreenBuild
//
//  Created by Alendra Kumar on 21/01/21.
//

import UIKit

class NotificationTableCell: UITableViewCell {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var imgViewNotification: UIImageView!
    @IBOutlet weak var lblNotificationTime: UILabel!
    
    //MARK: - Public Methods -
    
    public func configure(){
      
      imgViewNotification.image = UIImage.init(named: "select_role4")
      lblNotificationTitle.text = "Anthony Tran is now connected with you."
      lblNotificationTime.text = "few seconds ago"
    }

}

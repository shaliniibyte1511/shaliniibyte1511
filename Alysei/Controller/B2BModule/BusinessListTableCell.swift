//
//  BusinessListTableCell.swift
//  Alysie
//
//  Created by CodeAegis on 24/01/21.
//

import UIKit

class BusinessListTableCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    

  override func awakeFromNib() {
    super.awakeFromNib()
  }
    func configData(_ data: SubjectData){
    
        let roleID = UserRoles(rawValue:Int.getInt(data.roleId)  ) ?? .voyagers
        var name = ""
        switch roleID {
        case .distributer1, .distributer2, .distributer3, .producer, .travelAgencies :
            name = data.companyName ?? ""
        case .restaurant :
            name =  data.restaurantName ?? ""
        default:
            name = data.companyName ?? ""
        }
        userName.text = name
        userLocation.text = data.email
        userImage.setImage(withString: kImageBaseUrl + String.getString(data.avatarId?.attachmentUrl))
       
   }
}

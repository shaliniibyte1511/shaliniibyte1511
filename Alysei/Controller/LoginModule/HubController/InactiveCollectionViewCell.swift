//
//  InactiveCollectionViewCell.swift
//  Alysei
//
//  Created by Gitesh Dang on 19/03/21.
//

import UIKit

class InactiveCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgFlag: ImageLoader!
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var lblCountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgFlag.applyshadowWithCorner(containerView: imgContainer, cornerRadious: 30)
    }
    
    func configCell(_ data: CountryModel){
        lblCountryName.text = data.name

        if let strUrl = "\(kImageBaseUrl1)\(data.flagId?.attachmentUrl ?? "")".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let imgUrl = URL(string: strUrl) {
            print("\("FlagImageUrl---------------------------\(imgUrl)")")
            imgFlag.loadImageWithUrl(imgUrl) // call this line for getting image to yourImageView
        }
    }
}

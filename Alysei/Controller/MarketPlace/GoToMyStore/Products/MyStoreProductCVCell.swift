//
//  MyStoreProductCVCell.swift
//  Alysei
//
//  Created by SHALINI YADAV on 6/24/21.
//

import UIKit

class MyStoreProductCVCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    var deleteCallBack:((Int) -> Void)? = nil
    var data: MyStoreProductDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow()
    }
    
    func configCell(_ data: MyStoreProductDetail){
        self.data = data
        lblProductName.text = data.title
        
        print("Test Image------------------------------\(data )")
        self.imgProduct.setImage(withString: kImageBaseUrl + String.getString(data.product_gallery?.first?.attachment_url))
        
    }
    
    @IBAction func editProduct(_ sender: UIButton){
        
    }
    
    @IBAction func deleteProduct(_ sender: UIButton){
        self.deleteCallBack?(self.data?.marketplace_product_id ?? 0)
    }
    
}

//
//  AddIngridientsTableViewCell.swift
//  Alysei
//
//  Created by namrata upadhyay on 17/08/21.
//

import UIKit


protocol AddIngridientsTableViewCellProtocol {
    func tapForIngridient(indexPath: IndexPath)
}
class AddIngridientsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientsNameLabel: UILabel!
    
    @IBOutlet weak var ingridientsImageView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var selectImgView: UIImageView!
    
//    var tapBlock:(()->())?
    var indexPath: IndexPath?
    var addIngridientDelegate : AddIngridientsTableViewCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha: 1).cgColor
        addButton.layer.cornerRadius = 5
        selectImgView.layer.cornerRadius = 5
//        ingridientsImageView.layer.cornerRadius = self.ingridientsImageView.frame.width/2
        // Configure the view for the selected state
    }

    @IBAction func TapForAddIngridient(_ sender: UIButton) {
        
//        tapBlock?()
        addIngridientDelegate?.tapForIngridient(indexPath: indexPath ?? IndexPath(row: sender.tag, section: 0))
    }
    
    
}



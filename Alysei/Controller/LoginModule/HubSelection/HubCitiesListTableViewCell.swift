//
//  HubCitiesListTableViewCell.swift
//  Alysei
//
//  Created by SHALINI YADAV on 7/15/21.
//

import UIKit

class HubCitiesListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
    var city:CountryHubs?{didSet{self.awakeFromNib()}}
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblCountryName.text = city?.name
        self.btnSelected.isSelected = city?.isSelected ?? false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func selectedCity(_ sender: UIButton) {
        self.city?.isSelected = !(self.city?.isSelected ?? false)
        self.awakeFromNib()
    }
    
}

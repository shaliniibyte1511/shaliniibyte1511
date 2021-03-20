//
//  SelectCityTableViewCell.swift
//  Alysie
//
//  Created by Gitesh Dang on 03/03/21.
//

import UIKit

class SelectCityTableViewCell: UITableViewCell {
    
    //MARK: IBOUtlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonLeftCheckbox: UIButton!
    @IBOutlet weak var buttonRightCheckBox: UIButton!
    @IBOutlet weak var buttonLeftCheckWidth: NSLayoutConstraint!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var checkMarkView: Checkmark!
    
    var leftBtnCallBack: ((String,String,Bool,Int) -> Void)? = nil
    var rightBtnCallBack: ((UIButton) -> Void)? = nil
    var data : CountryHubs?
    var index: Int?
    var selectState:String?
    var selectStateId: String?
    var checkCase: CountryCityHubSelection?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetup()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: Initial Functions
    func initialSetup(){
        viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.shadowOffset = .zero
        viewContainer.layer.shadowRadius = 1

    }
   
    func configCell(_ data: CountryHubs?, _ index: Int, _ checkCase:CountryCityHubSelection ){
        self.data = data
      //  buttonLeftCheckbox.isHidden = false
        buttonLeftCheckWidth.constant = 20
       labelCityName.text = data?.name
       
        if data?.isSelected == true  {
            checkMarkView.initialLayerColor = UIColor.clear
            checkMarkView.animatedLayerColor = UIColor.init(hexString: "174E85")
            checkMarkView.animated = true
            checkMarkView.animate()
        }
        else{
            checkMarkView.animated = false
            checkMarkView.animatedLayerColor = UIColor.lightGray

        }
        
       // self.buttonLeftCheckbox.setImage((data?.isSelected == true) ? UIImage(named: "icon_blueSelected") : UIImage(named: "icon_uncheckedBox"), for: .normal)
    }
    
    @IBAction func btnLeftCheckBoxAction(_ sender: UIButton){
        self.selectState = data?.name
        //self.leftBtnCallBack?(selectState ?? "",data?.id ?? "",sender.isSelected,sender.tag)
    }
    @IBAction func btnRightCheckBoxAction(_ sender: UIButton){
        self.rightBtnCallBack?(sender)
    }
    //MARK: Config Cell
//    func configCell(_ data: SignUpOptionsDataModel){
//        self.labelCityName.text = data.title
//    }
}


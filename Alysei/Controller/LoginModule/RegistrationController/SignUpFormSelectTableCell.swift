//
//  SignUpFormSelectTableCell.swift
//  Alysie
//
//  Created by CodeAegis on 06/02/21.
//

import UIKit

class SignUpFormSelectTableCell: UITableViewCell {
  
  //MARK: - IBOutlet -
  
  @IBOutlet weak var lblHeading: UILabel!
  @IBOutlet weak var txtFieldSelect: UITextFieldExtended!
  @IBOutlet weak var imgViewDropDown: UIImageView!
  @IBOutlet weak var imgViewLocation: UIImageView!
  
  
  //MARK: - Properties -
  
  var currentModel: SignUpStepTwoDataModel!
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    txtFieldSelect.makeCornerRadius(radius: 5.0)
    self.txtFieldSelect.addTarget(self, action: #selector(SignUpFormSelectTableCell.textFieldEditingChanged(_:)),for: UIControl.Event.editingChanged)
  }
  
  //MARK: - Public Methods -
  
  @objc func textFieldEditingChanged(_ sender: UITextFieldExtended){

    self.currentModel.selectedValue = String.getString(self.txtFieldSelect.text)
  }

  //MARK: - Public Methods -
  
  public func configureData(withSignUpStepTwoDataModel model: SignUpStepTwoDataModel) -> Void{
    
    self.lblHeading.text = (model.required == AppConstants.Yes) ? String.getString(model.title) + "*" : model.title
    self.txtFieldSelect.attributedPlaceholder = NSAttributedString(string: String.getString(model.placeholder).capitalized,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: AppColors.liteGray.color])
    self.currentModel = model
    switch model.type {
    case AppConstants.Text:
      self.txtFieldSelect.isUserInteractionEnabled = true
      self.txtFieldSelect.text = model.selectedValue
      self.imgViewDropDown.isHidden = true
      self.imgViewLocation.isHidden = true
    case AppConstants.Map:
      self.imgViewDropDown.isHidden = true
      self.imgViewLocation.isHidden = false
      self.txtFieldSelect.text = model.selectedValue
      self.txtFieldSelect.isUserInteractionEnabled = false
    default:
      self.imgViewDropDown.isHidden = false
      self.imgViewLocation.isHidden = true
      self.txtFieldSelect.isUserInteractionEnabled = false
      self.txtFieldSelect.text = model.selectedOptionName

    }
  }
}

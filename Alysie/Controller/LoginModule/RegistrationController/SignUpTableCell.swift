//
//  SignUpTableCell.swift
//  ScreenBuild
//
//  Created by Alendra Kumar on 13/01/21.
//

import UIKit

protocol TappedInfo {
  
  func tapInfo(_ model: SignUpStepOneDataModel) -> Void
}

class SignUpTableCell: UITableViewCell {
    
  //MARK: - IBOutlet -
  
  @IBOutlet weak var txtFieldSignUp: UITextField!
  @IBOutlet weak var lblHeading: UILabel!
  @IBOutlet weak var imgViewDropDown: UIImageView!
  @IBOutlet weak var lblHint: UILabel!
  @IBOutlet weak var btnEye: UIButton!
  @IBOutlet weak var btnInfo: UIButton!
  
  //MARK: - Properties -
  
  var signUpStepOneDataModel: SignUpStepOneDataModel!
  var delegate: TappedInfo?
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    self.btnEye.isSelected = false
    txtFieldSignUp.makeCornerRadius(radius: 5.0)
    self.txtFieldSignUp.addTarget(self, action: #selector(SignUpTableCell.textFieldEditingChanged(_:)),for: UIControl.Event.editingChanged)
  }
  
  //MARK: - IBAction -
  
  @IBAction func tapEye(_ sender: UIButton) {
  
    self.btnEye.isSelected = (self.btnEye.isSelected == false) ? true : false
    self.txtFieldSignUp.isSecureTextEntry = (self.btnEye.isSelected == false) ? true : false
  }
  
  @IBAction func tapInfo(_ sender: UIButton) {
    
    self.delegate?.tapInfo(self.signUpStepOneDataModel)
  }
  
  //MARK: - Public Methods -
  
  @objc func textFieldEditingChanged(_ sender: UITextFieldExtended){

    self.signUpStepOneDataModel.selectedValue = String.getString(self.txtFieldSignUp.text)
  }

  //MARK: - Public Methods -
  
  public func configureData(withSignUpStepOneDataModel model: SignUpStepOneDataModel){
    
    self.signUpStepOneDataModel = model
    self.lblHint.text = model.hint
    self.lblHeading.text = (model.required == AppConstants.Yes) ? String.getString(model.title) + "*" : model.title
    self.txtFieldSignUp.attributedPlaceholder = NSAttributedString(string: String.getString(model.placeholder),
                                                                   attributes: [NSAttributedString.Key.foregroundColor: AppColors.liteGray.color])
    
    self.btnInfo.isHidden = ((model.hint?.isEmpty == true) || (model.type == AppConstants.Password)) ? true : false
    
    
    switch model.type {
    case AppConstants.Select,AppConstants.Checkbox,AppConstants.Multiselect:
      
      self.btnEye.isHidden = true
      self.txtFieldSignUp.text = model.selectedOptionName
      self.txtFieldSignUp.isUserInteractionEnabled = false
      self.imgViewDropDown.isHidden = false
      self.txtFieldSignUp.isSecureTextEntry = false
//      self.txtFieldSignUp.attributedPlaceholder = NSAttributedString(string: AppConstants.Select.capitalized + " " + String.getString(model.title),
//                                                                     attributes: [NSAttributedString.Key.foregroundColor: AppColors.liteGray.color])
    case AppConstants.Password:
      self.imgViewDropDown.isHidden = true
      self.txtFieldSignUp.isUserInteractionEnabled = true
      self.txtFieldSignUp.text = model.selectedValue
      self.btnEye.isHidden = false
      self.txtFieldSignUp.isSecureTextEntry = (self.btnEye.isSelected == false) ? true : false
    default:
      self.btnEye.isHidden = true
      self.imgViewDropDown.isHidden = true
      self.txtFieldSignUp.isSecureTextEntry = false
      self.txtFieldSignUp.isUserInteractionEnabled = true
      self.txtFieldSignUp.text = model.selectedValue
    }
  }
   
}

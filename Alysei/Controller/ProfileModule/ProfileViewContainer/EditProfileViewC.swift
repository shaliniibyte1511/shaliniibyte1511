//
//  EditProfileViewC.swift
//  Alysie
//
//  Created by Alendra Kumar on 15/01/21.
//

import UIKit

class EditProfileViewC: AlysieBaseViewC {

    //MARK:  - IBOutlet -
    
    @IBOutlet weak var tableViewEditProfile: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnProfilePhoto: UIButton!
    @IBOutlet weak var btnCoverPhoto: UIButton!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var imgViewCoverPhoto: UIImageView!

    //MARK:  - Properties -

    var isProfilePhotoCaptured = false
    var isCoverPhotoCaptured = false

    var picker = UIImagePickerController()
    var signUpViewModel: SignUpViewModel!
    var signUpStepOneDataModel: SignUpStepOneDataModel!

    //MARK:  - ViewLifeCycle Methods -

    override func viewDidLoad() {

        super.viewDidLoad()

        if let coverPhoto = LocalStorage.shared.fetchImage(UserDetailNBasedElements.coverPhoto) {
            self.imgViewCoverPhoto.image = coverPhoto
        }
        if let profilePhoto = LocalStorage.shared.fetchImage(UserDetailNBasedElements.profilePhoto) {
            self.imgViewProfile.image = profilePhoto
        }

        self.imgViewProfile.roundCorners(.allCorners, radius: (self.imgViewProfile.frame.width / 2.0))
    }

    //MARK: - IBAction -

    @IBAction func tapBack(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tapSave(_ sender: UIButton) {
        self.postRequestToUpdateUserProfile()
    }

    @IBAction func tapCoverPhoto(_ sender: UIButton) {

        self.btnProfilePhoto.isSelected = false
        self.btnCoverPhoto.isSelected = true
        self.alertToAddImage()
    }

    @IBAction func tapProfilePhoto(_ sender: UIButton) {

        self.btnProfilePhoto.isSelected = true
        self.btnCoverPhoto.isSelected = false
        self.alertToAddImage()
    }

    //MARK:  - Private Methods -
    
    private func getEditProfileSelectTableCell(_ indexPath: IndexPath) -> UITableViewCell{

        let editProfileSelectTableCell = tableViewEditProfile.dequeueReusableCell(withIdentifier: EditProfileSelectTableCell.identifier(), for: indexPath) as! EditProfileSelectTableCell
        if self.signUpStepOneDataModel == nil{

            let model = self.signUpViewModel.arrSignUpStepOne.filter({$0.name == "product_type"})

            model.first?.selectedValue = self.createStringForProducts((model.first)!)
        }
        editProfileSelectTableCell.configure(withSignUpStepOneDataModel: self.signUpViewModel.arrSignUpStepOne[indexPath.row])
        editProfileSelectTableCell.lblHeadingTopConst.constant = 5 // indexPath.row == 0 ? 60 : 20

        return editProfileSelectTableCell
    }

    private func getSignUpMultiCheckboxTableCell(_ indexPath: IndexPath) -> UITableViewCell{

        let signUpMultiCheckboxTableCell = tableViewEditProfile.dequeueReusableCell(withIdentifier: SignUpMultiCheckboxTableCell.identifier(), for: indexPath) as! SignUpMultiCheckboxTableCell
        signUpMultiCheckboxTableCell.delegate = self
        signUpMultiCheckboxTableCell.configureStepOneData(withSignUpStepOneDataModel: self.signUpViewModel.arrSignUpStepOne[indexPath.row])
        signUpMultiCheckboxTableCell.lblHeadingTopConst.constant = 5 // indexPath.row == 0 ? 60 : 20
        return signUpMultiCheckboxTableCell
    }
    
    private func getEditProfileTextViewTableCell(_ indexPath: IndexPath) -> UITableViewCell{

        let editProfileTextViewTableCell = self.tableViewEditProfile.dequeueReusableCell(withIdentifier: EditProfileTextViewTableCell.identifier(), for: indexPath) as! EditProfileTextViewTableCell
        editProfileTextViewTableCell.configure(withSignUpStepOneDataModel: self.signUpViewModel.arrSignUpStepOne[indexPath.row])
        editProfileTextViewTableCell.lblHeadingTopConst.constant = 5 // indexPath.row == 0 ? 60 : 20
        return editProfileTextViewTableCell
    }

    private func getSignUpRadioTableCell(_ indexPath: IndexPath) -> UITableViewCell{

        let signUpFormTableCell = tableViewEditProfile.dequeueReusableCell(withIdentifier: SignUpFormTableCell.identifier(), for: indexPath) as! SignUpFormTableCell
        signUpFormTableCell.configure(withSignUpStepOneDataModel: self.signUpViewModel.arrSignUpStepOne[indexPath.row])
        signUpFormTableCell.delegate = self
        signUpFormTableCell.lblHeadingTopConst.constant = 5 // indexPath.row == 0 ? 60 : 20
        return signUpFormTableCell
    }

    private func openPicker(withArray arr: [String],model: SignUpStepOneDataModel,keyValue keyVal: String?) -> Void {

        let picker = RSPickerView.init(view: self.view, arrayList: arr, keyValue: keyVal, prevSelectedValue: 0, handler: {(selectedIndex: NSInteger, response: Any?) in

                                        if let strVal = response as? String{

                                            //        if model.arrOptions[selectedIndex].userFieldOptionId.isEmpty == true{
                                            //          kSharedInstance.signUpViewModel.roleId = model.arrOptions[selectedIndex].roleid
                                            //        }
                                            //        else{
                                            let optionId = model.arrOptions[selectedIndex].userFieldOptionId
                                            model.selectedValue = optionId
                                            //}
                                            model.selectedOptionName = strVal
                                            self.tableViewEditProfile.reloadData()
                                            print("selectedValue",strVal.uppercased())
                                        }})
        picker.viewContainer.backgroundColor = UIColor.white
    }

    private func alertToAddImage() -> Void {

        let alert:UIAlertController = UIAlertController(title: AlertMessage.kSourceType, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let cameraAction = UIAlertAction(title: AlertMessage.kTakePhoto,
                                         style: UIAlertAction.Style.default) { (action) in
            self.showImagePicker(withSourceType: .camera, mediaType: .image)
        }

        let galleryAction = UIAlertAction(title: AlertMessage.kChooseLibrary,
                                          style: UIAlertAction.Style.default) { (action) in
            self.showImagePicker(withSourceType: .photoLibrary, mediaType: .image)
        }

        let cancelAction = UIAlertAction(title: AlertMessage.kCancel,
                                         style: UIAlertAction.Style.cancel) { (action) in
            print("\(AlertMessage.kCancel) tapped")
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)

        let removePhotoAction = UIAlertAction(title: AlertMessage.kDeletePhoto,
                                              style: UIAlertAction.Style.default) { (action) in
            if self.isProfilePhotoCaptured {
                self.isProfilePhotoCaptured = false
                self.imgViewProfile.image = UIImage(named: "user_icon_normal")
            } else if self.isCoverPhotoCaptured {
                self.isCoverPhotoCaptured = false
                self.imgViewCoverPhoto.image = UIImage(named: "coverPhoto")
            }
        }
        // remove photo action will be shown in alert only when user has captured an image for either profile picture or cover photo
        if self.isProfilePhotoCaptured && self.btnProfilePhoto.isSelected {
            alert.addAction(removePhotoAction)
        } else if self.isCoverPhotoCaptured && self.btnCoverPhoto.isSelected {
            alert.addAction(removePhotoAction)
        }

        alert.addAction(cancelAction)


        self.present(alert, animated: true, completion: nil)
    }

    private func showImagePicker(withSourceType type: UIImagePickerController.SourceType,mediaType: MediaType) -> Void {

        if UIImagePickerController.isSourceTypeAvailable(type){

            self.picker.mediaTypes = mediaType.CameraMediaType
            self.picker.allowsEditing = true
            self.picker.sourceType = type
            self.present(self.picker,animated: true,completion: {
                self.picker.delegate = self
            })
            self.picker.delegate = self }
        else{
            self.showAlert(withMessage: "This feature is not available.")
        }
    }

    private func createStringForProducts(_ model: SignUpStepOneDataModel) -> String{

        let filteredSelectedProduct = model.arrOptions.map({$0}).filter({$0.isSelected == true})

        var selectedProductNames: [String] = []
        var selectedProductOptionIds: [String] = []
        var selectedSubProductOptionIds: [String] = []

        for index in 0..<filteredSelectedProduct.count {

            //var selectedProductId: [String] = []
            var selectedSubProductIdLocal: [String] = []

            selectedProductNames.append(String.getString(filteredSelectedProduct[index].optionName))
            selectedProductOptionIds.append(String.getString(filteredSelectedProduct[index].userFieldOptionId))

            let sections = filteredSelectedProduct[index].arrSubSections

            for sectionIndex in 0..<sections.count {

                print("arrSelectedSubOptions",sections[sectionIndex].arrSelectedSubOptions)
                selectedSubProductIdLocal.append(contentsOf: sections[sectionIndex].arrSelectedSubOptions.map({$0}))
            }
            selectedSubProductOptionIds.append(contentsOf: selectedSubProductIdLocal)
        }

        switch filteredSelectedProduct.count {
        case 0:
            print("No Products found")
        case 1:
            model.selectedOptionName = selectedProductNames[0]
        default:
            let remainingProducts = (selectedProductNames.count - 1)
            model.selectedOptionName = selectedProductNames[0] + " & " + String.getString(remainingProducts) + " more"
        }
        print("product",selectedProductOptionIds)
        print("sub product",selectedSubProductOptionIds)

        let mergeArray = (selectedProductOptionIds + selectedSubProductOptionIds).orderedSet
        return mergeArray.filter({ $0 != ""}).joined(separator: ", ")
    }

    //MARK:  - WebService Methods -

    private func postRequestToUpdateUserProfile() -> Void{

        let compressProfileData = self.imgViewProfile.image!.jpegData(compressionQuality: 0.5)
        let compressedProfileImage = UIImage(data: compressProfileData!)

        let compressCoverData = self.imgViewCoverPhoto.image!.jpegData(compressionQuality: 0.5)
        let compressedCoverImage = UIImage(data: compressCoverData!)
        //
        //    let dict: [String:Any] = ["avatar_id": compressedProfileImage!,
        //                              "cover_id": compressedCoverImage!]
        //
        //    let imageParam:[String:Any] = [APIConstants.kImage: dict,
        //                                   APIConstants.kImageName:APIConstants.kImages]

        //imageParam.

        //imageParam[APIConstants.kImageName:APIConstants.k] =

        let dictStepOne = self.signUpViewModel.toDictionaryStepOne()
        let imageParamProfile:[String:Any] = [APIConstants.kImage: compressedProfileImage as Any,
                                              APIConstants.kImageName: "avatar_id"
        ]
        let imageParamCover: [String:Any] = [
            APIConstants.kImage : compressedCoverImage as Any,
            APIConstants.kImageName: "cover_id"
        ]
        var imageParam = [[String:Any]]()
        imageParam.append(imageParamProfile)
        imageParam.append(imageParamCover)
        //    let dictUserImage : [String:Any] = [
        //        "avatar_id" : compressedProfileImage ?? UIImage(),
        //                         "cover_id" : compressedCoverImage ?? UIImage()
        //    ]
        let mergeDict = dictStepOne.compactMap { $0 }.reduce([:]) { $0.merging($1) { (current, _) in current } }
        CommonUtil.sharedInstance.postToServerRequestMultiPart(APIUrl.kUpdateUserProfile, params: mergeDict, imageParams: imageParam, controller: self) { (dictReponse) in


            LocalStorage.shared.saveImage(compressProfileData, fileName: UserDetailNBasedElements.profilePhoto)
            LocalStorage.shared.saveImage(compressCoverData, fileName: UserDetailNBasedElements.coverPhoto)
            
            self.showAlert(withMessage: AlertMessage.kProfileUpdated){
                self.navigationController?.popViewController(animated: true)
            }

            //print("Success")
        }
        //CommonUtil.sharedInstance.postRequestToImageUpload(withParameter: mergeDict, url: APIUrl.kUpdateUserProfile, image: imageParam, controller: self, type: 0)
    }
}

//MARK:  - TableView Methods -

extension EditProfileViewC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.signUpViewModel?.arrSignUpStepOne.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.signUpViewModel.arrSignUpStepOne[indexPath.row]

        switch model.type {
        case AppConstants.Checkbox,AppConstants.Multiselect,AppConstants.Select:

            if (model.type == AppConstants.Checkbox) && ((model.multipleOption == true)){
                return self.getSignUpMultiCheckboxTableCell(indexPath)
            }
            else{
                return self.getEditProfileSelectTableCell(indexPath)
            }
        case AppConstants.Text:
            return self.getEditProfileTextViewTableCell(indexPath)
        case AppConstants.Radio:
            return self.getSignUpRadioTableCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let model = self.signUpViewModel.arrSignUpStepOne[indexPath.row]

        switch model.type {
        case AppConstants.Select:

            if kSharedInstance.signUpStepTwoOptionsModel == nil{

                if (model.isHidden == false) || (model.parentId?.isEmpty == false){
                    // return 110.0
                    return 115.0
                }
                else{
                    return 0.0
                }
            }
            else{

                let parentIdArray = self.signUpViewModel.arrSignUpStepOne.map({$0.parentId})
                var selectedIndex: [Int?] = []

                for i in 0..<kSharedInstance.signUpStepTwoOptionsModel.count{

                    let firstIndex = parentIdArray.firstIndex(where: {$0 == kSharedInstance.signUpStepTwoOptionsModel[i].userFieldOptionId})
                    selectedIndex.append(firstIndex)
                }
                print("indexs",selectedIndex)

                if selectedIndex.contains(indexPath.row) || model.parentId?.isEmpty == true{
                    model.isHidden = false
                    // return 110.0
                    return 115.0
                }
                else{
                    model.isHidden = true
                    return 0.0
                }
            }
        case AppConstants.Multiselect,AppConstants.Checkbox:
            return 80.0
        case AppConstants.Text:
            return 230.0
        case AppConstants.Radio:
            //return 130.0
            return 100.0
        default:
            return 0.0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = self.signUpViewModel.arrSignUpStepOne[indexPath.row]

        switch model.type {
        case AppConstants.Checkbox:
            if model.multipleOption == false{
                let controller = pushViewController(withName: SelectProductViewC.id(), fromStoryboard: StoryBoardConstants.kLogin) as? SelectProductViewC
                controller?.signUpStepOneDataModel = model
                controller?.stepOneDelegate = self
            }
        case AppConstants.Multiselect:
            let controller = pushViewController(withName: SelectProductViewC.id(), fromStoryboard: StoryBoardConstants.kLogin) as? SelectProductViewC
            controller?.signUpStepOneDataModel = model
            controller?.stepOneDelegate = self
        case AppConstants.Select:
            self.openPicker(withArray: model.arrOptions.map({String.getString($0.optionName)}), model: model, keyValue: nil)
        default:
            break
        }
    }
}

//MARK: - ImagePickerViewDelegate Methods -

extension EditProfileViewC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.dismiss(animated: true) {

            if self.btnProfilePhoto.isSelected == true{
                self.isProfilePhotoCaptured = true
                self.imgViewProfile.image = selectedImage
            }
            else{
                self.isCoverPhotoCaptured = true
                self.imgViewCoverPhoto.image = selectedImage
            }
        }
    }
}

//APIResponse
extension EditProfileViewC{

    override func didUserGetData(from result: Any, type: Int) -> Void{

        //kSharedUserDefaults.avatarId =
        showAlert(withMessage: AlertMessage.kProfileUpdated){
            self.navigationController?.popViewController(animated: true)
        }
    }
}


//RadioCell
extension EditProfileViewC: TappedSwitch{

    func tapSwitch(_ model: SignUpStepTwoDataModel?, _ stepOneModel: SignUpStepOneDataModel?, switchAnswer: UISwitch, btn: UIButton, currentTapType: Int?) {

        switch currentTapType {
        case 0:
            stepOneModel?.selectedValue = (switchAnswer.isOn == true) ?   AppConstants.Yes.capitalized : AppConstants.No
            self.tableViewEditProfile.reloadData()
        case 1:
            showAlert(withMessage: String.getString(stepOneModel?.hint))
        default:
            break
        }
    }
}

//TappedDone
extension EditProfileViewC: TappedDoneStepOne{

    func tapDone(_ signUpStepOneDataModel: SignUpStepOneDataModel) {

        self.signUpStepOneDataModel = nil
        self.signUpStepOneDataModel = signUpStepOneDataModel
        signUpStepOneDataModel.selectedValue = self.createStringForProducts(signUpStepOneDataModel)
        self.navigationController?.popViewController(animated: true)
        self.tableViewEditProfile.reloadData()
    }
}

//CheckboxCell
extension EditProfileViewC: SignUpMultiSelectDelegate{

    func tappedCheckBox(collectionView: UICollectionView, signUpStepTwoOptionsModel: SignUpStepTwoOptionsModel?, signUpStepTwoDataModel: SignUpStepTwoDataModel?, signUpStepOneDataModel: SignUpStepOneDataModel?, btn: UIButton, cell: SignUpMultiCheckboxTableCell) {


        if btn == cell.btnInfo{

            showAlert(withMessage: String.getString(signUpStepTwoDataModel?.hint))
        }
        else{

            signUpStepTwoOptionsModel?.isSelected = (signUpStepTwoOptionsModel?.isSelected == true) ? false : true
            collectionView.reloadData()

            kSharedInstance.signUpStepTwoOptionsModel = signUpStepOneDataModel?.arrRestaurantOptions.filter({$0.isSelected == true})

            var selectedOptionId:[String] = []
            for i in 0..<kSharedInstance.signUpStepTwoOptionsModel.count{
                selectedOptionId.append(String.getString(signUpStepOneDataModel?.arrRestaurantOptions[i].userFieldOptionId))
            }
            signUpStepOneDataModel?.selectedValue = selectedOptionId.joined(separator: ", ")
        }
        self.tableViewEditProfile.reloadData()
    }
}


extension RangeReplaceableCollection where Element: Hashable {

    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}

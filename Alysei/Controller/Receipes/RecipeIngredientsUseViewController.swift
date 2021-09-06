//
//  RecipeIngredientsUseViewController.swift
//  Alysei Recipe Module
//
//  Created by mac on 06/08/21.
//

import UIKit
var selectStepJson: [[String: Any]] = []

var strIngridientQuantity = String()
var strIngridientId = Int()
var finalUnitIngridirnt: String?
var finalquantityIngridirnt: Int?

var strToolQuantity = String()
var strToolId = Int()
var finalquantityTool: Int?
var finalUnitTool: String?

var strTitle : String?
var strDescription : String?
var ingridientArray:Int?
var toolArray : Int?

class RecipeIngredientsUseViewController: AlysieBaseViewC,UITableViewDelegate,UITableViewDataSource, RecipeIngredientsUsedTableViewCellProtocol, NumberOfStepsDelegateProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var addEditPopUpView: UIView!
    
    @IBOutlet weak var addEditQuantityView: UIView!
    @IBOutlet weak var editquantityLabel: UILabel!
    
    @IBOutlet weak var addEditUnitView: UIView!
    
    @IBOutlet weak var editunitLabel: UILabel!
    @IBOutlet weak var btnEditSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var storeRecipeParams = [[String:Any]]()
    var arraySelectedIngridient: [String] = []
    var header = ["Ingredients","Utencils,Appliances & Tools","Recipe Steps"]
    var array1 = NSMutableArray()
    var array2 = NSMutableArray()

    var toolBar = UIToolbar()
    var picker1  = UIPickerView()
    var strReturn = String()
    var strReturn1 = String()
    var arrQuantity = NSMutableArray()
    var arrUnit = NSMutableArray()
    var arraySelectedItem: [IndexPath] = []
    var arraySelectedItemIngridient: [IndexPath] = []
    var arraySelectedItemTool: [IndexPath] = []
    var selectedIndexPath : IndexPath?
    var footerView = UIView()
    var dunamicButton  = UIButton()

    @IBOutlet weak var headerLabelLeading: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 5
        btnEditSave.layer.cornerRadius = 5
        self.addEditPopUpView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        picker1.delegate = self
        picker1.dataSource = self
        
        arrQuantity = ["1", "2"]
        arrUnit = ["Kg", "Piece"]
        array1 = ["Produce", "Pantry"]
        array2 = ["2", "2"]
        
        if arrayStepFinalData.count == 0 {
            self.btnBack.isHidden = false
        }
        else{
            self.btnBack.isHidden = true
            self.headerLabelLeading.constant = 0
        }
         
        
        tableView.register(UINib(nibName: "RecipeIngredientsUsedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeIngredientsUsedTableViewCell")
        tableView.register(UINib(nibName: "NumberofStepsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        //self.heightTableView.constant = CGFloat(70 * (arrlbl1[0][1].count))
        self.tableView.reloadData()
        self.setFooterView()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func setFooterView(){
        
        footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.tableView.frame.width,
                                              height: 50))
        
        footerView.backgroundColor = .white
        dunamicButton  = UIButton(type: .custom)
        dunamicButton.layer.borderWidth = 1
        dunamicButton.layer.cornerRadius = 5
        dunamicButton.layer.borderColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha: 1).cgColor
        dunamicButton.frame = CGRect(x: 15, y: 0, width: (self.view.frame.size.width-30), height: 48)
        dunamicButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        dunamicButton.setImage(UIImage(named: "Group 1127.png"), for: .normal)
        dunamicButton.setTitleColor(UIColor.black, for: .normal)
        footerView.addSubview(dunamicButton)
    }
    func setPickerToolbar(){
        
        picker1.backgroundColor = UIColor.white
        picker1.setValue(UIColor.black, forKey: "textColor")
        picker1.autoresizingMask = .flexibleWidth
        picker1.contentMode = .center
        picker1.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker1)
        picker1.reloadAllComponents()

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 40))
        toolBar.barTintColor = AppColors.mediumBlue.color
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
       
    
       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onDoneButtonTapped))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
       let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onCancelButtonTapped))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        self.view.addSubview(toolBar)
        
            }
    
    @objc func onDoneButtonTapped() {
        
        switch picker1.tag {
        case 1:
            self.editquantityLabel.text = strReturn1
            toolBar.removeFromSuperview()
            picker1.removeFromSuperview()
          
        case 2:
            self.editunitLabel.text = strReturn
            toolBar.removeFromSuperview()
            picker1.removeFromSuperview()
            
        default:
            break
        }
       
    }
    
    @objc func onCancelButtonTapped() {
        
        toolBar.removeFromSuperview()
        picker1.removeFromSuperview()

       }
    
    
    @objc func addExtraIngridients(sender:AnyObject){
        var isVcPresent = false
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
                    if controller.isKind(of: AddIngredientsViewController.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
        if !isVcPresent{
            pushViewController(withName: AddToolsViewController.id(), fromStoryboard: StoryBoardConstants.kRecipesSelection)
        }

        
    }
    
    @objc func addExtraTools(sender:AnyObject){
        var isVcPresent = false
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: AddToolsViewController.self) {
                isVcPresent = true
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
        if !isVcPresent{
            pushViewController(withName: AddToolsViewController.id(), fromStoryboard: StoryBoardConstants.kRecipesSelection)
        }
    }
    
    @objc func addExtraRecipeSteps(sender:AnyObject){

        var isVcPresent = false
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
            if controller.isKind(of: AddStepsViewController.self) {
                isVcPresent = true
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
        if !isVcPresent{
            let addSteps = self.storyboard?.instantiateViewController(withIdentifier: "AddStepsViewController") as! AddStepsViewController
            addSteps.arrayIngridients = selectedIngridentsArray
            addSteps.arraytools = selectedToolsArray
            addSteps.page = 1
            self.navigationController?.pushViewController(addSteps, animated: true)
        }

        
    }
    
    @IBAction func tapForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapForEditQuantity(_ sender: Any) {
        
        picker1.tag = 1
        picker1.reloadAllComponents()
        setPickerToolbar()
    }
    
    @IBAction func tapForEditUnit(_ sender: Any) {
        picker1.tag = 2
        picker1.reloadAllComponents()
        setPickerToolbar()
    }
    
    @IBAction func tapForCloseEdit(_ sender: Any) {
        self.addEditPopUpView.isHidden = true
        
    }
    @IBAction func tapForSaveEditQuantity(_ sender: Any) {
        
        if self.editquantityLabel.text == "0"{
            self.addEditPopUpView.isHidden = false
            self.saveButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else{
            self.addEditPopUpView.isHidden = true
            let cell = tableView.cellForRow(at: selectedIndexPath!) as! RecipeIngredientsUsedTableViewCell
            cell.IngredientsValueLbl.text = self.strReturn1 + " " + self.strReturn
            self.saveButton.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
        }
    }
    
    @IBAction func tapForSaveRecipe(_ sender: Any) {
        
        postRequestToSaveRecipe()
        let discoverRecipeVC = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverRecipeViewController") as! DiscoverRecipeViewController
        discoverRecipeVC.checkbutton = 2
//        if discoverRecipeVC.checkbutton == 2{
//                    discoverRecipeVC.exploreHighlightView.backgroundColor = .clear
//                    discoverRecipeVC.favouriteHighlightView.backgroundColor = .clear
//                    discoverRecipeVC.myRecipeHighlightView.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
//        }
//        discoverRecipeVC.containerTableVw.reloadData()

        self.navigationController?.pushViewController(discoverRecipeVC, animated: true)
    }
    
    func tapForEditIngridient(indexPath: IndexPath){

            selectedIndexPath = indexPath
        self.addEditPopUpView.isHidden = false

       }
        
    func tapForDeleteIngridient(indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedIngridentsArray.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            selectedToolsArray.remove(at: indexPath.row)
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .left)
        self.tableView.reloadData()
        tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectedIngridentsArray.count
        }
        else if section == 1 {
            return selectedToolsArray.count
        }
        else if section == 2 {
            return arrayStepFinalData.count
        }
       return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70 //CGFloat(70 * (arrlbl1.count))
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return header[section]
        
    }
    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        
    
        switch (section) {
        
        
        case 0:
            setFooterView()
            dunamicButton.setTitle("  Add Ingredients in Recipe", for: UIControl.State.normal)
            dunamicButton.addTarget(self, action: #selector(addExtraIngridients(sender:)), for: .touchUpInside)
            
            
        case 1:
            setFooterView()
            dunamicButton.setTitle("  Add Tools in Recipe", for: UIControl.State.normal)
            dunamicButton.addTarget(self, action: #selector(addExtraTools(sender:)), for: .touchUpInside)
            
            
            
        case 2:
//            if arrayStepFinalData.count == 0{
//                setFooterView()
//                dunamicButton.setTitle("  Add Steps in Recipe", for: UIControl.State.normal)
//                dunamicButton.addTarget(self, action: #selector(addExtraRecipeSteps(sender:)), for: .touchUpInside)
//            }
//            else{
                setFooterView()
                footerView.isHidden = true
//             }
            
        default:
            break
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientsUsedTableViewCell") as! RecipeIngredientsUsedTableViewCell
        var cell2 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! NumberofStepsTableViewCell
        
        switch indexPath.section    {
    
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientsUsedTableViewCell") as! RecipeIngredientsUsedTableViewCell
           
            
            cell.indexPath = indexPath
            cell.editIngridientDelegate = self
            cell.deleteIngridientDelegate = self
            if selectedIngridentsArray.count > indexPath.row {
                strIngridientId = selectedIngridentsArray[indexPath.row].recipeIngredientIds ?? 0
                finalUnitIngridirnt = selectedIngridentsArray[indexPath.row].unit ?? ""
                finalquantityIngridirnt = selectedIngridentsArray[indexPath.row].quantity ?? 0
                cell.IngredientsNameLbl.text = selectedIngridentsArray[indexPath.row].ingridientTitle
                strIngridientQuantity = selectedIngridentsArray[indexPath.row].pickerData ?? ""
                cell.IngredientsValueLbl.text = strIngridientQuantity
                let imgUrl = (kImageBaseUrl + (selectedIngridentsArray[indexPath.row].imageId?.imgUrl ?? ""))
                cell.img.setImage(withString: imgUrl)
                cell.indexPath = indexPath
                return cell
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientsUsedTableViewCell") as! RecipeIngredientsUsedTableViewCell
            cell.indexPath = indexPath
            cell.editIngridientDelegate = self
            cell.deleteIngridientDelegate = self
            strToolId = selectedToolsArray[indexPath.row].recipeToolIds ?? 0
            finalUnitTool = selectedToolsArray[indexPath.row].unit ?? ""
            finalquantityTool = selectedToolsArray[indexPath.row].quantity ?? 0
            cell.IngredientsNameLbl.text = selectedToolsArray[indexPath.row].toolTitle
            strToolQuantity = selectedToolsArray[indexPath.row].pickerData ?? ""
            cell.IngredientsValueLbl.text = strToolQuantity
           
            let imgUrl = (kImageBaseUrl + (selectedToolsArray[indexPath.row].imageId?.imgUrl ?? ""))
            cell.img.setImage(withString: imgUrl)
            cell.indexPath = indexPath
            return cell

        case 2:
            cell2 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! NumberofStepsTableViewCell
            strTitle = arrayStepFinalData[indexPath.row].title
            strDescription = arrayStepFinalData[indexPath.row].description
            ingridientArray = arrayStepFinalData[indexPath.row].ingridentsArray?[indexPath.row].recipeIngredientIds
            toolArray = arrayStepFinalData[indexPath.row].toolsArray?[indexPath.row].recipeToolIds
            cell2.titleLabel.text = strTitle
            cell2.stepTitle.text = "Step \(indexPath.row + 1)"
            cell2.numberOfStepsDelegateProtocol = self
            cell2.indexPath = indexPath
            return cell2
            
            
        default:
            break
            
        }
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func editClickSteps(index: IndexPath) {
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStepsViewController") as! AddStepsViewController
        editVC.selectedIndex = index.row
        editVC.page = (index.row + 1)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
//    func deleteClickSteps(index: IndexPath){
//        
//    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RecipeIngredientsUseViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch picker1.tag {
        case 1:
            
            return self.arrQuantity.count

        case 2:

        return self.arrUnit.count
            

        default:

        break

        }
     return 0
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var str_return : String = String ()
    
        switch picker1.tag {
        
        case 1:

            if let stName = self.arrQuantity.object(at: row) as? String
         {
                str_return = stName
         }

        case 2:

            if let stName = self.arrUnit.object(at: row) as? String
         {
             str_return = stName
         }

        default: break

        }
      return str_return
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        var strSelectedId = String()
        switch picker1.tag {
        
        case 1:
            
            if row == 0
            {
                self.strReturn1 = self.arrQuantity[0] as! String
                 
            }
            if row == 1
            {
                self.strReturn1 = self.arrQuantity[1] as! String
                 
            }
        
        case 2:
            if row == 0{
                self.strReturn = self.arrUnit[0] as! String
            }
            if row == 1
            {
                self.strReturn = self.arrUnit[1] as! String
                 
            }
      
        default:
            break
        }
    }
}
extension RecipeIngredientsUseViewController{
    
    func postRequestToSaveRecipe(){
        
        let imageId = createRecipeJson["recipeImage"] as? String
        let name = createRecipeJson["name"]
        let mealId = createRecipeJson["mealId"]
        let courseId = createRecipeJson["courseId"]
        let cousinId = createRecipeJson["cusineId"]
        let regionId = createRecipeJson["regionId"]
        let dietId = createRecipeJson["dietId"]
        let foodIntoleranceId = createRecipeJson["foodIntoleranceId"]
        let cookingSkillId = createRecipeJson["cookingSkillId"]
        let hour = createRecipeJson["hour"]
        let minute = createRecipeJson["minute"]
        let serving = createRecipeJson["serving"]
       
        let params: [String:Any] = [APIConstants.kImageId: imageId!, APIConstants.kName: name!, APIConstants.kMealId: mealId!, APIConstants.kCourseId: courseId!, APIConstants.kHours: hour!, APIConstants.kminutes: minute!, APIConstants.kServing: serving!, APIConstants.kCousinId: cousinId!, APIConstants.kRegionId: regionId!, APIConstants.kDietId: dietId!, APIConstants.kIntoleranceId: foodIntoleranceId!, APIConstants.kCookingSkillId: cookingSkillId!,APIConstants.kSavedIngridient: [[APIConstants.kIngridientId: strIngridientId, APIConstants.kQuantity: finalquantityIngridirnt!, APIConstants.kUnit: finalUnitIngridirnt!]],APIConstants.kSavedTools: [[APIConstants.kToolId: strToolId, APIConstants.kQuantity: finalquantityTool!, APIConstants.kUnit: finalUnitTool!]], APIConstants.kRecipeStep: [[APIConstants.kTitle: strTitle ?? "", APIConstants.kDescription: strDescription!, APIConstants.kIngridients: [ingridientArray], APIConstants.kTools: [toolArray]]]]

        let paramsMain: [String: Any] = ["params": params]
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.Recipes.saveRecipe, requestMethod: .POST, requestParameters: paramsMain, withProgressHUD: true){ (dictResponse, error, errorType, statusCode) in
             let resultNew = dictResponse as? [String:Any]
            if let message = resultNew!["message"] as? String{
                self.showAlert(withMessage: message)
            }
            
           
//                let controller = self.pushViewController(withName: DiscoverRecipeViewController.id(), fromStoryboard: StoryBoardConstants.kRecipesSelection) as? DiscoverRecipeViewController
          
          
//                controller?..reloadData()
//                controller?.storeName = self.txtStoreName.text
//                controller?.marketPlaceStoreId = self.marketPlaceId
        }
    }

    
}

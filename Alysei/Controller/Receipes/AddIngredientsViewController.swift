//
//  AddIngredientsViewController.swift
//  Alysei Recipe Module
//
//  Created by mac on 28/07/21.
//

import UIKit
import Foundation

var selectIngridientJson: [String : [IngridentArray]] = [:]
var selectedIngridientJson: [String : Any] = [:]
var selectedIngridentsArray = [IngridentArray()]

class AddIngredientsViewController: UIViewController, AddIngridientsTableViewCellProtocol {
    @IBOutlet weak var addIngredientsView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveAndProceedTabBar: UIView!
    
    @IBOutlet weak var addMissingIngridientsButton: UIButton!
    @IBOutlet weak var addIngridientsTableView: UITableView!
    @IBOutlet weak var viewAddMissingIngridient: UIView!
    
    @IBOutlet weak var addMissingIngridientsTableView: UITableView!
    
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var addIndridentPopupView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var addsaveButton: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var unitLabel: UILabel!

    @IBOutlet weak var addNewMissingIngridientBtn: UIButton!
    
    var newSearchModel: [AddIngridientDataModel]? = []
    var addMissingIngridientModel: [IngridentTypeDataModel]? = []
    var arraySelectedItem: [IndexPath] = []
    var arrayPickerData: [String] = []
    var selectedIndexPath : IndexPath?
    var selectedIndexPath1 : IndexPath?
    var toolBar = UIToolbar()
    var picker1  = UIPickerView()
    var strReturn = String()
    var strReturn1 = Int()
    var arrQuantity = NSMutableArray()
    var arrUnit = NSMutableArray()
    var arrayFinal: [String] = []
    
    var strIngridientQuantity = Int()
    var strIngridientUnit = String()
    var strIngridientId = Int()
    

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        addIngridientsTableView.reloadData()
        self.quantityLabel.text = "\(arraySelectedItem.count) Items"
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker1.delegate = self
        picker1.dataSource = self
        self.addNewMissingIngridientBtn.isHidden = true
       arrQuantity = [1, 2]
         arrUnit = ["Kg", "Piece"]
        setupUI()
        
        callAddIngridients()
        //callListIngridients()
      
        
        self.viewAddMissingIngridient.isHidden = true
        self.addIndridentPopupView.isHidden = true
        self.setUI()
        self.addIngridientsTableView.delegate = self
        self.addIngridientsTableView.dataSource = self
        
        self.addMissingIngridientsTableView.delegate = self
        self.addMissingIngridientsTableView.dataSource = self
        

    }
    
    
    func setUI(){
        
        addIngredientsView.layer.masksToBounds = false
        addIngredientsView.layer.shadowRadius = 2
        addIngredientsView.layer.shadowOpacity = 0.2
        addIngredientsView.layer.shadowColor = UIColor.lightGray.cgColor
        addIngredientsView.layer.shadowOffset = CGSize(width: 0 , height:2)
        searchView.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        saveAndProceedTabBar.layer.masksToBounds = false
        saveAndProceedTabBar.layer.shadowRadius = 2
        saveAndProceedTabBar.layer.shadowOpacity = 0.8
        saveAndProceedTabBar.layer.shadowColor = UIColor.gray.cgColor
        saveAndProceedTabBar.layer.shadowOffset = CGSize(width: 0 , height:2)
        
        itemsButton.layer.borderWidth = 1
        itemsButton.layer.borderColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha: 1).cgColor
        itemsButton.layer.cornerRadius = 5
        quantityLabel.text = "0 Items"
      
    }
    

    
    func setupUI(){
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        quantityView.layer.cornerRadius = 5
        unitView.layer.borderWidth = 1
        unitView.layer.borderColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1).cgColor
        unitView.layer.cornerRadius = 5
        addsaveButton.layer.cornerRadius = 5
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
            self.quantityLbl.text = String(self.strReturn1)
            toolBar.removeFromSuperview()
            picker1.removeFromSuperview()
        case 2:
            self.unitLabel.text = self.strReturn
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
    
    @IBAction func tapQuantity(_ sender: Any) {
        picker1.tag = 1
        picker1.reloadAllComponents()
        setPickerToolbar()
    }
    
    @IBAction func tapUnit(_ sender: Any) {
        picker1.tag = 2
        picker1.reloadAllComponents()
        setPickerToolbar()
    }
    
    @IBAction func cancelingridentButton(_ sender: UIButton) {
        self.addIndridentPopupView.isHidden = true
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if self.quantityLbl.text == "0" || self.unitLabel.text == "Unit"{
            self.addIndridentPopupView.isHidden = false
            self.saveButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else{
            self.addIndridentPopupView.isHidden = true
            let quantity = self.strReturn1
            let unit = self.strReturn
            
            let pickerData = (String(quantity) + " " + unit)

            arrayPickerData.append(pickerData)
            arraySelectedItem.append(selectedIndexPath ?? IndexPath(row: sender.tag, section: 0))
            self.quantityLabel.text = "\(arraySelectedItem.count) Items"
            addIngridientsTableView.reloadData()
            self.saveButton.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
            selectedIngridentsArray.removeAll()
            for (indexPath,item) in arraySelectedItem.enumerated(){
              
                let valueIngridients: IngridentArray = (self.newSearchModel?[item.section].ingridents?[item.row])!
                print(valueIngridients)
                valueIngridients.quantity = quantity
                valueIngridients.unit = unit
                valueIngridients.pickerData = arrayPickerData[indexPath]
                selectedIngridentsArray.append(valueIngridients)
            }
        }
       
        
    }

    @IBAction func tapForShowItemDetails(_ sender: Any) {
        let recipeIngredients = self.storyboard?.instantiateViewController(withIdentifier: "RecipeIngredientsUseViewController") as! RecipeIngredientsUseViewController
        let selectedTools: [ToolsArray] = selectToolsJson["selected_tool"] ?? []
        recipeIngredients.arraySelectedItemTool = arraySelectedItem
        selectIngridientJson = ["selected_ingridient" : selectedIngridentsArray]
       
        self.navigationController?.pushViewController(recipeIngredients, animated: true)

    }
    @IBAction func saveAndProceedButton(_ sender: UIButton) {
        if quantityLabel.text != "0 Items"{
            let addtools =  self.storyboard?.instantiateViewController(withIdentifier: "AddToolsViewController") as! AddToolsViewController
            selectedIngridientJson = ["selectedQuantity" : strIngridientQuantity, "selectedUnit": strIngridientUnit, "selectedIngridientId" : strIngridientId]
          selectIngridientJson = ["selected_ingridient" : selectedIngridentsArray]
            self.navigationController?.pushViewController(addtools, animated: true)
        }
      
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        let cancelPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "CancelPopUpViewController") as! CancelPopUpViewController
        selectedIngridientJson = ["selectedQuantity" : strIngridientQuantity, "selectedUnit": strIngridientUnit, "selectedIngridientId" : strIngridientId]
        cancelPopUpVC.modalPresentationStyle = .overFullScreen
        cancelPopUpVC.modalTransitionStyle = .crossDissolve
        cancelPopUpVC.Callback = {
            let cancelPopVC = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverRecipeViewController") as! DiscoverRecipeViewController
            cancelPopVC.checkbutton = 2
            self.navigationController?.pushViewController(cancelPopVC, animated: true)
            
        }
        self.present(cancelPopUpVC, animated: true)
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = addIngridientsTableView.cellForRow(at: indexPath) as! AddIngridientsTableViewCell
        cell.selectImgView.image = nil
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func tapForAddMissingIngridients(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
       if sender.isSelected == false
       {
           self.addMissingIngridientsButton.setImage(UIImage.init(named: "MENU"), for: .normal)
        self.viewAddMissingIngridient.isHidden = true
       }
       else
       {
           self.addMissingIngridientsButton.setImage(UIImage.init(named: "5"), for: .normal)
        self.viewAddMissingIngridient.isHidden = false

       }
        
    }
    
    @IBAction func tapAddMainMissIngridient(_ sender: Any) {
        
        let addmissIngridient = self.storyboard?.instantiateViewController(withIdentifier: "AddMissingIngridientViewController") as! AddMissingIngridientViewController
        self.viewAddMissingIngridient.isHidden = true
        self.addMissingIngridientsButton.setImage(UIImage.init(named: "MENU"), for: .normal)
        self.addMissingIngridientsButton.isSelected = false
        self.navigationController?.pushViewController(addmissIngridient, animated: true)
    }
}

extension AddIngredientsViewController: UITableViewDelegate, UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        if tableView == addIngridientsTableView{
            return self.newSearchModel?.count ?? 0
        }
        if tableView == addMissingIngridientsTableView{
            return 1
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == addIngridientsTableView{
        return self.newSearchModel?[section].ingridientDataName
        }
        else{
            return ""
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == addIngridientsTableView{
            return self.newSearchModel?[section].ingridents?.count ?? 0
        }
        if tableView == addMissingIngridientsTableView{
            return self.addMissingIngridientModel?.count ?? 0
        }
        else{
            return 0
        }
       
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == addIngridientsTableView{
            let cell:AddIngridientsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddIngridientsTableViewCell") as! AddIngridientsTableViewCell
            
            cell.indexPath = indexPath
            
           
            cell.addIngridientDelegate = self

            let imgUrl = (kImageBaseUrl + (self.newSearchModel?[indexPath.section].ingridents?[indexPath.row].imageId?.imgUrl ?? ""))

            cell.ingridientsImageView.setImage(withString: imgUrl)
            strIngridientQuantity = self.newSearchModel?[indexPath.section].ingridents?[indexPath.row].quantity ?? 0
            strIngridientUnit = self.newSearchModel?[indexPath.section].ingridents?[indexPath.row].unit ?? ""
            strIngridientId = self.newSearchModel?[indexPath.section].ingridents?[indexPath.row].recipeIngredientIds ?? 0
            cell.ingredientsNameLabel.text = self.newSearchModel?[indexPath.section].ingridents?[indexPath.row].ingridientTitle
            cell.ingredientsNameLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
//            cell.ingridientsImageView.layer.cornerRadius = cell.ingridientsImageView.frame.height/2
            
            if arraySelectedItem.contains(indexPath){

                cell.selectImgView.isHidden = false

            } else {
                cell.selectImgView.isHidden = true
            }
            return cell
        }
        else{
            let cell:AddMissingIngridientTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddMissingIngridientTableViewCell") as! AddMissingIngridientTableViewCell
            cell.ingridientsTypeLabel.text = self.addMissingIngridientModel?[indexPath.row].ingridientType
            
            cell.ingridientsQuantityLabel.text = "\(self.addMissingIngridientModel?[indexPath.row].count ?? 0)"
            
            return cell
        }
       
    }

    func tapForIngridient(indexPath: IndexPath){
        let currentCell = addIngridientsTableView.cellForRow(at: indexPath) as! AddIngridientsTableViewCell
        
        if currentCell.selectImgView.isHidden == false{
            selectedIndexPath = indexPath
            self.addIndridentPopupView.isHidden = true
            currentCell.selectImgView.isHidden = true
            
            for (index,item) in arraySelectedItem.enumerated(){
                if item == indexPath{
                    arraySelectedItem.remove(at: index)
                    arrayPickerData.remove(at: index)
                }
            }
            
            self.quantityLabel.text = "\(arraySelectedItem.count) Items"
            
        }
        else{
            selectedIndexPath = indexPath
            self.addIndridentPopupView.isHidden = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == addIngridientsTableView{
            return 80
        }
        else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

      
        if tableView == addIngridientsTableView{
            return
        }
        else{
            self.addMissingIngridientsButton.setImage(UIImage.init(named: "MENU"), for: .normal)
            self.viewAddMissingIngridient.isHidden = true
            selectedIndexPath1 = indexPath

            print("\(String(describing: selectedIndexPath1))")
            self.addIngridientsTableView.scrollToRow(at: selectedIndexPath1!, at: .top, animated: true)

        }
    }
}

extension AddIngredientsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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

            if let stName = self.arrQuantity.object(at: row) as? Int
         {
                str_return = String(stName)
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
                self.strReturn1 = self.arrQuantity[0] as! Int
                 
            }
            if row == 1
            {
                self.strReturn1 = self.arrQuantity[1] as! Int
                 
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

extension AddIngredientsViewController{
    
    func callAddIngridients(){
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.Recipes.getrecipeIngridents, requestMethod: .GET, requestParameters: [:], withProgressHUD: true){ (dictResponse, error, errorType, statusCode) in
       
            let dictResponse = dictResponse as? [String:Any]
            
                if let data = dictResponse?["data"] as? [[String:Any]]{
                    self.newSearchModel = data.map({AddIngridientDataModel.init(with: $0)})
                    self.addIngridientsTableView.reloadData()
            }
            
            if let data = dictResponse?["types"] as? [[String:Any]]{
                self.addMissingIngridientModel = data.map({IngridentTypeDataModel.init(with: $0)})
                self.addMissingIngridientsTableView.reloadData()
            }
            
        }
    }
    
    /*func callListIngridients(){
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.Recipes.getrecipeIngridents, requestMethod: .GET, requestParameters: [:], withProgressHUD: true){ (dictResponse, error, errorType, statusCode) in
       
            let dictResponse = dictResponse as? [String:Any]
            
                if let data = dictResponse?["types"] as? [[String:Any]]{
                    self.addMissingIngridientModel = data.map({IngridentTypeDataModel.init(with: $0)})
                    self.addMissingIngridientsTableView.reloadData()
            }
        }
    }*/
}


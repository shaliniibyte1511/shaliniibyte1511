//
//  FilterViewController.swift
//  Alysei
//
//  Created by SHALINI YADAV on 8/4/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var subOptionTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var arrOption = ["Available for Sample","Category","Price Range"]
    var arrAlyseiBrandOption = ["Yes","No"]
    var arrPriceOption = ["0$-10$","10$-50$","50$-200$","200$-500$", "above <500"]
    var arrProductCategory: [MyStoreProductDetail]?
    var arrFilterOptions = [FilterModel]()
    var arrSubFilterSampleModel = [FilterModel]()
    var arrSubFilterPriceModel = [FilterModel]()
    var selectedCategoryProductId = [String]()
    var selectedProductName: String?
    var selectedSampleOption: String?
    var selectedStartPriceOption: String?
    var selectedEndPriceOption: String?
    var filterViewSelectedIndex: Int?
    //var selectedCategoryArr : Int?
    var selectedIndex = 0
    var loadingFirstTime = true
    var passDataCallBack: (([ProductSearchListModel]?) -> Void)? = nil
    var arrProductList: [ProductSearchListModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.addShadow()
        for option in arrOption {
            self.arrFilterOptions.append(FilterModel(name: option, isSelected: false))
        }
        for option in arrAlyseiBrandOption {
            self.arrSubFilterSampleModel.append(FilterModel(name: option, isSelected: false))
        }
        for option in arrPriceOption {
            self.arrSubFilterPriceModel.append(FilterModel(name: option, isSelected: false))
        }
        //optionTableView.layer.backgroundColor = UIColor.init(hexString: "#E8E8E8").cgColor
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clearFilters(_ sender: UIButton){

    }
    @IBAction func btnApplyFilter(_ sender: UIButton){
        callFilterApi()
        
      
        
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == optionTableView{
            return arrFilterOptions.count
        }else{
            switch selectedIndex {
            case 0:
                return arrSubFilterSampleModel.count
            case 1:
                return arrProductCategory?.count ?? 0
            default:
                return arrSubFilterPriceModel.count
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == optionTableView{
        guard let cell = optionTableView.dequeueReusableCell(withIdentifier: "FilterOptionTableVCell", for: indexPath) as? FilterOptionTableVCell else {return UITableViewCell()}
            if self.loadingFirstTime == true{
                arrFilterOptions[0].isSelected = true
            }
            cell.configCell(self.selectedIndex, arrFilterOptions[indexPath.row])
        return cell
        }else{
            guard let cell = subOptionTableView.dequeueReusableCell(withIdentifier: "FilterSubOptionsTableVCell", for: indexPath) as? FilterSubOptionsTableVCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            
                switch selectedIndex {
                case 0:
                    
                    cell.configCell(selectedIndex, arrSubFilterSampleModel[indexPath.row], MyStoreProductDetail(with: [:]))
                case 1:
                    cell.configCell(selectedIndex, FilterModel(name: "", isSelected: false), arrProductCategory?[indexPath.row] ?? MyStoreProductDetail(with: [:]))
                default:
                    cell.configCell(selectedIndex, arrSubFilterPriceModel[indexPath.row], MyStoreProductDetail(with: [:]))
                }
                
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == optionTableView {
        return 50
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == optionTableView{
            self.loadingFirstTime = false
            _ = self.arrFilterOptions.map{$0.isSelected = false}
            self.arrFilterOptions[indexPath.row].isSelected = true
            self.optionTableView.reloadData()
        
        self.selectedIndex = indexPath.row
            switch indexPath.row{
            case 0:
                print("\(indexPath.row)")
            case 1:
                print("\(indexPath.row)")
                self.callCategoryApi()
            case 2:
                print("\(indexPath.row)")
            default:
                print("Not Valid")
            }
       
        }else{
            switch self.selectedIndex {
            case 0:
                _ = arrSubFilterSampleModel.map({$0.isSelected = false})
                arrSubFilterSampleModel[indexPath.row].isSelected = true
                if indexPath.row == 0{
                self.selectedSampleOption =  "1"
                }else{
                    self.selectedSampleOption =  "0"
                }
            case 1:
                self.selectedCategoryProductId = [String]()
                if arrProductCategory?[indexPath.row].isSelected == true{
                    arrProductCategory?[indexPath.row].isSelected = false
                }else{
                    arrProductCategory?[indexPath.row].isSelected = true
                }
                
                for i in (0..<(arrProductCategory?.count ?? 0)) {
                    if arrProductCategory?[i].isSelected == true{
                        self.selectedCategoryProductId.append("\(arrProductCategory?[indexPath.row].marketplace_product_category_id ?? 0)")
                    }
                }
                
                
            case 2:
                _ = arrSubFilterPriceModel.map({$0.isSelected = false})
                arrSubFilterPriceModel[indexPath.row].isSelected = true
                switch indexPath.row {
                case 0:
                    self.selectedStartPriceOption = "0"
                    self.selectedEndPriceOption = "10"
                case 1:
                    self.selectedStartPriceOption = "10"
                    self.selectedEndPriceOption = "50"
                case 2:
                    self.selectedStartPriceOption = "50"
                    self.selectedEndPriceOption = "200"
                case 3:
                    self.selectedStartPriceOption = "200"
                    self.selectedEndPriceOption = "500"
                default:
                    self.selectedStartPriceOption = "500"
                    self.selectedEndPriceOption = ""
                }
            default:
                print("checking")
            }
           
        }
        self.subOptionTableView.reloadData()
    }
}


extension FilterViewController{
    func callCategoryApi(){
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kProductCategory, requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error , errorType, statusCode) in
            
            let response = dictResponse as? [String:Any]
            if let data = response?["data"] as? [[String:Any]]{
                self.arrProductCategory = data.map({MyStoreProductDetail.init(with: $0)})
            }
            self.subOptionTableView.reloadData()
        }
    }
    
    func callFilterApi(){
        

        let formattedArray = (selectedCategoryProductId.map{String($0)}).joined(separator: ",")
          
        let urlString = APIUrl.kProductListing + "\(selectedProductName ?? "")" + "&available_for_sample=" + "\(selectedSampleOption ?? "")" + "&sort_by=" + "" + "&category=" + "\(formattedArray)" + "&price_from=" + "\(selectedStartPriceOption ?? "")" + "&price_to=" + "\(selectedEndPriceOption ?? "")"
        let urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        TANetworkManager.sharedInstance.requestApi(withServiceName: urlString1, requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errorType, statusCode) in
            switch statusCode{
            case 200:
                let response = dictResponse as? [String:Any]
                if  let data = response?["data"] as? [[String:Any]]{
                    self.arrProductList = data.map({ProductSearchListModel.init(with: $0)})
                }
                self.passDataCallBack?(self.arrProductList)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                     self.navigationController?.popViewController(animated: true)
                }
            default:
                self.showAlert(withMessage: "No products found")
            }
        }
    }
}

  //  let Arr =  self.selectStateId?.components(separatedBy: ",")
   // controller?.passSelectOptionId = Arr ?? [""]}

class FilterModel {
    var name: String?
    var isSelected: Bool?
    
    
    init(name: String, isSelected: Bool){
        self.name = name
        self.isSelected = isSelected
    }
//
//    init(with data: [String:Any]?, isSelected: Bool){
//           self.is_active = Int.getInt(data?["is_active"])
//           self.name = String.getString(data?["name"])
//           self.isSelected = isSelected
//       }
}



//
//  HubsListVC.swift
//  Alysie
//
//

import UIKit

class HubsListVC: UIViewController {
    
    // MARK:- Objects
    @IBOutlet weak var tableView: HubsListTable!
    //@IBOutlet weak var collectionView: SelectHubStateList!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var bottomStackHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBottomStack: UIView!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    @IBOutlet weak var lblShowSelectedHub: UILabel!
    
    var city = [CountryHubs]()
    var country: CountryModel?
    var selectedHubs = [SelectdHubs]()
    var hubsViaCity:[HubsViaCity]?
    var hasCome:HasCome? = .hubs
    var roleId: String?
    var isEditHub: Bool?
    var isChckHubfirstEditSlcted = true
    var isChckCityfirstEditSlcted = true
    var totalHub: Int?
    var selectedHubCount: Int?
    
    var selectCountryId = ""
  
    // MARK:- lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addShadow()
        self.tableView.hasCome = self.hasCome
        self.tableView.country = self.country
        self.tableView.roleId = self.roleId
        self.tableView.passCallBack = {
            var selectedHubs = [CountryHubs]()
            for hub in self.hubsViaCity ?? [] {
                for subHub in hub.hubs_array ?? [] { if subHub.isSelected {selectedHubs.append(subHub)}}
            }
            let selectedHub = self.selectedHubs.first{$0.country.id == self.country?.id}
            selectedHub?.hubs = (selectedHub?.hubs.filter{$0.type == .city} ?? []) + selectedHubs
            self.setSelectedHubLabel(selectedHub?.hubs.count, totalHub: self.totalHub)
        }
        
        if self.hasCome == .initialCountry {
            self.lblHeading.text =  "Select Hubs"
            hideEyeIcon = self.hasCome != .initialCountry
            self.bottomStack.isHidden =  false
            self.viewBottomStack.isHidden = false
            self.bottomStackHeight.constant = 30
            self.bottomStack.backgroundColor = UIColor.init(hexString: "#1D4873")
            self.heightOfCollectionView.constant = 0
            self.callStateWiseHubListApi()
        }
 
//        switch self.hasCome {
//        case .initialCountry:
//        case .hubs:
//            self.callHubViewApi()
//        default:
//            self.postRequestToGetCity()
//        }
    }

    private func callHubViewApi(){
        let countryID = String.getString(country?.id)
        let cityID = kSharedInstance.getStringArray(self.city.map{$0.id})
        let params: [String:Any] = [ "params": [ countryID: cityID]]
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kgetHubs, requestMethod: .POST, requestParameters: params, withProgressHUD: true) { (dictResponse, error, errorType, statusCode) in
            let response = kSharedInstance.getDictionary(dictResponse)
            guard  let data = response["data"] as? [String:Any] else {return}
            let hubs = kSharedInstance.getArray(withDictionary: data["hubs"])
            
            let selectedHub = self.selectedHubs.first{$0.country.id == self.country?.id}
            let selectedCity = kSharedInstance.getStringArray(selectedHub?.hubs.map{$0.id})
            self.hubsViaCity = hubs.map{HubsViaCity(data: $0)}
            if self.isEditHub == false{
            for hub in self.hubsViaCity ?? [] {
                   _ = hub.hubs_array?.map{ $0.isSelected = selectedCity.contains($0.id ?? "")}
                }
            }else if  (self.isEditHub == true) && (self.isChckHubfirstEditSlcted == false) {
                for hub in self.hubsViaCity ?? [] {
                       _ = hub.hubs_array?.map{ $0.isSelected = selectedCity.contains($0.id ?? "")}
                    }
            }
              else{
                self.isChckHubfirstEditSlcted = false
                // self.isEditHub = false
                print("Check Remaining")
            }
            
            self.tableView.hubsViaCity = self.hubsViaCity
            //self.collectionView.hubsViaCity = self.hubsViaCity
        }
    }

    
    private func postRequestToGetCity() -> Void{
        let countryID = String.getString(country?.id)
        let cityID = kSharedInstance.getStringArray(self.city.map{$0.id})
        let param: [String:Any] = ["params": cityID]
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetHubCity, requestMethod: .POST, requestParameters: param, withProgressHUD: true) { (dictResponse, error, errortype, statusCode) in
            let response = kSharedInstance.getDictionary(dictResponse)
            guard  let data = response["data"] as? [String:Any] else {return}
            let hubs = kSharedInstance.getArray(withDictionary: data["cities"])
            let selectedHub = self.selectedHubs.first{$0.country.id == self.country?.id}
            let selectedCity = kSharedInstance.getStringArray(selectedHub?.hubs.map{$0.id})
            self.hubsViaCity = hubs.map{HubsViaCity(city: $0)}
//            for hub in self.hubsViaCity ?? [] {
//                _ = hub.hubs_array?.map{ $0.isSelected = selectedCity.contains($0.id ?? "")}
//            }
            if self.isEditHub == false{
                for hub in self.hubsViaCity ?? [] {
                    _ = hub.hubs_array?.map{ $0.isSelected = selectedCity.contains($0.id ?? "")}
                }
            }else if  (self.isEditHub == true) && (self.isChckCityfirstEditSlcted == false) {
                for hub in self.hubsViaCity ?? [] {
                    _ = hub.hubs_array?.map{ $0.isSelected = selectedCity.contains($0.id ?? "")}
                }
            }
              else{
                self.isChckCityfirstEditSlcted = false
                print("Check Remaining")
            }
            self.tableView.hubsViaCity = self.hubsViaCity
            //self.collectionView.hubsViaCity = self.hubsViaCity
        }
    }
    
    func callStateWiseHubListApi(){
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetStateWiseHub + "\(selectCountryId )", requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errorType, statusCode) in
            let response = dictResponse as? [String:Any]
            if let data = response?["data"] as? [String:Any]{
                let hubs = kSharedInstance.getArray(withDictionary: data["hubs"])
//                self.selectedHubCount = self.selectedHubs.first{$0.country.id == self.country?.id}?.hubs.count
                self.hubsViaCity = hubs.map{HubsViaCity(data: $0)}
               
            }
            for i in 0..<(self.hubsViaCity?.count ?? 0){
                self.totalHub = (self.totalHub ?? 0) + (self.hubsViaCity?[i].hubs_array?.count ?? 0)
            }
            self.setSelectedHubLabel(0, totalHub: self.totalHub)
            self.tableView.hasCome = .hubs
            self.tableView.hubsViaCity = self.hubsViaCity
        }
    }
    
    func setSelectedHubLabel(_ selectedHub: Int? , totalHub: Int?){
        lblShowSelectedHub.text = "\(selectedHub ?? 0)" + " " + "of" + " " + "\(totalHub ?? 0)" + " " + "hubs selected"
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        var selectedHubs = [CountryHubs]()
        for hub in self.hubsViaCity ?? [] {
            for subHub in hub.hubs_array ?? [] { if subHub.isSelected {selectedHubs.append(subHub)}}
        }
        let selectedHub = self.selectedHubs.first{$0.country.id == self.country?.id}
        selectedHub?.hubs = (selectedHub?.hubs.filter{$0.type == .hubs} ?? []) + selectedHubs
        //selectedHub?.hubs = (selectedHub?.hubs.filter{$0.type == .city} ?? []) + selectedHubs
        let oldHubs = selectedHub?.hubs.filter{$0.type != self.hasCome} ?? []
        selectedHub?.hubs = oldHubs +  selectedHubs
        if selectedHub?.hubs.isEmpty ?? false {
            showAlert(withMessage: "Please select atleast one hub")
        }else{
        let nextVC = ConfirmSelectionVC()
            nextVC.selectedHubs = self.selectedHubs
            nextVC.updatedHubs = { hubs in self.selectedHubs = hubs}
            
            nextVC.roleId = kSharedUserDefaults.loggedInUserModal.memberRoleId
            nextVC.isEditHub = self.isEditHub
            nextVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    @IBAction func clickHear(_ sender: UIButton) {
        var selectedHubs = [CountryHubs]()
        for hub in self.hubsViaCity ?? [] {
            for subHub in hub.hubs_array ?? [] { if subHub.isSelected {selectedHubs.append(subHub)}}
        }
        let selectedHub = self.selectedHubs.first{$0.country.id == self.country?.id}
        selectedHub?.hubs = (selectedHub?.hubs.filter{$0.type == .city} ?? []) + selectedHubs
        let nextvc = StateListVC()
        nextvc.country = self.country
        nextvc.selectedHubs = self.selectedHubs
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: UIButton){
     hideEyeIcon = true
        self.navigationController?.popViewController(animated: true)
    }
}
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

//
//  CountryListVC.swift
//  Alysie
//
//

import UIKit
enum HasCome {case initialCountry,showCountry,hubs,city }

class CountryListVC: AlysieBaseViewC , SelectList {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var tableVIew: CountryTableView!
    @IBOutlet weak var activeCountryCV: ActiveCollectionView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var heightOFBottom: NSLayoutConstraint!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var btnBackWidth: NSLayoutConstraint!
    @IBOutlet weak var activeInactiveView: UIView!

    
    var isEditHub : Bool?
    
    //MARK: - Properties -
    
    var hasCome:HasCome? = .initialCountry
    var countries:[CountryModel]?
    var selectedHubs = [SelectdHubs]()
    var roleId: String?
    var arrActiveUpcoming: ActiveUpcomingCountry?
    var addOrUpdate: Int?
    
    // MARK: - ViewLifeCycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addShadow()
        self.activeInactiveView.isHidden = false
        self.tableVIew.isHidden = true
        self.tableVIew.hascome = .showCountry
        self.activeCountryCV.hascome = .showCountry
        self.heightOFBottom.constant = hasCome == .showCountry ? 130 : 0
        self.backButton.isHidden = true
        self.btnBackWidth.constant = hasCome == .showCountry ? 0 : 40
        self.viewBottom.isHidden = hasCome != .showCountry
        //if roleId == "3"{
        if kSharedUserDefaults.loggedInUserModal.memberRoleId == "3" {
            labelHeading.text = "Where you want to export?"
        }else if (kSharedUserDefaults.loggedInUserModal.memberRoleId == "4" || kSharedUserDefaults.loggedInUserModal.memberRoleId == "5" || kSharedUserDefaults.loggedInUserModal.memberRoleId == "6"){
            labelHeading.text = "Where you import?"
        }else {
            labelHeading.text = "Loreum lore lreum reum um ruse"
        }
        if hasCome == .showCountry && (kSharedUserDefaults.loggedInUserModal.memberRoleId  == "6" || kSharedUserDefaults.loggedInUserModal.memberRoleId  == "9"){
            self.tableVIew.isUserInteractionEnabled = false
            self.activeCountryCV.isUserInteractionEnabled = false
        }else{
            self.tableVIew.isUserInteractionEnabled = true
            self.activeCountryCV.isUserInteractionEnabled = true
        }
        btnSelection.layer.borderWidth = 0.5
        btnSelection.layer.borderColor = UIColor.black.cgColor
        self.tableVIew.selectDelegate = self
        self.activeCountryCV.selectDelegate = self
        self.isEditHub == true ? self.requestToGetSelectedHubCountries() :  self.postRequestToGetCountries()
    }
    
    
    private func postRequestToGetCountries() -> Void{
        disableWindowInteraction()
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetUpcomingCountries, requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errortype, statusCode) in
            
            let dicResult = kSharedInstance.getDictionary(dictResponse)
            guard let data = dicResult["data"] as? [String:Any] else {return}
            self.arrActiveUpcoming = ActiveUpcomingCountry.init(data: data)
            let selectedHubsC = kSharedInstance.getStringArray(self.selectedHubs.map{$0.country.id})
            _ = self.arrActiveUpcoming?.arrActiveCountries.map{$0.isSelected = selectedHubsC.contains($0.id ?? "")}
            self.activeCountryCV.countries = self.arrActiveUpcoming?.arrActiveCountries
        }
    }
    private func requestToGetSelectedHubCountries() -> Void{
        disableWindowInteraction()
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetSelectedHubCountry, requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errortype, statusCode) in
            
            let dicResult = kSharedInstance.getDictionary(dictResponse)
            guard let data = dicResult["data"] as? [String:Any] else {return}
            self.arrActiveUpcoming = ActiveUpcomingCountry.init(data: data)
            let selectedHubsC = kSharedInstance.getStringArray(self.selectedHubs.map{$0.country.id})
            if self.isEditHub == false{
                _ = self.arrActiveUpcoming?.arrActiveCountries.map{$0.isSelected = selectedHubsC.contains($0.id ?? "")}
            }
            //                else if  (self.isEditHub == true) { //&& (self.isChckfirstEditSlcted == false) {
            //                    _ = self.arrActiveUpcoming?.arrActiveCountries.map{$0.isSelected = selectedHubsC.contains($0.id ?? "")}
            //                }
            else{
                // self.isChckfirstEditSlcted = false
                print("Check Remaining")
            }
            self.activeCountryCV.countries = self.arrActiveUpcoming?.arrActiveCountries
        }
    }
    
    
    //MARK:  - IBAction -
    
    @IBAction func viewSelection(_ sender: UIButton) {
        let nextvc = ConfirmSelectionVC()
        nextvc.selectedHubs = self.selectedHubs
        nextvc.updatedHubs = { hubs in self.selectedHubs = hubs;self.postRequestToGetCountries()}
        nextvc.roleId = kSharedUserDefaults.loggedInUserModal.memberRoleId
        nextvc.isEditHub = self.isEditHub
        nextvc.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(nextvc, animated: true)
    }
    
    @IBAction func proceedNext(_ sender: UIButton) {
        
        var allHubs = [CountryHubs]()
        for hub in self.selectedHubs {
            allHubs = allHubs + (hub.hubs )
        }
        if allHubs.isEmpty  && isEditHub != true {
            showAlert(withMessage: "Please select at least 1 hub to continue")
        }else{
            let selectedCity = allHubs.filter{$0.type == .city}
            let selectedHubs = allHubs.filter{$0.type == .hubs}
            let hubsID = selectedHubs.map{Int.getInt($0.id)}
            if self.isEditHub == true{
                self.addOrUpdate = 2
            }else{
                self.addOrUpdate = 1
            }
            let params = ["params":["add_or_update": self.addOrUpdate ?? 1,"selectedhubs":hubsID,"selectedcity":self.createCityJson(hubs: selectedCity)]] //add_or_update - 1: Save,2:Update
            print(params)
            disableWindowInteraction()
            TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kPostHub, requestMethod: .POST, requestParameters: params, withProgressHUD: true) { (dictResposne, error, errorType, statuscode) in
                kSharedAppDelegate.pushToTabBarViewC()
            }
        }
    }
    
    //MARK:  - WebService Methods -
    
    private func postRequestToPostHubs(_ params: [String:Any]) -> Void{
        disableWindowInteraction()
        CommonUtil.sharedInstance.postRequestToServer(url: APIUrl.kPostHub, method: .POST, controller: self, type: 0, param: params,btnTapped: UIButton())
    }
    
    func didSelectList(data: Any?, index: IndexPath) {
        guard let data = data as? CountryModel else {return}
        if self.hasCome == .showCountry && self.selectedHubs.first?.country.id != data.id {
            self.selectedHubs.removeAll()
        }
        let commmingHub = SelectdHubs.createHub(country: data)
        if checkDataIsFillOrNot(commmingHub: commmingHub) { return }
        let firstIndex = self.selectedHubs.first{$0.country.id == commmingHub.country.id}
        if firstIndex == nil {
            self.selectedHubs.append(SelectdHubs.createHub(country: data))
        }

        let nextVC = HubsListVC()
        //let nextVC = StateWiseHubListVC()
        nextVC.hasCome = self.hasCome
        nextVC.country = data
        nextVC.selectCountryId = String.getString(data.id)
        nextVC.selectedHubs = self.selectedHubs
        nextVC.isEditHub = self.isEditHub
        nextVC.roleId = kSharedUserDefaults.loggedInUserModal.memberRoleId
        enableWindowInteraction()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func didSelectReviewList(data: Any?, index: IndexPath, isEdithub: Bool){
        print(data,index)
    }
    func checkDataIsFillOrNot(commmingHub:SelectdHubs)->Bool {
        return  self.selectedHubs.first{$0.country.id == commmingHub.country.id} != nil && self.selectedHubs.first{$0.state.count != 0} != nil
    }
    
    
    func createCityJson(hubs:[CountryHubs]?)->[[String:Any]] {
        var params = [[String:Any]]()
        for hub in hubs ?? [] {
            var pm = [String:Any]()
            pm["country_id"] = hub.country_id
            pm["state_id"] = hub.state_id
            pm["city_id"] = hub.id
            params.append(pm)
        }
        return params
    }
}

extension UIView {
    
    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
    }
}

extension CountryListVC {
    
    override func didUserGetData(from result: Any, type: Int) {
        
        //        kSharedUserDefaults.setLoggedInUserDetails(loggedInUserDetails: dicResult)
        //        kSharedAppDelegate.pushToTabBarViewC()
        
    }
}

//
//  ConfirmSelectionVC.swift
//  Alysie
//
//

import UIKit
import SVProgressHUD

class ConfirmSelectionVC: UIViewController , SelectList{
    
    var selectedHubs = [SelectdHubs]()
    //var reviewSelectedHubs : ReviewHubModel.reviewHubModel?
    var reviewSelectedHubs : [ReviewSelectedHub]?
   // var reviewSelectedHubs :
    
    @IBOutlet weak var tableView: ConfirmSelectionTable!
    @IBOutlet weak var viewHeader: UIView!
    var updatedHubs:(([SelectdHubs])->())?
     var roleId: String?
    var isEditHub:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.addShadow()
        self.tableView.dataDelegate = self
        self.tableView.selectedHubs = selectedHubs
        self.tableView.roleId = self.roleId
        self.tableView.isEditHub = self.isEditHub
        if isEditHub == true{
            self.callReviewHubApi()
        }
    }
    
    func didSelectList(data: Any?, index: IndexPath) {
        guard let data = data as? SelectdHubs else {return}
        let nextVC = HubsListVC()
        nextVC.country = data.country
        nextVC.selectedHubs = self.selectedHubs
        nextVC.isEditHub = self.isEditHub
        nextVC.selectedHubs = self.selectedHubs
        nextVC.hasCome = .initialCountry
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func didSelectReviewList(data: Any?, index: IndexPath, isEdithub:Bool) {
        self.isEditHub = isEdithub
        guard let data = data as? ReviewSelectedHub else {return}
        let nextVC = StateListVC()
        nextVC.countryId = "\(data.country_id ?? 0)"
        nextVC.isEditHub = self.isEditHub
        //nextVC.selectedHubs = self.selectedHubs
        nextVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func proceedNext(_ sender: UIButton) {
        
        var allHubs = [CountryHubs]()
        var addOrUpdate = 0
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
                addOrUpdate = 2
            }else{
                addOrUpdate = 1
            }
            let params = ["params":["add_or_update": addOrUpdate,
                                    "selectedhubs":hubsID,
                                    "selectedcity":self.createCityJson(hubs: selectedCity)]]
            print(params)
            TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kPostHub, requestMethod: .POST, requestParameters: params, withProgressHUD: true) { (dictResposne, error, errorType, statuscode) in
                kSharedAppDelegate.pushToTabBarViewC()
            }
        }
    }
    
    @IBAction func nextVC(_ sender: UIButton) {
        if isEditHub == true{

        }else{
        if self.selectedHubs.isEmpty {
            showAlert(withMessage: "Please select at least 1 hub to continue"){
                self.updatedHubs?(self.selectedHubs)
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        self.updatedHubs?(self.selectedHubs)
        }
        self.navigationController?.popViewController(animated: true)
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

extension Array {
    func uniqueArray<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>()
        var arrayOrdered = [Element]()
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}

extension ConfirmSelectionVC {
    func callReviewHubApi(){
        TANetworkManager.sharedInstance.requestApi(withServiceName: "\(APIUrl.kReviewHub)", requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errortype, statuscode) in
            print("success")
            let response = dictResponse as? [String:Any]
            if let data = response?["data"] as? [[String:Any]]{
                
                let hubsArray = kSharedInstance.getArray(withDictionary: data)
                self.reviewSelectedHubs = hubsArray.map{ReviewSelectedHub(with: $0)}
                
        }
            print("wertyuihgfdszxcvbnm,nbcvxvbnm,---------\(self.reviewSelectedHubs ?? [ReviewSelectedHub]())")
            self.tableView.reviewSelectedHubs = self.reviewSelectedHubs
            self.tableView.reloadData()
    }
}
}


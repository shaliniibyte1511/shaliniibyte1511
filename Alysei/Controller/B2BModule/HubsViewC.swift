//
//  HubsViewC.swift
//  Alysei
//
//  Created by SHALINI YADAV on 5/25/21.
//

import UIKit

class HubsViewC: AlysieBaseViewC {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var hubName: UILabel!
    @IBOutlet weak var hubLocation: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    
    var arruserCount : [UserRoleCount]?
    var passHubId: String?
    var passHubName: String?
    var passHubLocation: String?
    var getRoleViewModel: GetRoleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hubName.text = passHubName
        hubLocation.text = passHubLocation
        lblSubHeading.text = "Join the \(passHubName ?? "") to expand your network and access the endless opportunity to discover the Italian cuisine through the Alysei community."
        callUserCountApi()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}

extension HubsViewC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = detailCollectionView.dequeueReusableCell(withReuseIdentifier: "HubCollectionViewCell", for: indexPath) as? HubCollectionViewCell else {return UICollectionViewCell()}
        cell.configData(indexPath.row, arruserCount?[indexPath.row] ?? UserRoleCount(with: [:]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let width = (kScreenWidth - 70.0)/3
      return CGSize(width: width, height: width + 32.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = pushViewController(withName: HubUserListVC.id(), fromStoryboard: StoryBoardConstants.kHome) as? HubUserListVC
        controller?.passHubId = self.passHubId
        controller?.passRoleId = "\(arruserCount?[indexPath.row].role_id ?? 0)"
        controller?.passUserTitle = arruserCount?[indexPath.row].name
        if arruserCount?[indexPath.row].role_id == UserRoles.restaurant.rawValue{
            controller?.currentIndex = B2BSearch.Restaurant.rawValue
        }else if arruserCount?[indexPath.row].role_id == UserRoles.producer.rawValue{
            controller?.currentIndex = B2BSearch.Producer.rawValue
        }else if arruserCount?[indexPath.row].role_id == UserRoles.distributer1.rawValue || arruserCount?[indexPath.row].role_id == UserRoles.distributer2.rawValue || arruserCount?[indexPath.row].role_id == UserRoles.distributer3.rawValue{
            controller?.currentIndex = B2BSearch.Importer.rawValue
        }else if arruserCount?[indexPath.row].role_id == UserRoles.voiceExperts.rawValue{
            controller?.currentIndex =  B2BSearch.Expert.rawValue
        }
       
        
    
    }
}

extension HubsViewC{
    func callUserCountApi(){
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetRolesUserCount + "\(passHubId ?? "")", requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errtype, statusCode) in
            let response = dictResponse as? [String:Any]
            
            if let data =  response?["data"] as? [[String:Any]]{
                self.arruserCount = data.map({UserRoleCount.init(with: $0)})
            }
            self.detailCollectionView.reloadData()
        }
    }
}


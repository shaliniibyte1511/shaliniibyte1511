//
//  MarketPlaceHomeVC.swift
//  Alysei
//
//  Created by SHALINI YADAV on 5/31/21.
//

import UIKit

class MarketPlaceHomeVC: AlysieBaseViewC {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var btnCreateStore: UIButton!
    @IBOutlet weak var marketplaceView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    var isCreateStore = false
    var productCount: Int?
    var storeCreated: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        callCheckIfStoredCreated()
        print("kSharedUserDefaults.loggedInUserModal.isStoreCreated----------------\(kSharedUserDefaults.loggedInUserModal.isStoreCreated ?? "")")
        if kSharedUserDefaults.loggedInUserModal.memberRoleId == "\(UserRoles.producer.rawValue)"{
            self.btnCreateStore.isHidden = false
        }else{
            self.btnCreateStore.isHidden = true
        }
        self.btnCreateStore.setTitleColor(UIColor.init(hexString: "#4BB3FD"), for: .normal)
        marketplaceView.backgroundColor = UIColor.init(hexString: "#4BB3FD")
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPost))
        self.postView.addGestureRecognizer(tap)
        
       
         
    }
    func setUI(){
        if  (self.storeCreated == 1) && (self.productCount ?? 0 >= 1){
            self.btnCreateStore.setTitle("Go to My Store", for: .normal)
        }else{
            self.btnCreateStore.setTitle("Create your Store", for: .normal)
        
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let vc = UIStoryboard(name: StoryBoardConstants.kMarketplace, bundle: nil).instantiateViewController(withIdentifier: "MarketPlaceHomeVC") as! MarketPlaceHomeVC
//
//        vc.view.frame = self.containerView.bounds
//        self.addChild(vc)
//        self.containerView.addSubview(vc.view)
//        vc.didMove(toParent: self)
//    }
    @objc func openPost(){
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnGotoStores(_ sender: UIButton){
        //self.callCheckIfStoredCreated()
        //if kSharedUserDefaults.loggedInUserModal.isStoreCreated == "0"{
            if self.storeCreated == 0{
        let vc = UIStoryboard(name: StoryBoardConstants.kMarketplace, bundle: nil).instantiateViewController(withIdentifier: "MarketPlaceWalkthroughVC") as! MarketPlaceWalkthroughVC

        vc.view.frame = self.containerView.bounds
        self.addChild(vc)
        self.containerView.addSubview(vc.view)
        vc.didMove(toParent: self)
            }else if self.storeCreated == 1 && self.productCount == 0{
                _ = pushViewController(withName: AddProductMarketplaceVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace) as? AddProductMarketplaceVC
            }else{
            _ = pushViewController(withName: MyStoreVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace) as? MyStoreVC
        }
      //  _ = pushViewController(withName: MyStoreVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace) as? MyStoreVC
    }

}

extension MarketPlaceHomeVC{
    func callCheckIfStoredCreated(){
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kCheckIfStored, requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errortype, statuscode) in
            let response = dictResponse as? [String:Any]
            
            self.storeCreated = response?["is_store_created"] as? Int
            self.productCount = response?["product_count"] as? Int
            self.setUI()
        }
    }
}

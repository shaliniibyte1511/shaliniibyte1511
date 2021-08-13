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
    @IBOutlet weak var subheaderView: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblDiscover: UILabel!
    
    var isCreateStore = false
    var productCount: Int?
    var storeCreated: Int?
    
    var marketPlaceOptions = ["marketplace_Store","icons8_wooden_beer_keg_1", "icons8_geography","icons8_sorting","icons8_property_script","icons8_certificate_1","Group 649","hot","icons8_popular"]
    var arrMarketPlace = ["Producer Store","Conservation Method","Italian Regions","Categories","Product Properties","FDA Certified","Product Name","Most Popular","Promotions"]
    //
    override func viewDidLoad() {
        super.viewDidLoad()
       // headerView.addShadow()
        subheaderView.addShadow()
        callCheckIfStoredCreated()
        print("kSharedUserDefaults.loggedInUserModal.isStoreCreated----------------\(kSharedUserDefaults.loggedInUserModal.isStoreCreated ?? "")")
        if kSharedUserDefaults.loggedInUserModal.memberRoleId == "\(UserRoles.producer.rawValue)"{
            self.btnCreateStore.isHidden = false
            self.lblDiscover.isHidden = true
        }else{
            self.btnCreateStore.isHidden = true
            self.lblDiscover.isHidden = false
        }
        self.btnCreateStore.setTitleColor(UIColor.init(hexString: "#4BB3FD"), for: .normal)
        marketplaceView.backgroundColor = UIColor.init(hexString: "#4BB3FD")
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPost))
        self.postView.addGestureRecognizer(tap)
        
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(openSearchView))
        self.viewSearch.addGestureRecognizer(searchTap)
         
    }
    func setUI(){
        if  (self.storeCreated == 1) && (self.productCount ?? 0 >= 1){
            self.btnCreateStore.setTitle("Go to My Store", for: .normal)
        }else{
            self.btnCreateStore.setTitle("Create your Store", for: .normal)
        
        }
    }
    @objc func openSearchView(){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "SearchProductVC") as? SearchProductVC else {return}
        self.navigationController?.pushViewController(nextVC, animated: true)
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
       // self.navigationController?.popViewController(animated: true)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
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
extension MarketPlaceHomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketPlaceHomeCollectionVCell", for: indexPath) as? MarketPlaceHomeCollectionVCell else {return UICollectionViewCell()}
        cell.imgView.image = UIImage(named: marketPlaceOptions[indexPath.row])
        cell.lblOption.text = "\(arrMarketPlace[indexPath.row])"
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 120)
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



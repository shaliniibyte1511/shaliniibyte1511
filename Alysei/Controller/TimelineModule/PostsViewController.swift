//
//  PostsViewController.swift
//  Alysei
//
//  Created by SHALINI YADAV on 4/26/21.
//

import UIKit

struct PostCommentsUserData {
    var userID: Int
    var postID: Int
}

class PostsViewController: AlysieBaseViewC {
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var marketplaceView: UIView!
    //@IBOutlet weak var postView: UIView!
    
    var scrollCallBack: (() -> Void)? = nil
    var newFeedModel: NewFeedSearchModel?
    var arrNewFeedDataModel = [NewFeedSearchDataModel]()
    var selectedPostId: Int?
    var likeUnlike: Int?
    var indexOfPageToRequest = 1
    var role: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // callNewFeedApi(pageNo)
        self.role = kSharedUserDefaults.loggedInUserModal.memberRoleId
            
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMarketPlace))
        self.marketplaceView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.role == "10" {
        if let viewController2 = self.tabBarController?.viewControllers?[1] {

            //viewController2.tabBarItem.image = UIImage(named: "b2btab1_icon")
            viewController2.tabBarItem.title = "Hubs"
           // viewController2.tabBarItem.isEnabled = false
            //viewController2.tabBarItem.selectedImage = UIImage(named: "turnoff_comments_icon")

        }
        }else{
            if let viewController2 = self.tabBarController?.viewControllers?[1] {

                //viewController2.tabBarItem.image = UIImage(named: "b2b_normal")
                viewController2.tabBarItem.title = "B2B"
               // viewController2.tabBarItem.isEnabled = true
               // viewController2.tabBarItem.selectedImage = UIImage(named: "b2b_active")
                
            }
        }
        arrNewFeedDataModel.removeAll()

        self.postTableView.separatorStyle = .singleLine
        callNewFeedApi(1)
    }


    //MARK:- segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePostsToComment" {
            if let model = sender as? PostCommentsUserData {
                if let viewCon = segue.destination as? PostCommentsViewController {
                    viewCon.postCommentsUserDataModel = model
                }
            }
        }
    }

    
    @objc func openMarketPlace(){
       // let vc = pushViewController(withName: MarketPlaceHomeVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace)
        guard let vc = UIStoryboard(name: StoryBoardConstants.kMarketplace, bundle: nil).instantiateViewController(identifier: "MarketPlaceHomeVC") as? MarketPlaceHomeVC else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = true
        //self.tabBarController?.tabBar.bounds.height = 0
    }
   
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // calculates where the user is in the y-axis
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height - (self.view.frame.height * 2) {
            if indexOfPageToRequest < newFeedModel?.lastPage ?? 0{
                print("No Data")
            }else{
            // increments the number of the page to request
            indexOfPageToRequest += 1

            // call your API for more data
            callNewFeedApi(indexOfPageToRequest)

            // tell the table view to reload with the new data
            self.postTableView.reloadData()
            }
        }
    }

    func showCommentScreen(_ model: PostCommentsUserData) {
        self.performSegue(withIdentifier: "seguePostsToComment", sender: model)
    }
}


extension PostsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        return 1
        }else{
            return arrNewFeedDataModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        guard let cell = postTableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell") as? DiscoverTableViewCell else{return UITableViewCell()}
            cell.selectionStyle = .none
        return cell
        }else{
            guard let cell = postTableView.dequeueReusableCell(withIdentifier: "PostDescTableViewCell") as? PostDescTableViewCell else{return UITableViewCell()}
            cell.selectionStyle = .none
            //TODO: this needs to be discussed with Shalini.
            if arrNewFeedDataModel.count > indexPath.row {
                cell.configCell(arrNewFeedDataModel[indexPath.row] , indexPath.row)
                let data = arrNewFeedDataModel[indexPath.row]
                cell.likeCallback = { index in
                    //self.postTableView.reloadRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                    cell.lblPostLikeCount.text = "\(data.likeCount ?? 0)"
                    cell.likeImage.image = data.likeFlag == 0 ? UIImage(named: "like_icon") : UIImage(named: "liked_icon")
                }

                cell.commentCallback = { postCommentsUserData in
                    self.showCommentScreen(postCommentsUserData)
                }

            }
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//        return 150
//        }else{
//            return UITableView.automaticDimension
//        }
   // }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == newFeedModel?.data?.count {
//            print("do something")
//            pageNo = pageNo + 1
//            self.callNewFeedApi(pageNo)
//        }
//    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 &&
//            indexPath.row == (arrNewFeedDataModel.count - 1) {
//            // Notify interested parties that end has been reached
//            print("do something")
//             pageNo = pageNo + 1
//             self.callNewFeedApi(pageNo)
//        }
//    }
    
}


extension PostsViewController {
    func callNewFeedApi(_ pageNo: Int?){
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.kGetFeed + "\(pageNo ?? 1)", requestMethod: .GET, requestParameters: [:], withProgressHUD: true) { (dictResponse, error, errorType, statusCode) in
            let dictResponse = dictResponse as? [String:Any]
            
            if let data = dictResponse?["data"] as? [String:Any]{
                self.newFeedModel = NewFeedSearchModel.init(with: data)
                if self.indexOfPageToRequest == 1 { self.arrNewFeedDataModel.removeAll() }
                self.arrNewFeedDataModel.append(contentsOf: self.newFeedModel?.data ?? [NewFeedSearchDataModel(with: [:])])
            }
           
            print("Count -------------------\(self.arrNewFeedDataModel.count)")
            DispatchQueue.main.async { self.postTableView.reloadData()}
            
        }
    }
   
}

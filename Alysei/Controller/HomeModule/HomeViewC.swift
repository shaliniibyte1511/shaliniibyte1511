//
//  HomeViewC.swift
//  Alysie
//
//  Created by CodeAegis on 23/01/21.
//

import UIKit

class HomeViewC: AlysieBaseViewC {
  
  //MARK: - IBOutlet -
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
  
  
  //MARK: - Properties -

    var fullScreenImageView = UIImageView()
  
  private lazy var membershipViewC: MembershipViewC = {

    let membershipViewC = UIStoryboard.init(name: StoryBoardConstants.kHome, bundle: nil).instantiateViewController(withIdentifier: MembershipViewC.id()) as! MembershipViewC
    return membershipViewC
  }()
    private lazy var postViewC: PostsViewController = {

      let postViewC = UIStoryboard.init(name: StoryBoardConstants.kHome, bundle: nil).instantiateViewController(withIdentifier: PostsViewController.id()) as! PostsViewController
      return postViewC
    }()
    
  
  //MARK: -  ViewLifeCycle Methods -
  
  override func viewDidLoad() {
    super.viewDidLoad()   
   // _ = membershipViewC
    fullScreenImageView.alpha = 0.0
    fullScreenImageView.isUserInteractionEnabled = false
    self.view.addSubview(fullScreenImageView)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        _ = self.postViewC
    }
    

  }
  
  //MARK:  - IBAction -
  
  @IBAction func tapNotification(_ sender: UIButton) {
    
    _ = pushViewController(withName: NotificationViewC.id(), fromStoryboard: StoryBoardConstants.kHome)
  }
    
   
    
}

extension HomeViewC{
  
  override func didUserGetData(from result: Any, type: Int) {
    

  }
}

//
//  MembershipViewC.swift
//  ScreenBuild
//
//  Created by Alendra Kumar on 20/01/21.
//

import UIKit

class MembershipViewC: AlysieBaseViewC {
    
  //MARK: - IBOutlet -
    
  @IBOutlet weak var tblViewMembership: UITableView!
  @IBOutlet weak var viewBlueHeading: UIView!
  
  //MARK: - Properties -
  
  var currentIndex: Int = 0

  //MARK:  - ViewLifeCycle Methods -
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.postRequestToGetProgress()
  }
  
  override func viewDidLayoutSubviews(){
    
    super.viewDidLayoutSubviews()
    self.viewBlueHeading.makeCornerRadius(radius: 5.0)
  }

  //MARK:  - IBAction -
  
  @IBAction func tapBack(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK:  - Private Methods -
  
  private func getMembershipTableCell(_ indexPath: IndexPath) -> UITableViewCell{
    
    let membershipTableCell = tblViewMembership.dequeueReusableCell(withIdentifier: MembershipTableCell.identifier()) as! MembershipTableCell
    membershipTableCell.delegate = self
    membershipTableCell.configure(indexPath, currentIndex: self.currentIndex)
    return membershipTableCell
  }
  
  //MARK:  - WebService Methods -
  
  private func postRequestToGetProgress() -> Void{
    
    disableWindowInteraction()
    CommonUtil.sharedInstance.postRequestToServer(url: APIUrl.kGetProgress, method: .GET, controller: self, type: 0, param: [:], btnTapped: UIButton())
  }
}

//MARK:  - TableViewMethods -

extension MembershipViewC: UITableViewDataSource, UITableViewDelegate{
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    StaticArrayData.kMembershipData.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return self.getMembershipTableCell(indexPath)
  }
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
}

extension MembershipViewC: AnimationCallBack{
  
  func animateViews(_ indexPath: Int, cell: MembershipTableCell) {
  
//    UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut,animations:{
//      cell.imgViewCircle.layer.backgroundColor = UIColor.white.cgColor
//      cell.imgViewCircle.layer.borderWidth = 1.0
//      cell.imgViewCircle.makeCornerRadius(radius: 15.0)
//      cell.imgViewCircle.layer.borderColor = AppColors.blue.color.cgColor
//    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
      cell.viewLine.layer.backgroundColor = AppColors.blue.color.cgColor
    }
    switch indexPath {
    case 0:
      self.currentIndex = 1
      UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut,animations:{
      cell.imgViewCircle.image = UIImage.init(named: "icon_bubble1")
      })
      self.tblViewMembership.reloadData()
    case 1:
      self.currentIndex = 2
      UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut,animations:{
      cell.imgViewCircle.image = UIImage.init(named: "ProfileCompletion3")
      })
      self.tblViewMembership.reloadData()
    case 2:
      self.currentIndex = 3
      UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut,animations:{
      cell.imgViewCircle.image = UIImage.init(named: "ProfileCompletion4")
      })
      self.tblViewMembership.reloadData()
    case 3:
      self.currentIndex = -1
      UIView.animate(withDuration: 1.0, delay: 0.0,options: .curveEaseInOut,animations:{
      cell.imgViewCircle.image = UIImage.init(named: "ProfileCompletion5")
      })
      self.tblViewMembership.reloadData()
    default:
      print("")
    }
  }
}

extension MembershipViewC{
  
  override func didUserGetData(from result: Any, type: Int) {
    
  }
  
}

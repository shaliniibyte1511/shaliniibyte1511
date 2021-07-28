//
//  NotificationViewC.swift
//  ScreenBuild
//
//  Created by Alendra Kumar on 21/01/21.
//

import UIKit

class NotificationViewC: AlysieBaseViewC{

  //MARK: - IBOutlet -
    
  @IBOutlet weak var tblViewNotification: UITableView!
  @IBOutlet weak var viewNavigation: UIView!
  
  //MARK:  - ViewLifeCycle Methods -
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tblViewNotification.tableFooterView = UIView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.viewNavigation.drawBottomShadow()
  }
  
  //MARK:  - IBAction -
  
  @IBAction func tapBack(_ sender: UIButton) {
    
    self.navigationController?.popViewController(animated: true)
  }
  
  //MARK:  - Private Methods -
  
  private func getNotificationTableCell() -> UITableViewCell{
    
    let notificationTableCell = tblViewNotification.dequeueReusableCell(withIdentifier: "NotificationTableCell") as! NotificationTableCell
    notificationTableCell.configure()
    return notificationTableCell
  }
}

//MARK:  - UITableViewMethods -

extension NotificationViewC: UITableViewDataSource, UITableViewDelegate{
        
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
        
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return self.getNotificationTableCell()
  }
        
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
        
}

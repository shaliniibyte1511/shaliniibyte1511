//
//  EditSetingTypeViewController.swift
//  Alysei
//
//  Created by Gitesh Dang on 07/04/21.
//

import UIKit

class EditSetingTypeViewController: AlysieBaseViewC {

    //MARK: @IBOutlet
    @IBOutlet weak var settingTypeCollectionView: UICollectionView!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var viewShadow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("modelRoleID--------------------------------\(kSharedUserDefaults.loggedInUserModal.memberRoleId ?? "")")
        self.viewShadow.drawBottomShadow()
    }
  
//    private func getSettingCollectionCell(_ indexPath: IndexPath) -> UICollectionViewCell{
//
//        guard let settingsTableCell = settingTypeCollectionView.dequeueReusableCell(withReuseIdentifier: EditSettingTypeCollectionViewCell.identifier(), for: indexPath) as? EditSettingTypeCollectionViewCell else {return UICollectionViewCell()}
//        settingsTableCell.configure(indexPath)
//      return settingsTableCell
//    }
    private func getSettingTableCell(_ indexPath: IndexPath) -> UITableViewCell{
        
        guard let settingsTableCell = settingTableView.dequeueReusableCell(withIdentifier: EditSettingTypeTableViewCell.identifier(), for: indexPath) as? EditSettingTypeTableViewCell else {return UITableViewCell()}
        settingsTableCell.selectionStyle = .none
        settingsTableCell.configure(indexPath)
      return settingsTableCell
    }
    @IBAction func tapBack(_ sender: UIButton) {
      
      self.navigationController?.popViewController(animated: true)
    }


}
//extension EditSetingTypeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //let roleID =  UserRoles(rawValue: "\(kSharedUserDefaults.loggedInUserModal.memberRoleId ?? "0")") ?? .voyagers
//        let roleID = UserRoles(rawValue: Int.getInt(kSharedUserDefaults.loggedInUserModal.memberRoleId ?? 0)) ?? .voyagers
//        if roleID == .voyagers {
//        return StaticArrayData.kEditSettingVoyColScreenDict.count
//        }else {
//            return StaticArrayData.kEditSettingUserColScreenDict.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return self.getSettingCollectionCell(indexPath)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            switch indexPath.row {
//            case 0:
//                _ = pushViewController(withName: EditUserSettingsViewC.id(), fromStoryboard: StoryBoardConstants.kHome) as! EditUserSettingsViewC
//            default:
//                print("HubSelection")
//                let nextVC = CountryListVC()
//                nextVC.hasCome = .showCountry
//                nextVC.isEditHub = true
//                nextVC.selectedHubs = []
//                self.navigationController?.pushViewController(nextVC, animated: true)
//            }
//       }
//}
//
//
//extension EditSetingTypeViewController: CHTCollectionViewDelegateWaterfallLayout {
//
//    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        if indexPath.item == 1 {
//            return CGSize(width: Int((view.bounds.width - 40)/3), height: 75)
//        }else{
//            return CGSize(width: Int((view.bounds.width - 40)/3), height: 76)
//        }
//
//    }
//}

//MARK: UITableViewCell
extension EditSetingTypeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let roleID = UserRoles(rawValue: Int.getInt(kSharedUserDefaults.loggedInUserModal.memberRoleId ?? 0)) ?? .voyagers
        if roleID == .voyagers {
        return StaticArrayData.kEditSettingVoyColScreenDict.count
        }else {
            return StaticArrayData.kEditSettingUserColScreenDict.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getSettingTableCell(indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            _ = pushViewController(withName: EditUserSettingsViewC.id(), fromStoryboard: StoryBoardConstants.kHome) as! EditUserSettingsViewC
        default:
            print("HubSelection")
            let nextVC = CountryListVC()
            nextVC.hasCome = .showCountry
            nextVC.isEditHub = true
            nextVC.selectedHubs = []
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

class EditSettingTypeTableViewCell: UITableViewCell{
  
    @IBOutlet weak var txtLabel: UILabel!
   // @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewSettings: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // viewContainer.layer.cornerRadius = 10

    }
//    
    public func configure(_ indexPath: IndexPath){
       
    if kSharedUserDefaults.loggedInUserModal.memberRoleId == "10"{
            imgViewSettings.image = UIImage.init(named: StaticArrayData.kEditSettingVoyColScreenDict[indexPath.item].image)
        txtLabel.text = StaticArrayData.kEditSettingVoyColScreenDict[indexPath.item].name
    }else{
        imgViewSettings.image = UIImage.init(named: StaticArrayData.kEditSettingUserColScreenDict[indexPath.item].image)
        txtLabel.text = StaticArrayData.kEditSettingUserColScreenDict[indexPath.item].name
    }
}
}

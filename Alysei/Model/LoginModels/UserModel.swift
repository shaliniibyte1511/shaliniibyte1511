//
//  UserModel.swift
//  Alysie
//
//  Created by CodeAegis on 12/01/21.
//

import Foundation

class UserModel: NSObject{
  
  var accessToken :String?
  var userId : String?
  var memberName : String?
  var memberRoleId : String?
  var email : String?
  var locale : String?
  var website: String?
  var userName: String?
    var firstName : String?
    var lastName : String?
  var displayName : String?
  var address : String?
  //var avatarId : String?
  var accountEnabled : String?
  var logout : Bool = false
  
  var latitude : Double = 0.0
  var longitude : Double = 0.0
  var avatarId: String?
    var coverPictureName: String?
    var profilePictureName: String?
    var role: UserRoles?
    var companyName: String?
    var restaurantName:String?
    var avatar: avatar?  // newly constructed struct for avater id
    var cover: cover?  // newly constructed struct for cover id
 // var cover_id: AllProductsDataModel?
    
  init(withDictionary dicResult: [String:Any]){
    
    super.init()
    
    self.logout = Bool.getBool(dicResult["logout"])
    
    self.latitude = Double.getDouble(dicResult[APIConstants.kLatitude])
    self.longitude = Double.getDouble(dicResult[APIConstants.kLongitude])
    
    
    let dictData = kSharedInstance.getDictionary(dicResult[APIConstants.kData])
    let dictRoles = kSharedInstance.getDictionary(dictData[APIConstants.kRoles])
    
    self.accessToken = String.getString(dicResult[APIConstants.kToken])
    self.userId = String.getString(dictData[APIConstants.kUserId])
    self.displayName = String.getString(dictData[APIConstants.kDisplayName])
    self.companyName = String.getString(dictData[APIConstants.kCompanyName])
    self.email = String.getString(dictData[APIConstants.kEmail])
    self.locale = String.getString(dictData[APIConstants.kLocale])
    self.website = String.getString(dictData[APIConstants.kWebsite])
    self.userName = String.getString(dictData[APIConstants.kUsername])
    self.firstName = String.getString(dictData[APIConstants.kFirstName])
    self.lastName = String.getString(dictData[APIConstants.kLastName])
    self.accountEnabled = String.getString(dictData[APIConstants.kAccountEnabled])
    self.memberName = String.getString(dictRoles[APIConstants.kName])
    self.memberRoleId = String.getString(dictRoles[APIConstants.kRoleId])
    self.restaurantName = String.getString(dictData[APIConstants.kRestaurantName])
   
    self.role = UserRoles(rawValue: Int(self.memberRoleId ?? "") ?? 0) ?? .voyagers
//    self.avatarId = String.getString(dictRoles[APIConstants.kAvatarId])

    if let avatarDict = dictData[APIConstants.kAvatarId] as? [String: Any] {
        self.avatar = imageAttachementModel(avatarDict, for: "coverPhoto-\(userId ?? "").jpg")
    }

    if let coverDict = dictData[APIConstants.kCoverId] as? [String: Any] {
        self.avatar = imageAttachementModel(coverDict, for: "profilePhoto-\(userId ?? "").jpg")
    }

    print(self)

  }

    typealias avatar = imageAttachementModel
    typealias cover = imageAttachementModel

    struct imageAttachementModel {
        var id: Int?
        var imageURL: String?

        init(_ dict: [String: Any], for imageName: String) {
            self.id = dict["id"] as? Int
            self.imageURL = "\(kImageBaseUrl)" + (dict["attachment_url"] as? String ?? "")
            if let imageURL = self.imageURL {
                LocalStorage.shared.saveImage(imageURL, fileName: imageName)
            }
        }

        init() {
            self.id = nil
            self.imageURL = nil
        }

        mutating func clear() {
            self = imageAttachementModel()
        }
        

        
    }

}


enum UserRoles: Int, Codable {
    case producer = 3
    case distributer1 = 4
    case distributer2 = 5
    case distributer3 = 6
    case voiceExperts = 7
    case travelAgencies = 8
    case restaurant =  9
    case voyagers = 10
}

enum RolesBorderColor : String {
    case producer = "8EC9BB"
    case distributer1 = "#A02C2D"
    case voiceExperts = "AB6393"
    case travelAgencies = "CA7E8D"
    case restaurant =  "FDCF76"
    case voyagers = "9C8ADE"
}

enum ProfilePercentage: Int {
    case percent100 = 100
    case percent75 = 75
}

enum isCameFrom {
    case save
    case addFeatureProduct
}
//class UserImage: {
//
//}
enum B2BSearch : Int{
    case Hub = 0
    case Importer = 1
    case Restaurant = 2
    case Expert = 3
    case TravelAgencies = 4
    case Producer = 5
}

enum B2BFieldId: Int {
    case productType = 2
    case restaurantType = 10
    case expertise = 11
    case title = 12
    case region = 29
    case country = 13
    case speciality = 14
}

//
//  UserDefaultsExtended.swift
//  OneClickWash
//
//  Created by RUCHIN SINGHAL on 23/10/16.
//  Copyright © 2016 Appslure. All rights reserved.
//

import Foundation

var UserDetails: String { return "userDetails" }
var DefaultDeviceToken: String { return "12345678" }

extension UserDefaults{
  
    //MARK: - Properties -
    
    var isUserLoggedIn: Bool { return (self.getLoggedInUserDetails().isEmpty == false) }

    var loggedInUserModal: UserModel {
      
      let userDict = self.getLoggedInUserDetails()
      return UserModel(withDictionary: userDict)
    }
    
    var deviceToken:String {
        
     if let token = kSharedUserDefaults.string(forKey: kDeviceToken),token.isEmpty == false {
          return token
      }
      return DefaultDeviceToken
   }
  
//  var accessToken: String{
//
//       set{
//           var userDict = self.getLoggedInUserDetails()
//           userDict[APIConstants.kToken] = newValue
//           self.setLoggedInUserDetails(loggedInUserDetails: userDict)
//       }
//       get{
//        return String.getString(self.loggedInUserModal.accessToken)
//     }
//   }
  
  var logout: Bool{

       set{
           var userDict = self.getLoggedInUserDetails()
           userDict["logout"] = newValue
           self.setLoggedInUserDetails(loggedInUserDetails: userDict)
       }
       get{
        return Bool.getBool(self.loggedInUserModal.logout)
     }
   }
  
  var latitude: Double{

       set{
           var userDict = self.getLoggedInUserDetails()
           userDict[APIConstants.kLatitude] = newValue
           self.setLoggedInUserDetails(loggedInUserDetails: userDict)
       }
       get{
        return Double(self.loggedInUserModal.latitude)
     }
   }
  
  var longitude: Double{

       set{
        var userDict = self.getLoggedInUserDetails()
        userDict[APIConstants.kLongitude] = newValue
        self.setLoggedInUserDetails(loggedInUserDetails: userDict)
       }
       get{
        Double(self.loggedInUserModal.longitude)
     }
   }
  
  var avatarId: String{

       set{
        var userDict = self.getLoggedInUserDetails()
        userDict[APIConstants.kAvatarId] = newValue
        self.setLoggedInUserDetails(loggedInUserDetails: userDict)
       }
       get{
        String.getString(self.loggedInUserModal.avatarId)
     }
   }
  
  
  //MARK: - Methods -
    
  func setLoggedInUserDetails(loggedInUserDetails dictUser: Dictionary<String, Any>){
      
        if let userData = try? JSONSerialization.data(withJSONObject: dictUser, options: .prettyPrinted){
          
           self.set(userData, forKey: UserDetails)
        }
        
        self.synchronize()
    }
    
   func getLoggedInUserDetails() -> Dictionary<String, Any>{
      
      if let userData = self.data(forKey: UserDetails),let dictUser = (try? JSONSerialization.jsonObject(with: userData, options: .mutableContainers)) as? Dictionary<String, Any>{
          return dictUser
      }
      return [:]
    }
    
    
    func clearAllData() -> Void{
      
        for (key,_) in self.dictionaryRepresentation(){
          self.removeObject(forKey: key)
        }
      kSharedAppDelegate.pushToLoginAccountViewC()
      kSharedUserDefaults.logout = true
    }
}

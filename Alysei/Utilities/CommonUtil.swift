//
//  CommonUtil.swift
//  Mindle
//
//  Created by fluper on 10/10/18.
//  Copyright © 2018 fluper. All rights reserved.
//

import UIKit
import SVProgressHUD

let ksharedCommonUtilInstance = CommonUtil.sharedInstance

 protocol CommonUtilDelegate {
  func didUserGetData(from result:Any, type:Int)-> Void
 }

extension UIViewController: CommonUtilDelegate {
    
  @objc func didUserGetData(from result: Any, type:Int) {}
    
    public func showAlert(withMessage message: String,_ completion:(() ->Void)? = nil){
      
        let alert = UIAlertController(title: AlertTitle.appName, message: message, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: ButtonTitle.kOk, style: .cancel) { (_) in
            
            DispatchQueue.main.async { completion?() }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
  
  public func showTwoButtonsAlert(title: String = "",message: String,buttonTitle: String,_ completion:(() ->Void)? = nil) -> Void{
      
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      
      alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: {(action)-> Void in
        completion?()}))
      alert.addAction(UIAlertAction(title: AppConstants.No, style: UIAlertAction.Style.cancel, handler: {(action)-> Void in
        
      self.dismiss(animated: true, completion: nil)}))
      self.present(alert, animated: true, completion: nil)
    }
}

class CommonUtil: NSObject {
    
  static let sharedInstance = CommonUtil()
    
    func postRequestToServer(url: String, method: kHTTPMethod, controller: UIViewController,userName: String = "",passsword: String = "", type: Int, param: [String:Any],btnTapped: UIButton) -> Void {
    
  
    SVProgressHUD.show()
    
   
    TANetworkManager.sharedInstance.requestApi(withServiceName: url,
                                                   requestMethod: method,
                                                   userName: userName,
                                                   passsword: passsword,
                                                   requestParameters: param,
                                                   withProgressHUD: false)
        { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
           
  
           SVProgressHUD.dismiss()
  
            if errorType == .requestSuccess {
            
              let dictResult = kSharedInstance.getDictionary(result)
                //superView.isUserInteractionEnabled = true
                switch Int.getInt(statusCode){
                case 200,201,204,205:
                  btnTapped.isUserInteractionEnabled = true
                   // superView.isUserInteractionEnabled = true
                  controller.didUserGetData(from: dictResult, type: type)
                case 400,401:
                  btnTapped.isUserInteractionEnabled = true
                    //superView.isUserInteractionEnabled = true
                  controller.showAlert(withMessage: String.getString(dictResult[APIConstants.kError]))
                case 409,422:
                  btnTapped.isUserInteractionEnabled = true
                   // superView.isUserInteractionEnabled = true
                  controller.showAlert(withMessage: String.getString(dictResult[APIConstants.kErrors]))
                default:
                 break
                }
                
            } else if errorType == .noNetwork{
                 btnTapped.isUserInteractionEnabled = true
               // superView.isUserInteractionEnabled = true
                controller.showAlert(withMessage: AlertMessage.kNoInternet)}
            else {
              btnTapped.isUserInteractionEnabled = true
               // superView.isUserInteractionEnabled = true
              controller.showAlert(withMessage: AlertMessage.kDefaultError) }
        }
    }
    
  func postRequestToImageUpload(withParameter params:[String: Any], url:String, image:[String: Any], controller: UIViewController, type: Int) {
    
    SVProgressHUD.show()
    TANetworkManager.sharedInstance.tempMultiPart(withServiceName: url,
                                                     requestMethod: .post,
                                                     requestImages: image,
                                                     requestVideos: [],
                                                     requestData: params)
    { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
      SVProgressHUD.dismiss()
      
      let dictResult = kSharedInstance.getDictionary(result)
      
      if errorType == .requestSuccess {
        
        switch Int.getInt(statusCode) {
        case 200:
          print("Done")
          controller.didUserGetData(from: dictResult, type: type)
        case 401:
          print("ff")
//          controller.showAlert(withMessage: AlertMessage.kSessionExpired) {
//            //kSharedAppDelegate.logout()
//          }
        case 422:
          controller.showAlert(withMessage: String.getString(dictResult["errors"]))
        default:
          controller.showAlert(withMessage: String.getString(dictResult["errors"]))
          break
        }
        
      } else if errorType == .noNetwork{
        controller.showAlert(withMessage: AlertMessage.kNoInternet)
        
      } else {
        controller.showAlert(withMessage: AlertMessage.kDefaultError)
      }
    }
  }
  
    //MARK:- Multipart
    func postToServerRequestMultiPart(_ url : String, params : [String:Any],imageParams : [[String : Any]], controller: UIViewController ,completionHandler : @escaping (_ params : [String : Any])->Void) {
        
        //CommonUtils.showHudWithNoInteraction(show: true)
        SVProgressHUD.show()
        
        TANetworkManager.sharedInstance.requestMultiPart(withServiceName: url,
                                                         requestMethod: .post,
                                                         requestImages: imageParams,
                                                         requestVideos: [:],
                                                         requestData: params)
        {[weak self] (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
            
           // CommonUtils.showHudWithNoInteraction(show: false)
            SVProgressHUD.dismiss()
            if errorType == .requestSuccess {
                
                let dictResult = kSharedInstance.getDictionary(result)
                
                switch Int.getInt(statusCode) {
                    
                case 200:
                    
                    completionHandler(dictResult)
                    
                    
                default:
                    controller.showAlert(withMessage: String.getString(dictResult["errors"]))
                    
                }
                
            } else if errorType == .noNetwork {
                controller.showAlert(withMessage: String.getString(AlertMessage.kNoInternet))
            } else {
                controller.showAlert(withMessage: String.getString(AlertMessage.kDefaultError))
    
            }
        }
    }
//  func postRequestToMultipleImageUpload(withParameter params:[String: Any], url:String, image:[String: Any], controller: UIViewController, type: Int) {
//    
//    SVProgressHUD.show()
//    
//    TANetworkManager.sharedInstance.requestMultiPart(withServiceName: url, requestMethod: .po, requestImages: <#T##[Dictionary<String, Any>]#>, requestVideos: <#T##Dictionary<String, Any>#>, requestData: <#T##Dictionary<String, Any>#>, completionClosure: <#T##(Any?, Error?, ErrorType, Int?) -> ()#>)
//    
//    TANetworkManager.sharedInstance.requestMultiPart(withServiceName: url,
//                                                     requestMethod: .post,
//                                                     requestImages: image,
//                                                     requestVideos: [],
//                                                     requestData: params)
//    { (result: Any?, error: Error?, errorType: ErrorType, statusCode: Int?) in
//      SVProgressHUD.dismiss()
//      
//      let dictResult = kSharedInstance.getDictionary(result)
//      
//      if errorType == .requestSuccess {
//        
//        switch Int.getInt(statusCode) {
//        case 200:
//          print("Done")
//          controller.didUserGetData(from: dictResult, type: type)
//        case 401:
//          print("ff")
////          controller.showAlert(withMessage: AlertMessage.kSessionExpired) {
////            //kSharedAppDelegate.logout()
////          }
//        case 422:
//          controller.showAlert(withMessage: String.getString(dictResult["errors"]))
//        default:
//          controller.showAlert(withMessage: String.getString(dictResult["errors"]))
//          break
//        }
//        
//      } else if errorType == .noNetwork{
//        controller.showAlert(withMessage: AlertMessage.kNoInternet)
//        
//      } else {
//        controller.showAlert(withMessage: AlertMessage.kDefaultError)
//      }
//    }
//  }
  
}

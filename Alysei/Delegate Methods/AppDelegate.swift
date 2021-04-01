//
//  AppDelegate.swift
//  Alysie
//
//  Created by CodeAegis on 11/01/21.
//

import UIKit
import SVProgressHUD
import GoogleMaps
import GooglePlaces
//import CoreLocation
import IQKeyboardManagerSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  //MARK: - Properties -
  
  var window: UIWindow?
  //var locationManager: CLLocationManager!
  var googleAPIKey = "AIzaSyDX4HE7708TQYkE0WoOlzTDlq7_9nneUHY"

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    IQKeyboardManager.shared.enable = true
    self.setInitialViewController()
    self.setDefaultProgressHud()
    GMSServices.provideAPIKey(googleAPIKey)
    GMSPlacesClient.provideAPIKey(googleAPIKey)
    FirebaseApp.configure()
    return true
  }

  //MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
   
  }
  
  //MARK: - Public Methods -
  
  @objc func setInitialViewController() {
    
    let storyboard = UIStoryboard(name: StoryBoardConstants.kSplash, bundle: nil)
    let navigationC = storyboard.instantiateViewController(withIdentifier: "SplashNavigation")
    kSharedAppDelegate.window = self.window
    self.window?.rootViewController = navigationC
    self.window?.makeKeyAndVisible()
  }
  
  public func setDefaultProgressHud() -> Void{
    
    //SVProgressHUD.setBackgroundColor(UIColor.white)
    SVProgressHUD.setBackgroundColor(UIColor.clear)
    SVProgressHUD.setForegroundColor(AppColors.blue.color)
    SVProgressHUD.setRingThickness(4.0)
    SVProgressHUD.setAnimationsEnabled(true)
  }
  
  public func pushToLanguageViewC() {

     let storyboard = UIStoryboard(name: StoryBoardConstants.kLogin, bundle: nil)
     let navigationC = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")
     kSharedAppDelegate.window = self.window
     self.window?.rootViewController = navigationC
     self.window?.makeKeyAndVisible()
 }
  
  public func pushToLoginAccountViewC() {
       
     let storyboard = UIStoryboard(name: StoryBoardConstants.kLogin, bundle: nil)
     let navigationC = storyboard.instantiateViewController(withIdentifier: "LoginAccountNavigation")
     kSharedAppDelegate.window = self.window
     self.window?.rootViewController = navigationC
     self.window?.makeKeyAndVisible()
 }
  
  public func pushToTabBarViewC() {

     let storyboard = UIStoryboard(name: StoryBoardConstants.kHome, bundle: nil)
     let navigationC = storyboard.instantiateViewController(withIdentifier: TabBarViewC.id())
     self.window?.rootViewController = navigationC
     kSharedAppDelegate.window = self.window
     self.window?.makeKeyAndVisible()
  }
}

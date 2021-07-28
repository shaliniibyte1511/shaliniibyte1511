//
//  UIViewController.swift
//  VisitorManagementSystem
//
//  Created by MacBook 1 on 26/10/19.
//  Copyright © 2019 CodeAegis. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  static func id() -> String {
    
    return String(describing: self)
  }
  
  static func segueIdentifier() -> String {
    
    return "show" + String(describing: self)
  }
}

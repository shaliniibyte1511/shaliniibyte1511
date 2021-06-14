//
//  ConnectionProductTypePresenter.swift
//  Alysei
//
//  Created by SHALINI YADAV on 6/14/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConnectionProductTypePresentationLogic
{
  func presentSomething(response: ConnectionProductType.Something.Response)
  func showProductCategory(_ productData: Data?,_ status: Bool?)
}

class ConnectionProductTypePresenter: ConnectionProductTypePresentationLogic
{
    
    func showProductCategory(_ productData: Data?, _ status: Bool?) {
        var message = "No Product found"
         if status == true{
            self.viewController?.displayProductData(productData)
         }else{
         //self.viewController?.showAlertWithMessage(message)
         }
    }
    
  weak var viewController: ConnectionProductTypeDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ConnectionProductType.Something.Response)
  {
    let viewModel = ConnectionProductType.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}

//
//  BasicConnectFlowViewController.swift
//  Alysei
//
//  Created by Janu Gandhi on 11/06/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BasicConnectFlowDisplayLogic: AnyObject {
}

class BasicConnectFlowViewController: UIViewController, BasicConnectFlowDisplayLogic {
    var interactor: BasicConnectFlowBusinessLogic?
    var router: (NSObjectProtocol & BasicConnectFlowRoutingLogic & BasicConnectFlowDataPassing)?

    // MARK:- Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK:- Setup

    private func setup() {
        let viewController = self
        let interactor = BasicConnectFlowInteractor()
        let presenter = BasicConnectFlowPresenter()
        let router = BasicConnectFlowRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK:- IBOutlets
    @IBOutlet weak var emailIDLabel: UILabel!

    // MARK:- protocol methods



    //MARK:- IBActions
    @IBAction func backbuttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func confirmButtonTapped(_ sender: UIButton) {

    }
}

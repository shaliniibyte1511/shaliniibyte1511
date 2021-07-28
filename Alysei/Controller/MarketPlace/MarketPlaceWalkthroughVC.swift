//
//  MarketPlaceWalkthroughVC.swift
//  Alysei
//
//  Created by SHALINI YADAV on 5/31/21.
//

import UIKit

class MarketPlaceWalkthroughVC: AlysieBaseViewC {
    
    @IBOutlet weak var imageCentre: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTopAction(_ sender: UIButton){
        _ = pushViewController(withName: MarketPlaceWalkThroughDescVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace)
    }

    @IBAction func btnSideAction(_ sender: UIButton){
        _ = pushViewController(withName: MarketPlaceWalkThroughDescVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace)
    }
    
    @IBAction func btnBottomAction(_ sender: UIButton){
        _ = pushViewController(withName: MarketPlaceWalkThroughDescVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace)
    }
    
    @IBAction func btnGetStartedAction(_ sender: UIButton){
        _ = pushViewController(withName: SelectMemberShipVC.id(), fromStoryboard: StoryBoardConstants.kMarketplace)
    }
}

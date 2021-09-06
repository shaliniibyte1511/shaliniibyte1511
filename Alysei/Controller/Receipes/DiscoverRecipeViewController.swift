//
//  DiscoverRecipeViewController.swift
//  Alysei Recipe Module
//
//  Created by mac on 26/07/21.
//

import UIKit

class DiscoverRecipeViewController: UIViewController, UIScrollViewDelegate, CategoryRowDelegate {
    @IBOutlet weak var discoverRecipeView: UIView!
    @IBOutlet weak var searchRecipe: UIView!
    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var containerTableVw: UITableView!
    //
    @IBOutlet weak var exploreHighlightView: UIView!
    @IBOutlet weak var favouriteHighlightView: UIView!
    @IBOutlet weak var myRecipeHighlightView: UIView!
 
    @IBOutlet weak var tapPostVw: UIView!
    @IBOutlet weak var tapMarketPlaceVw: UIView!
    
    var arrayHeader = NSMutableArray()
    var checkbutton = 0
    var highlight = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverRecipeView.layer.masksToBounds = false
        discoverRecipeView.layer.shadowRadius = 2
        discoverRecipeView.layer.shadowOpacity = 0.2
        discoverRecipeView.layer.shadowColor = UIColor.lightGray.cgColor
        discoverRecipeView.layer.shadowOffset = CGSize(width: 0 , height:2)
        searchRecipe.layer.cornerRadius = 5
        searchTextField.attributedPlaceholder =  NSAttributedString(string:"Search recipes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(openPost))
        self.tapPostVw.addGestureRecognizer(tapPost)
       
        let tapMarket = UITapGestureRecognizer(target: self, action: #selector(openMarketPlace))
        self.tapMarketPlaceVw.addGestureRecognizer(tapMarket)
        
       containerTableVw.register(UINib(nibName: "ExploreNwTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreNwTableViewCell")
        containerTableVw.register(UINib(nibName: "ExploreByRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreByRecipeTableViewCell")
        containerTableVw.register(UINib(nibName: "TrendingTableViewCell", bundle: nil), forCellReuseIdentifier: "TrendingTableViewCell")
        
        containerTableVw.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        
        arrayHeader = ["Quick Search by Categories", "Quick Search by Ingridients", "Quick Search by Regions", "Trending Now", "Quick Easy"]

       
        self.containerTableVw.delegate = self
        self.containerTableVw.dataSource = self
    }
    
    @objc func openPost(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        
    }
    
    @objc func openMarketPlace(){
                guard let vc = UIStoryboard(name: StoryBoardConstants.kMarketplace, bundle: nil).instantiateViewController(identifier: "MarketPlaceHomeVC") as? MarketPlaceHomeVC else {return}
                self.navigationController?.pushViewController(vc, animated: true)
                self.hidesBottomBarWhenPushed = true
            }
     
    @IBAction func createNewRecipeButton(_ sender: Any) {
        let createNewRecipeVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewRecipeViewController") as! CreateNewRecipeViewController
        self.navigationController?.pushViewController(createNewRecipeVC, animated: true)
    }
    
    @IBAction func tapForExplore(_ sender: Any) {
        self.checkbutton = 0
        containerTableVw.reloadData()
//        self.containerTableVw.register(UINib(nibName: "SearchByRegionCollectionViewCell", bundle: nil), forCellReuseIdentifier: "SearchByRegionCollectionViewCell")
        self.exploreHighlightView.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
        self.favouriteHighlightView.backgroundColor = .clear
        self.myRecipeHighlightView.backgroundColor = .clear
    }

    @IBAction func tapForFavourite(_ sender: Any) {
        self.checkbutton = 1
        containerTableVw.reloadData()
//        self.containerTableVw.register(UINib(nibName: "ExploreNwTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreNwTableViewCell")
        self.exploreHighlightView.backgroundColor = .clear
        self.favouriteHighlightView.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
        self.myRecipeHighlightView.backgroundColor = .clear

    }

    @IBAction func tapForMyRecipe(_ sender: Any) {
        self.checkbutton = 2
        containerTableVw.reloadData()
//        self.containerTableVw.register(UINib(nibName: "ExploreNwTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreNwTableViewCell")
        self.exploreHighlightView.backgroundColor = .clear
        self.favouriteHighlightView.backgroundColor = .clear
        self.myRecipeHighlightView.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
    }
    
    func highlightMyRecipe(){
        self.exploreHighlightView.backgroundColor = .clear
        self.favouriteHighlightView.backgroundColor = .clear
        self.myRecipeHighlightView.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha:1).cgColor
    }
    func cellTapped(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewRecipeViewController") as! ViewRecipeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableView
extension DiscoverRecipeViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch checkbutton{
        case 0:
            return arrayHeader.count
            
        case 1:
            
            return 1
        case 2:
            
            return 1
            
        default:
            break
        }
       return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        switch checkbutton {
        case 0:
            switch section{
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 1
            case 3:
                return 1
            case 4:
                return 1
            default:
                break
            }
        case 1:
            return 1
        case 2:
            return 1
        default:
            break
        }
        
        return 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = containerTableVw.dequeueReusableCell(withIdentifier: "ExploreNwTableViewCell") as! ExploreNwTableViewCell
       let cell2 = tableView.dequeueReusableCell(withIdentifier: "ExploreByRecipeTableViewCell") as! ExploreByRecipeTableViewCell
       let cell3 = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell") as! TrendingTableViewCell
        switch checkbutton{
        case 0:

           switch indexPath.section{
           case 0:

               cell.quickSearchLbl.text = "Quick Search By Meal"
               cell.quickSearchLbl?.font = UIFont(name: "Montserrat-Bold", size: 16)
               cell.tapViewAll = { [self] in
                   
                       let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllViewController") as! ViewAllViewController
                       self.navigationController?.pushViewController(viewAll, animated: true)
                   
               }
             
               return cell
             
              
        case 1:

              cell.quickSearchLbl.text = "Quick Search By Ingridients"
              cell.quickSearchLbl?.font = UIFont(name: "Montserrat-Bold", size: 16)
             cell.tapViewAll = {[self] in
               
                   let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllViewController") as! ViewAllViewController
                   self.navigationController?.pushViewController(viewAll, animated: true)
              
           }
           return cell
           
        case 2:

           cell2.quickSearchByRegionLabel.text = "Quick Search By Region"
            cell2.quickSearchByRegionLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
           cell2.tapViewAllRecipe = { [self] in
               
                   let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllViewController") as! ViewAllViewController
                   self.navigationController?.pushViewController(viewAll, animated: true)
               
           }
           
           return cell2
           
           case 3:

               cell3.quickSearchTrendingLabel.text = "Trending Now"
               cell3.quickSearchTrendingLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
               cell3.delegate = self
               cell3.tapViewAllTrending = { [self] in
                   
                       let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllViewController") as! ViewAllViewController
                       self.navigationController?.pushViewController(viewAll, animated: true)
                   
               }
              return cell3
           case 4:

               cell3.quickSearchTrendingLabel.text = "Quick Easy"
               cell3.quickSearchTrendingLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
               cell3.delegate = self
               cell3.tapViewAllTrending = { [self] in
                   
                       let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllViewController") as! ViewAllViewController
                       self.navigationController?.pushViewController(viewAll, animated: true)
                   
               }
              return cell3
          
        default:
            break
           
           }
        case 1:
            let cell4 = containerTableVw.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as! FavouriteTableViewCell
            cell4.check = true
//            cell4.arrayMyRecipe.append(arrayRecipe)
            return cell4
        case 2:
            let cell5 = containerTableVw.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as! FavouriteTableViewCell
            cell5.check = false
            return cell5
        default:
            break
      
        }
         

//        if indexPath.row == 2{
//            cell.collectionVw.register(UINib(nibName: "Explore2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Explore2CollectionViewCell")
//
//            let flowLayout = UICollectionViewFlowLayout()
//            flowLayout.scrollDirection = .horizontal
//            flowLayout.itemSize = CGSize(width: 150, height: 180)
//            flowLayout.minimumLineSpacing = 2.0
//            flowLayout.minimumInteritemSpacing = 5.0
//            cell.collectionVw.collectionViewLayout = flowLayout
//            cell.collectionVw.showsHorizontalScrollIndicator = false
//            cell.collectionVw.showsVerticalScrollIndicator = true
//
//        }
       
//       cell.quickSearchLbl.text = arrayHeader[indexPath.row] as? String

       return cell2
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch checkbutton{
        case 0:
            if (indexPath.section == 0)
             {
            
                 return 280;
             }
         
             if (indexPath.section == 1)
              {
             
                  return 280;
              }
             if (indexPath.section == 2)
              {
             
                  return 180;
              }
             if (indexPath.section == 3)
              {
             
                  return 350;
              }
             if (indexPath.section == 4)
              {
             
                  return 350;
              }
        case 1:
            return self.containerTableVw.frame.height
        case 2:
            return self.containerTableVw.frame.height
        default:
            break
        }
       
    return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
    
    }
}

    

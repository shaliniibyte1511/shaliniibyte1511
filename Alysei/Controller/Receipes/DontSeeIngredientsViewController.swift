//
//  DontSeeIngredientsViewController.swift
//  Preferences
//
//  Created by mac on 26/08/21.
//

import UIKit

class DontSeeIngredientsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [UIImage]()
    var newSearchModel: [IngridentArray]? = []
    var imageArray =  [#imageLiteral(resourceName: "Vegetarian no meat no dairy"),#imageLiteral(resourceName: "Beef"),#imageLiteral(resourceName: "Tomatoes")]
    var imageNameArray = ["Egg","Banana","Papaya"]
    var tablelist = ["Chocolate", "Cheese", "Butter", "Milk"]
    var searching = false
    var filteredIngridient = [String]()
    
    
    override func viewDidLayoutSubviews() {
           self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsCollectionView.register(UINib(nibName: "FoodAllergyCollectionViewCell", bundle: .main ), forCellWithReuseIdentifier: "FoodAllergyCollectionViewCell")
        
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        nextButton.layer.borderWidth = 1
        nextButton.layer.cornerRadius = 30
        nextButton.layer.borderColor = UIColor.init(red: 201/255, green: 201/255, blue: 201/255, alpha: 1).cgColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 30
        backButton.layer.borderColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        callChooseIngridients()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTextField.delegate = self
        
        searchTextField.addTarget(self, action: #selector(searchRecord(sender:)), for: .editingChanged)
    }
    @IBAction func tapNextToCookigSkill(_ sender: Any) {
        
        let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "CookingSkillViewController") as! CookingSkillViewController
        self.navigationController?.pushViewController(viewAll, animated: true)
    }
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSkip(_ sender: Any) {
        let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "CookingSkillViewController") as! CookingSkillViewController
        self.navigationController?.pushViewController(viewAll, animated: true)
    }
    
    @objc func searchRecord(sender: UITextField){
        self.filteredIngridient.removeAll()
        let searchData: Int = searchTextField.text!.count
        
        if searchData != 0{
            searching = true
            for list in tablelist{
                
                if let ingridientSearch = searchTextField.text{
                    let range = list.lowercased().range(of: ingridientSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil{
                        self.filteredIngridient.append(list)
                    }
                }
            }
            
        }
        else{
            filteredIngridient = tablelist
            searching = false
        }
        searchTableView.reloadData()
    }
    
    func callChooseIngridients(){
        
        TANetworkManager.sharedInstance.requestApi(withServiceName: APIUrl.Recipes.getrecipeIngridents, requestMethod: .GET, requestParameters: [:], withProgressHUD: true){ (dictResponse, error, errorType, statusCode) in
       
            let dictResponse = dictResponse as? [String:Any]
            
                if let data = dictResponse?["data"] as? [[String:Any]]{
                    self.newSearchModel = data.map({IngridentArray.init(with: $0)})
                    self.ingredientsCollectionView.reloadData()
            }
            
            
        }
    }

}
extension DontSeeIngredientsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newSearchModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FoodAllergyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodAllergyCollectionViewCell", for: indexPath) as! FoodAllergyCollectionViewCell
       
        let imgUrl = (kImageBaseUrl + (self.newSearchModel?[indexPath.item].imageId?.imgUrl ?? ""))

        cell.image1.setImage(withString: imgUrl)
        cell.imageNameLabel.text = self.newSearchModel?[indexPath.item].ingridientTitle
        cell.viewOfImage.layer.cornerRadius = cell.viewOfImage.bounds.width/2
        cell.viewOfImage.layer.borderWidth = 4
        cell.viewOfImage.layer.borderColor = UIColor.init(red: 225/255, green: 225/255, blue: 225/255, alpha: 1).cgColor
        
        if arrSelectedIndex.contains(indexPath) {
            cell.image2.image = UIImage(named: "Group 1165")
                }
                else {
                    let imgUrl = (kImageBaseUrl + (self.newSearchModel?[indexPath.item].imageId?.imgUrl ?? ""))
                    cell.image1.setImage(withString: imgUrl)
                }

                cell.layoutSubviews()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

          let strData = imageArray[indexPath.item]

          if arrSelectedIndex.contains(indexPath) {
              arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
              arrSelectedData = arrSelectedData.filter { $0 != strData}
            print("You deselected cell #\(indexPath.item)!")

            nextButton.layer.backgroundColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor

          }
          else {
              arrSelectedIndex.append(indexPath)
              arrSelectedData.append(strData)
            print("You selected cell #\(indexPath.item)!")

            nextButton.layer.backgroundColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha: 1).cgColor
                      }

          collectionView.reloadData()
      }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: (collectionView.bounds.width)/3, height: 120)
        return cellSize
        
    }
    
    
}
extension DontSeeIngredientsViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
         return self.filteredIngridient.count
        }
        else{
           return self.tablelist.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DontSeeIngredientsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DontSeeIngredientsTableViewCell") as! DontSeeIngredientsTableViewCell
        
        if searching{
            cell.searchNameLabel.text = filteredIngridient[indexPath.row]
        }
        else{
            
        }
        cell.searchNameLabel.text = tablelist[indexPath.row]
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
}

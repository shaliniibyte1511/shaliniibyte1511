//
//  CuisinesViewController.swift
//  Preferences
//
//  Created by mac on 24/08/21.
//

import UIKit

class CuisinesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedData = [UIImage]() // This is selected cell data array
    
    var imageArray = [#imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2"),#imageLiteral(resourceName: "Ellipse3"),#imageLiteral(resourceName: "Ellipse2"), #imageLiteral(resourceName: "Ellipse3"), #imageLiteral(resourceName: "Ellipse2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CuisinesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CuisinesCollectionViewCell")
        collectionView.allowsMultipleSelection = false
        nextButton.layer.borderWidth = 1
        nextButton.layer.cornerRadius = 30
        nextButton.layer.borderColor = UIColor.init(red: 59/255, green: 156/255, blue: 128/255, alpha: 1).cgColor


    }
    

    @IBAction func tapNextToFoodAllergy(_ sender: Any) {
        
        let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "FoodAllergyViewController") as! FoodAllergyViewController
        self.navigationController?.pushViewController(viewAll, animated: true)
    }
    
    @IBAction func tapSkip(_ sender: Any) {
        let viewAll = self.storyboard?.instantiateViewController(withIdentifier: "FoodAllergyViewController") as! FoodAllergyViewController
        self.navigationController?.pushViewController(viewAll, animated: true)
    }
}
extension CuisinesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CuisinesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisinesCollectionViewCell", for: indexPath) as! CuisinesCollectionViewCell
        cell.imageview.image = imageArray[indexPath.row]
        cell.imageView1.image = imageArray[indexPath.row]
        
        if arrSelectedIndex.contains(indexPath) {
            cell.imageView1.image = UIImage(named: "Group 1155")
            
                }
                else {
                    cell.imageview.image = imageArray[indexPath.row]
                }

                cell.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize(width: (collectionView.bounds.width)/3, height: 100)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

          let strData = imageArray[indexPath.item]

          if arrSelectedIndex.contains(indexPath) {
              arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
              arrSelectedData = arrSelectedData.filter { $0 != strData}
            print("You deselected cell #\(indexPath.item)!")

          }
          else {
              arrSelectedIndex.append(indexPath)
              arrSelectedData.append(strData)
            print("You selected cell #\(indexPath.item)!")
                      }

          collectionView.reloadData()
      }
    }





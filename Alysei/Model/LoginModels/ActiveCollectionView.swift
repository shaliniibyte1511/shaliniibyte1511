
//  ActiveCollectionView.swift
//  Alysei
//
//  Created by Gitesh Dang on 22/03/21.
//

import Foundation
import UIKit
import SwiftUI


class ActiveCollectionView: UICollectionView {
    
    var selectDelegate:SelectList?
    var hascome:HasCome? = .city
    var countries:[CountryModel]?{didSet{self.reloadData()}}
   
    // MARK:- life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegate()
    }
    func setDelegate() {
        self.register(UINib(nibName: "ActiveCountriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActiveCountriesCollectionViewCell")
        self.delegate = self
        self.dataSource = self
    }
    
}
// MARK:- cextension of main class for CollectionView
extension ActiveCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = self.dequeueReusableCell(withReuseIdentifier: "ActiveCountriesCollectionViewCell", for: indexPath) as? ActiveCountriesCollectionViewCell else {return UICollectionViewCell()}
        let obj = countries?[indexPath.row] ?? CountryModel()
        cell.btnCheckBox.isHidden = false
            cell.configCell(obj)
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4 , height: 120)

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = UIApplication.shared.delegate as? AppDelegate,  let window = app.window {
            window.isUserInteractionEnabled = false
        }
        if self.hascome == .showCountry { _ = self.countries?.map{$0.isSelected = false}}
        self.countries?[indexPath.row].isSelected =  !(self.countries?[indexPath.row].isSelected ?? false)
        if hascome != .city {
            self.countries?[indexPath.row].isSelected = true
        }
        self.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.selectDelegate?.didSelectList(data: self.countries?[indexPath.row], index: indexPath)
        }
       
    }
}

//extension UIView {
//    var parentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder?.next
//            if let viewController = parentResponder as? UIViewController {
//                return viewController
//            }
//        }
//        return nil
//    }
//}
//
//class BackButton : UIButton {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//    }
//
//    @objc func backButtonTapped() {
//        self.parentViewController?.dismiss(animated: true, completion: nil)
//        self.parentViewController?.navigationController?.popViewController(animated: true)
//    }
//}

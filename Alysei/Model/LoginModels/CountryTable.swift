//
//  CountryTable.swift
//  Alysie
//
//


import Foundation
import UIKit
import SwiftUI

protocol SelectList {
    func didSelectList(data:Any?, index:IndexPath)
    func didSelectReviewList(data:Any? , index: IndexPath, isEdithub:Bool)
}

class CountryTableView: UITableView {
    
    var selectDelegate:SelectList?
    var hascome:HasCome? = .city
    var countries:[CountryModel]?{didSet{self.reloadData()}}

    // MARK:- life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDelegate()
    }
    func setDelegate() {
        self.register(UINib(nibName: "CountrySelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CountrySelectionTableViewCell")
        self.delegate = self
        self.dataSource = self
    }
    
}
// MARK:- cextension of main class for CollectionView
extension CountryTableView : UITableViewDelegate   , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func dequeueReusableCell(indexPath:IndexPath)->UITableViewCell {
        guard let country = self.countries?[indexPath.row] else { return UITableViewCell() }
        let cell = self.dequeueReusableCell(withIdentifier: "CountrySelectionTableViewCell", for: indexPath) as! CountrySelectionTableViewCell
        cell.selectionStyle = .none
        cell.configCell(country)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.hascome == .showCountry { _ = self.countries?.map{$0.isSelected = false}}
        self.countries?[indexPath.row].isSelected =  !(self.countries?[indexPath.row].isSelected ?? false)
        if hascome != .city {
            self.countries?[indexPath.row].isSelected = true
        }
        self.reloadData()
        self.selectDelegate?.didSelectList(data: self.countries?[indexPath.row], index: indexPath)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class BackButton : UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        self.parentViewController?.dismiss(animated: true, completion: nil)
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
}

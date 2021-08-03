//
//  ProductRecentSearchModel.swift
//  Alysei
//
//  Created by SHALINI YADAV on 8/2/21.
//

import Foundation

class ProductDetailModel{
    var product_detail: ProductSearchListModel?
    var product_gallery: [ProductGalleryModel]?
    
    init(with data: [String:Any]) {
        
        if let productDetail = data["product_detail"] as? [String:Any]{
            self.product_detail = ProductSearchListModel.init(with: productDetail)
        }
        
        if let productGallery = data["product_gallery"] as? [[String:Any]]{
            self.product_gallery = productGallery.map({ProductGalleryModel.init(with: $0)})
        }
    }
}

class ProductSearchListModel {
    
    var marketplaceRecentSearchId: Int?
    var userId: Int?
    var searchKeyword: String?
    var marketplaceProductId: Int?
    var title: String?
    var product_category_name: String?
    var product_price : String?
    var store_name: String?
    var total_reviews: Int?
    var available_for_sample: String?
    var description: String?
    var handling_instruction: String?
    var dispatch_instruction: String?
    var quantity_available: String?
    var brand_label_id: String?
    var min_order_quantity: String?
    var product_gallery: [ProductGalleryModel]?
    
    init(with data: [String:Any]){
        self.marketplaceRecentSearchId = Int.getInt(data["marketplace_recent_search_id"])
        self.userId = Int.getInt(data["user_id"])
        self.searchKeyword = String.getString(data["search_keyword"])
        self.marketplaceProductId = Int.getInt(data["marketplace_product_id"])
        self.title = String.getString(data["title"])
        self.product_category_name = String.getString(data["product_category_name"])
        self.product_price = String.getString(data["product_price"])
        self.store_name = String.getString(data["store_name"])
        self.total_reviews = Int.getInt(data["total_reviews"])
        self.available_for_sample = String.getString(data["available_for_sample"])
        self.description = String.getString(data["description"])
        self.handling_instruction = String.getString(data["handling_instruction"])
        self.dispatch_instruction = String.getString(data["dispatch_instruction"])
        self.quantity_available = String.getString(data["quantity_available"])
        self.brand_label_id = String.getString(data["brand_label_id"])
        self.min_order_quantity = String.getString(data["min_order_quantity"])
        if let productGallery = data["product_gallery"] as? [[String:Any]]{
            self.product_gallery = productGallery.map({ProductGalleryModel.init(with: $0)})
        }
    }
    
}

class ProductGalleryModel {
    
    var marketplace_product_gallery_id: Int?
    var marketplace_product_id: Int?
    var attachment_url: String?
    
    init(with data: [String:Any]){
        self.marketplace_product_gallery_id = Int.getInt(data["marketplace_product_gallery_id"])
        self.marketplace_product_id = Int.getInt(data["marketplace_product_id"])
        self.attachment_url = String.getString(data["attachment_url"])
    }
}

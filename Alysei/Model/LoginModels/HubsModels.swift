//
//  HubsModels.swift
//  Alysie
//
//

import Foundation
import UIKit

class ActiveUpcomingCountry {
    var arrActiveCountries = [CountryModel]()
    var arrUpcomingCountries = [CountryModel]()
    
    init(data:[String:Any]?) {
        let arrActiveCountries = kSharedInstance.getArray(withDictionary: data?["active_countries"])
        self.arrActiveCountries = arrActiveCountries.map{CountryModel(data: $0)}
        let arrUpcomingCountries = kSharedInstance.getArray(withDictionary: data?["upcoming_countries"])
        self.arrUpcomingCountries = arrUpcomingCountries.map{CountryModel(data: $0)}
    }
    
}

class CountryModel {
    var name:String?
    var id:String?
    var capital:String?
    var currency:String?
    var subregion:String?
    var isSelected = false
    var emoji: String?
    var phonecode: String?
    var flagId: FlagId?
    
    init(data:[String:Any]?) {
        self.id = String.getString(data?["id"])
        self.name = String.getString(data?["name"])
        self.capital = String.getString(data?["capital"])
        self.currency = String.getString(data?["currency"])
        self.subregion = String.getString(data?["subregion"])
        self.emoji = String.getString(data?["emoji"])
        self.phonecode = String.getString(data?["phonecode"])
        if let flagId = data?["flag_id"] as? [String:Any] {
            self.flagId = FlagId.init(data: flagId)
        }
    }
    init() { }
    
}

class FlagId{
    var attachmentUrl: String?
    
    init(data: [String:Any]?) {
        self.attachmentUrl = String.getString(data?["attachment_url"])
    }
    init() { }
}
class SelectdHubs {
    var country:CountryModel = CountryModel()
    var hubs:[CountryHubs] = [CountryHubs]()
    var state:[CountryHubs] = [CountryHubs]()

    
    static func createHub(country:CountryModel?)->SelectdHubs{
        let hub = SelectdHubs()
        hub.country = country ?? CountryModel()
        return hub
    }
}



class CountryHubs {
    var country_code:String?
    var country_id:String?
    var state_id:String?
    var id:String?
    var name:String?
    var iso2:String?
    var attachment_url:String?
    var type:HasCome? = .hubs
    var isSelected = false
    init(data:[String:Any]?) {
        self.id = String.getString(data?["id"])
        self.name = String.getString(data?["name"])
        self.country_code = String.getString(data?["country_code"])
        self.country_id = String.getString(data?["country_id"])
        self.iso2 = String.getString(data?["subregion"])
        self.state_id = String.getString(data?["state_id"])
        self.type = .city
    }
    // MARK:_ init for hUB Via city
    init(hub data:[String:Any]?) {
        self.id = String.getString(data?["id"])
        self.name = String.getString(data?["title"])
        self.country_code = String.getString(data?["country_code"])
        self.country_id = String.getString(data?["country_id"])
        self.iso2 = String.getString(data?["subregion"])
        self.type = .hubs
        self.attachment_url = String.getString(data?["attachment_url"])
    }
    init() { }
}

class HubsViaCity {
    var hubs_array:[CountryHubs]?
    var state_id:String?
    var state_name:String?
    
    init(data:[String:Any]?) {
        self.state_id = String.getString(data?["state_id"])
        self.state_name = String.getString(data?["state_name"])
        let hubsArray = kSharedInstance.getArray(withDictionary: data?["hubs_array"])
        self.hubs_array = hubsArray.map{CountryHubs(hub: $0)}
    }
    
    init(city data:[String:Any]?) {
        self.state_id = String.getString(data?["state_id"])
        self.state_name = String.getString(data?["state_name"])
        let hubsArray = kSharedInstance.getArray(withDictionary: data?["city_array"])
        self.hubs_array = hubsArray.map{CountryHubs(data: $0)}
    }
    init() {}
}

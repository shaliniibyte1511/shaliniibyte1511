//
//  ProfileTabRows.swift
//  Alysei
//
//  Created by Janu Gandhi on 23/05/21.
//

import Foundation

struct ProfileTabRows {

    func noOfRows(_ userRole: UserRoles) -> Int {
//        switch userRole {
//        case .producer:
//            return 5
//        case .distributer1:
//            return 5
//        case .distributer2:
//            return 5
//        case .distributer3:
//            return 5
//        case .voiceExperts:
//            return 5
//        case .travelAgencies:
//            return 5
//        case .restaurant:
//            return 5
//        case .voyagers:
//            return 5
//        }

        return self.rowsTitle(userRole).count
    }

    func rowsTitle(_ userRole: UserRoles) -> [String] {
        switch userRole {
        case .producer:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .distributer1:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .distributer2:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .distributer3:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .voiceExperts:
            return ["Post" , "Photos", "About", "Contact", "Blogs"]
        case .travelAgencies:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .restaurant:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        case .voyagers:
            return ["Post" , "Photos", "About", "Contact", "Awards"]
        }
    }


    func imageName(_ userRole: UserRoles) -> [String] {
        switch userRole {
        case .producer:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .distributer1:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .distributer2:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .distributer3:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .voiceExperts:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .travelAgencies:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .restaurant:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        case .voyagers:
            return ["posts_icon_normal", "photo-icon-normal", "about_icon_normal", "contact_icon_normal", "profile_awards" ]
        }
    }

}

//
//  BasicConnectFlowModels.swift
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

enum BasicConnectFlow {
    // MARK: Use cases


    struct userDataModel {
//        var email: String
        var userID: Int
        var username: String
    }

    enum Connection {
        struct request: Codable {
            var userID: Int
           // var userID: String
            var reason: String?
            var selectProductId: String?

            private enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case reason = "reason_to_connect"
                case selectProductId = "user_field_option_id"
            }

            func urlEncoded() -> Data? {
                let body = "user_id=\(userID)&reason_to_connect=\(reason ?? "")&user_field_option_id=\(selectProductId ?? "")"
                return body.data(using: .utf8)
            }
//            func data() -> Data? {
//                let postData = NSMutableData()
//                if let reason = self.reason {
//                    postData.append("reason_to_connect=\(reason)&".data(using: .utf8)!)
//                }
//                return postData as Data
//            }

        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}

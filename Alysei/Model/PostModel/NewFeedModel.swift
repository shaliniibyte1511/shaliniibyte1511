//
//  NewFeedModel.swift
//  Alysei
//
//  Created by SHALINI YADAV on 5/4/21.
//

import Foundation

class NewFeedSearchModel{
    var currentPage: Int?
    var data: [NewFeedSearchDataModel]?
    var firstPageUrl: String?
    var lastPageUrl: String?
    var lastPage: Int?
    
    init(with dictResponse: [String:Any]){
        self.currentPage = Int.getInt(dictResponse["current_page"])
        if let data = dictResponse["data"] as? [[String:Any]]{
            self.data = data.map({NewFeedSearchDataModel.init(with: $0)})
        }
        self.firstPageUrl = String.getString(dictResponse["first_page_url"])
        self.lastPageUrl = String.getString(dictResponse["last_page_url"])
        self.lastPage = Int.getInt(dictResponse["last_page"])
    }
}

class NewFeedSearchDataModel{
    var activityActionId: Int?
    var subjectId: SubjectData?
    var body: String?
    //var shared_post_id:
    var attachmentCount: Int?
    var commentCount: Int?
    var likeCount: Int?
    var privacy: String?
    var likeFlag: Int?
    var posted_at: String?
    var attachments: [Attachments]?
    var title: String?
    var image: AttachmentLink?
    
    
    init(with dictResponse: [String:Any]){
        self.activityActionId = Int.getInt(dictResponse["activity_action_id"])
        if let subjectId = dictResponse["subject_id"] as? [String:Any]{
            self.subjectId = SubjectData.init(with: subjectId)
        }
        self.body = String.getString(dictResponse["body"])
        self.attachmentCount = Int.getInt(dictResponse["attachment_count"])
        self.commentCount = Int.getInt(dictResponse["comment_count"])
        self.likeCount = Int.getInt(dictResponse["like_count"])
        self.privacy = String.getString(dictResponse["privacy"])
        self.likeFlag = Int.getInt(dictResponse["like_flag"])
        self.posted_at = String.getString(dictResponse["posted_at"])
        if let attachments = dictResponse["attachments"] as? [[String:Any]]{
            self.attachments = attachments.map({Attachments.init(with: $0)})
        }
        self.title = String.getString(dictResponse["title"])
        if let image = dictResponse["image"] as? [String:Any]{
            self.image = AttachmentLink.init(with: image)
        }
    }
}

class SubjectData {
    var userId: Int?
    var name: String?
    var email: String?
    var roleId: Int?
    var companyName: String?
    var restaurantName: String?
    var avatarId: Avatar?
    init(with dictResponse: [String:Any]){
        self.userId = Int.getInt(dictResponse["user_id"])
        self.name = String.getString(dictResponse["name"])
        self.email = String.getString(dictResponse["email"])
        self.roleId = Int.getInt(dictResponse["role_id"])
        self.companyName = String.getString(dictResponse["company_name"])
        self.restaurantName = String.getString(dictResponse["restaurant_name"])
        if let avatar = dictResponse["avatar_id"] as? [String:Any]{
            self.avatarId = Avatar.init(with: avatar)
        }
         
    }
    
}

class Avatar {
    var id: Int?
    var attachmentUrl: String?
    
    init(with dictResponse: [String:Any]){
        self.id = Int.getInt(dictResponse["id"])
        self.attachmentUrl = String.getString(dictResponse["attachment_url"])
    }
}
class Attachments{
    var activityAttachmentId: Int?
    var attachmentLink: AttachmentLink?
    init(with dictResponse: [String:Any]){
        self.activityAttachmentId = Int.getInt(dictResponse["activity_attachment_id"])
        if let attachment_link = dictResponse["attachment_link"] as? [String:Any]{
            self.attachmentLink = AttachmentLink.init(with: attachment_link)
        }
    }
}

class AttachmentLink {
    var attachmentUrl: String?
    
    init(with dictResponse: [String:Any]){
        self.attachmentUrl = String.getString(dictResponse["attachment_url"])
    }
}

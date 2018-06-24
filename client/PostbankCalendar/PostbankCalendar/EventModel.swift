//
//  EventModel.swift
//  PostbankCalendar
//
//  Created by Alexander Karaatanassov on 24.06.18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import Foundation
import ObjectMapper

class EventModel: Mappable {
    var id: Int = -1
    var title: String = ""
    var description: String = ""
    var startDate: String = ""
    var endDate: String = ""
    
    init(id: Int, title: String, description: String, startDate: String, endDate: String) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
    }
    
}

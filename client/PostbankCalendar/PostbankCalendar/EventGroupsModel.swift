//
//  EventGroupsModel.swift
//  PostbankCalendar
//
//  Created by Alexander Karaatanassov on 24.06.18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import Foundation
import ObjectMapper

class EventGroupsModel: Mappable {
    var eventGroups: [EventsModel] = []

    init() {
        eventGroups = []
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        eventGroups <- map["eventGroups"]
    }
    
}

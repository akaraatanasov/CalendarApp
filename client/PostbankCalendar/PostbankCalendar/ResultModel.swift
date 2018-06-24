//
//  ResultModel.swift
//  PostbankCalendar
//
//  Created by Alexander Karaatanassov on 24.06.18.
//  Copyright © 2018 wenchao. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultModel: Mappable {
    var result: EventGroupsModel = EventGroupsModel()

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        result <- map["result"]
    }
    
}

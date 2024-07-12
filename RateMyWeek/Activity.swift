//
//  Activity.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import Foundation
import SwiftData

@Model
class Activity{
    let id = UUID()
    var name: String
    var freqency: Int
    var days: [Day]
    var weight: Int?
    var startDate: Date?
    var about : String?
    
    init(name: String, freqency: Int, days: [Day], weight: Int? = 0, startDate: Date? = Date.now, about: String? = " " ) {
        self.name = name
        self.freqency = freqency
        self.days = days
        self.weight = weight
        self.startDate = startDate
        self.about = about
    }
}

//@Model
//class Activities{
////    static let fullList = Activities()
//    var activities : [Activity] = []
//    
//    init(activities: [Activity]) {
//        self.activities = activities
//    }
//    
////    private init(){}
//}

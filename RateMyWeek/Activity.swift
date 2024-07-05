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
    var name: String
    var freqency: Int
    var days: [Day]
    
    init(name: String, freqency: Int, days: [Day]) {
        self.name = name
        self.freqency = freqency
        self.days = days
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

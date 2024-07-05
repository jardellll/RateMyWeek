//
//  Day.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/8/24.
//

import Foundation
import SwiftData

@Model
class Day: Identifiable{
    let id = UUID()
    var date: Date
    @Relationship(inverse: \Activity.days) var activities : [Activity]
    
    init(date: Date, activities: [Activity]) {
        self.date = date
        self.activities = activities
    }
}

//@Model
//class DayList{
//    var days = [Date]()
//    
//    init(days: [Date] = [Date]()) {
//        self.days = days
//    }
//}

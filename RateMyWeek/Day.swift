//
//  Day.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/8/24.
//

import Foundation
import SwiftData

@Model

/*
 @Model means this is essentially an entity in SwiftData
 days has an id to be identified
 day also has a date to store which date it represents
 day has a compDict with is a dictionary storing the name of the activity and a boolean to day if the activity is completed or not
 creating a new day requires providing the date, a list of activities and a compDict (it'll have the names of all the activities and the completion status
 */

class Day: Identifiable{
    let id = UUID()
    var date: Date
    @Relationship(inverse: \Activity.days) var activities : [Activity]
    var compDict: [String: Bool] = [:]
    
    init(date: Date, activities: [Activity], compDict: [String : Bool]) {
        self.date = date
        self.activities = activities
        self.compDict = compDict
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

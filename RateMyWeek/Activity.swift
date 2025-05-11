//
//  Activity.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import Foundation
import SwiftData

@Model
/*
 
 Activity has an id to be identified
 Activity has a name for it's name
 frequency for how many times in the weeek it should be completed
 days is a list of Day, this stores all the days the activity was completed on
 weight is an int and it stores the weight given to the activity
 startDate is when the activity is first started. I think this is to make it easier to know which activities to show for which date
 about stores a description of the activity
 */


class Activity{
    let id = UUID()
    var name: String
    var freqency: Int
    var days: [Day]
    var weight: Int?
    var startDate: Date?
    var about : String?
    //var goals: [Goal]
    
    init(name: String, freqency: Int, days: [Day], weight: Int? = 1, startDate: Date? = Date.now, about: String? = " " ){//}, goals:[Goal]) {
        self.name = name
        self.freqency = freqency
        self.days = days
        self.weight = weight
        self.startDate = startDate
        self.about = about
        //self.goals = goals
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

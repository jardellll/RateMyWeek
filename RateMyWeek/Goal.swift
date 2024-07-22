//
//  Goal.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/14/24.
//

import Foundation
import SwiftData

@Model
class Goal{
    let id = UUID()
    var name: String
    var overallDef: String
    var oneYearDef: String
    var fiveYearDef: String
    //@Relationship(inverse: \Activity.goals) var activities: [Activity]
    var activities: [String]
    enum categories: String, CaseIterable, Identifiable, Codable {
        case physical
        case spritual
        case mental
        case relationship
        case financial
        case professional
        case personal
        
        var id: String { self.rawValue }
    }
    var category: [categories]
    
    init(name: String, overallDef: String, oneYearDef: String, fiveYearDef: String, activities: [String], category: [categories]) {
        self.name = name
        self.overallDef = overallDef
        self.oneYearDef = oneYearDef
        self.fiveYearDef = fiveYearDef
        self.activities = activities
        self.category = category
    }
}

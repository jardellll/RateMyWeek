//
//  Week.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 8/31/24.
//

import Foundation

struct Week: Identifiable{
    let id = UUID()
    var dateRange: String
    var score: Double
    
    init(dateRange: String, score: Double) {
        self.dateRange = dateRange
        self.score = score
    }
}

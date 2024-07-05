//
//  RateMyWeekApp.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI

@main
struct RateMyWeekApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()//currentDay: Day(date: .now, activities: [], completionMap: [String: Bool]()))
        }
        .modelContainer(for: Day.self)
    }
}

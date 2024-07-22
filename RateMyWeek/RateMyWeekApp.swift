//
//  RateMyWeekApp.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI
import SwiftData

@main
struct RateMyWeekApp: App {
    var container: ModelContainer
    
    init() {
        do{
            let config = ModelConfiguration(for: Day.self, Goal.self)
            
            container = try ModelContainer(for: Day.self, Goal.self, configurations: config)
        }catch{
            fatalError("failed to configure swiftdata container")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()//currentDay: Day(date: .now, activities: [], completionMap: [String: Bool]()))
        }
        .modelContainer(container)
    }
}

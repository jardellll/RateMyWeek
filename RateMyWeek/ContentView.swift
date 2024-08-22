//
//  ContentView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI
import UserNotifications
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedTab = 1
    @Query var activities : [Activity]
    @Query var days : [Day]
    var body: some View {
        TabView(selection: $selectedTab){
            GoalsView()
                .tabItem{
                    Label("goals", systemImage: "flag.checkered")
                }
                .tag(0)
            LogView()
                .tabItem{
                    Label("log", systemImage: "checklist")
                }
                .tag(1)
            StatsView()
                .tabItem{
                    Label("stats", systemImage: "chart.xyaxis.line")
                }
                .tag(2)
        }
        .onAppear(){
            let delegate = NotificationDelegate(activities: activities, days: days, modelContext: modelContext)
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
}


#Preview {
    ContentView()
}

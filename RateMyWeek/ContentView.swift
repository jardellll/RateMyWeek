//
//  ContentView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
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
    }
}


#Preview {
    ContentView()
}

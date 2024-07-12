//
//  ActivityView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/9/24.
//

import SwiftUI
import SwiftData

struct ActivityView: View {

    var activity: Activity
    @State private var dayList = ""
    var body: some View {
        NavigationStack{
            List{
                Text("frequency: \(activity.freqency)")
                Text("week weight \(activity.weight ?? 0)/100")
                Text("about: \(activity.about ?? " ")")
                NavigationLink(destination: DaysCompletedListView(days: activity.days)){
                    Text("days completed")
                }
                
                
                //DaysCompletedListView.init())
//                List(activity.days){ day in
//                    Text(day.date.formatted(date: .abbreviated, time: .omitted))
//                    
//                }
                
            }
            .navigationTitle(activity.name)
        }
    }
}

#Preview {
    ActivityView(activity: Activity(name: "sample", freqency: 4, days: []))
}

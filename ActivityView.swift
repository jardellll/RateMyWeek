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
                Text("date started: \(activity.startDate ?? Date.now)")
                Text("about: \(activity.about ?? " ")")
                NavigationLink(destination: DaysCompletedListView(days: getCompletedDays(act: activity))){
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
    func getCompletedDays(act: Activity)->[Day]{
        var completedDays = [Day]()
        for day in act.days{
            if day.compDict[act.id.uuidString] == true{
                completedDays.append(day)
            }
        }
        return completedDays
    }
}

#Preview {
    ActivityView(activity: Activity(name: "sample", freqency: 4, days: []))
}

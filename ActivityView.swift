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
    @State private var editAct = false
    @State private var editOrCancel = "edit"
    @State private var newName = ""
    @State private var newFreq = 0
    @State private var newDateStarted = Date.now
    @State private var newAbout = ""
    var body: some View {
        NavigationStack{
            Button(editOrCancel){
                if !editAct{
                    newName = activity.name
                    newFreq = activity.freqency
                    // newWeight = activity.weight
                    //newDateStarted = activity.startDate
                    newAbout = activity.about ?? ""
                    editOrCancel = "cancel"
                    editAct.toggle()
                }else{
                    editOrCancel = "edit"
                    editAct.toggle()
                }
            }
            if !editAct{
                List{
                    Text("frequency: \(activity.freqency)")
                    Text("week weight \(activity.weight ?? 0)/100")
                    Text("date started: \(activity.startDate?.formatted(date: .abbreviated, time: .omitted) ?? Date.now.formatted(date: .abbreviated, time: .omitted))")
                    Text("about: \(activity.about ?? " ")")
                    NavigationLink(destination: DaysCompletedListView(days: getCompletedDays(act: activity))){
                        Text("days completed")
                    }
                    .navigationTitle(activity.name)
                    
                    
                    //DaysCompletedListView.init())
                    //                List(activity.days){ day in
                    //                    Text(day.date.formatted(date: .abbreviated, time: .omitted))
                    //
                    //                }
                    
                }
            }else{
                List{
                    Section("rename"){
                        TextField("new name", text: $newName)
                    }
                    Picker("how many times per week?", selection: $newFreq){
                        ForEach(1..<8){
                            Text("\($0)")
                        }
                    }
                    //Textf("date started: \(newDateStarted ?? Date.now)") need a new date picker
                    Section("about"){
                        TextField("about:", text: $newAbout)
                    }
                    Section{
                        Button("save"){
                            activity.name = newName
                            activity.about = newAbout
                            activity.freqency = newFreq
                            editAct = false
                        }
                    }
                }
                .navigationTitle(activity.name)
            }
            
            
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
    ActivityView(activity: Activity(name: "sample", freqency: 4, days: [], goals: []))
}

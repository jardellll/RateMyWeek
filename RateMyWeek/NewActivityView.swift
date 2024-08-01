//
//  NewActivityView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI
import SwiftData

struct NewActivityView: View {
    @Environment(\.modelContext) var modelContext
    @Query var days : [Day]
    @Query var goals : [Goal]
    @State private var name = ""
    @State private var frequency = 0
    @State private var startDate = Date.now
    @State private var about = "about"
    @State private var actGoals = [Goal]()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            List{
                TextField("name your activity", text: $name)
                Picker("how many times per week?", selection: $frequency){
                    ForEach(1..<8){
                        Text("\($0)")
                    }
                }
//                Section("choose a goal"){
//                    ScrollView(.horizontal, showsIndicators: true){
//                        HStack(spacing: 50){
//                            ForEach(goals){ goal in
//                                Button(goal.name){
//                                    if actGoals.contains(goal){
//                                        if let index = actGoals.firstIndex(of: goal){
//                                            actGoals.remove(at: index)
//                                        }
//                                    }else{
//                                        actGoals.append(goal)
//                                    }
//                                }
//                                .foregroundStyle(actGoals.contains(goal) == true ? .green : .primary)
//                            }
//                        }
//                    }
//                }
                DatePicker("start date", selection: $startDate, displayedComponents: .date)
                
            //}
                TextEditor(text: $about)
                
            //Form{
                Button("save"){
                    let newActivity = Activity(name: name, freqency: frequency+1, days: [], weight: 0, startDate: startDate)
                    modelContext.insert(newActivity)
                    //Activities.activities.append(newActivity)
                    for day in days {
                        let calendar = Calendar.current
                        let dayStartDate = calendar.dateComponents([.year, .month, .day],from: day.date)
                        let actStartDate = calendar.dateComponents([.year, .month, .day],from: startDate)
                        let dayStartDt = calendar.date(from: dayStartDate)!
                        let actStartDt =  calendar.date(from: actStartDate)!
                        if dayStartDt >= actStartDt{
                            day.activities.append(newActivity)
                        }
                    }
                    dismiss()
                    
                }
                Button("cancel"){
                    dismiss()
                }
            }
            .navigationTitle("New Activity")
        }
        
    }
}

#Preview {
    NewActivityView()
}


// instead of trying to store an array of activities as a swiftdata thing, I can just query all the activities and put that in a list, then pair it up with the day class

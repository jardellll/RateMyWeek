//
//  ContentView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 6/7/24.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var chosenDay = Date.now
    @State private var showingSheet = false
    @Query var days : [Day]
    @Query var activities : [Activity]
    
    //@Query var dayList : [DayList]
    
    @State private var actForDay = [Activity]()
    @State private var foundMatch = false
    @State private var currentDay: Day?

    var body: some View {
        VStack {
            Button("new activity"){
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet){
                NewActivityView()
            }
            DatePicker("choose a day", selection: $chosenDay, displayedComponents: .date)
                .onChange(of: chosenDay, initial: true){
                    foundMatch = false
                    for day in days{
                        if day.date == chosenDay{
                            print("found a match")
                            foundMatch = true
                            print (day.date)
                            print (chosenDay)
                            print(day.activities)
                            actForDay = day.activities
                            currentDay = day
                            print(day.compDict)
                        
                        }
                    }
                    if foundMatch == false{
                        let newDay = Day(date: chosenDay, activities: [], compDict: [:])
                        print("new day")
                        modelContext.insert(newDay)
                        for act in activities{
                            newDay.activities.append(act)
                            newDay.compDict[act.name] = false
                        }
                        print(newDay.compDict)
                        actForDay = newDay.activities
                        currentDay = newDay
                        try? modelContext.save()
                     
                        
                    }
                }
                    
            if let currentDay = currentDay{
                List(currentDay.activities){activity in
                    Text(activity.name)
                        .foregroundStyle(currentDay.compDict[activity.name] == true ? .green : .black)
                        .swipeActions{
                            
                            Button("delete", systemImage: "trash", role: .destructive) {
                                modelContext.delete(activity)
                            }
                            if currentDay.compDict[activity.name] == false{
                                Button("completed", systemImage: "checkmark.circle"){
                                    currentDay.compDict[activity.name] = true
                                    try? modelContext.save()
                                }
                            }else{
                                Button("incomplete", systemImage: "x.circle"){
                                    currentDay.compDict[activity.name] = false
                                    try? modelContext.save()
                                }
                            }
                        }
                        
                }
            }
        }
        
        .padding()
    }
    
    func getActivities()-> [Activity]{
        return activities
    }
}


#Preview {
    ContentView()
}

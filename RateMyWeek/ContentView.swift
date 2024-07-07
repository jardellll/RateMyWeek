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
            let componets = Calendar.current.dateComponents([.weekOfYear], from: currentDay?.date ?? Date.now)
            let weekOfYear = componets.weekOfYear ?? 0
            Text("the week of the year is \(weekOfYear)")
            if let currentDay = currentDay{
                List(currentDay.activities){activity in
                    HStack{
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
                        
                        Spacer()
                        
                        Text(getWeekScore(act: activity, currentDay: currentDay))
                        
                    }
                }
            }
        }
        
        .padding()
    }
    
    func getActivities()-> [Activity]{
        return activities
    }
    func getWeekScore(act: Activity, currentDay: Day ) -> String{
        
        let componets = Calendar.current.dateComponents([.weekOfYear], from: currentDay.date)
        let weekOfYear = componets.weekOfYear
        var dayComp = Calendar.current.dateComponents([.day], from: currentDay.date)
        
        //find seven days before
        var forwardDays = [String]()
        var forwardCount = 0
        Calendar.current.enumerateDates(startingAfter: currentDay.date, matching: DateComponents(hour: 0), matchingPolicy: .nextTime,repeatedTimePolicy: .first, direction: .forward){ (date, _ , stop) in
            
            forwardCount += 1
            if date != nil && forwardDays.count < 8 {
                forwardDays.append(date!.formatted(date: .abbreviated, time: .omitted))
            }
            if forwardCount == 7{
                stop = true
            }
            
            
        }
        
        
        //find seven days after
        var backwardDays = [String]()
        var backwardCount = 0
        Calendar.current.enumerateDates(startingAfter: currentDay.date, matching: DateComponents(hour: 0), matchingPolicy: .nextTime,repeatedTimePolicy: .first, direction: .backward){ (date, _ , stop) in
            
            backwardCount += 1
            if date != nil && backwardDays.count < 8 {
                backwardDays.append(date!.formatted(date: .abbreviated, time: .omitted))
            }
            
            if backwardCount == 7{
                stop = true
            }
        }
        
        //combine the two then check which ones are in the same week as the day passed in
        var dayRange = [String]()
        dayRange.append(contentsOf: forwardDays)
        dayRange.append(contentsOf: backwardDays)
        //print(dayRange)
        var sameWeekDays = [Day]()
        
        for day in days{
            var dayyyyy = day.date.formatted(date: .abbreviated, time: .omitted)
            var c = Calendar.current.dateComponents([.weekOfYear], from: day.date)
            var week = c.weekOfYear
            if week != nil {
                print(week!)
            }
            else {print("no week")}
            
            if (dayRange.contains(dayyyyy) && week == weekOfYear){
                sameWeekDays.append(day)
                print("found a day in the same week")
            }
        }
        print("--------------------------")
        
        //now check if they have the activity completed
        var activityCount = 0
        
        for sameWeekDay in sameWeekDays{
            if sameWeekDay.compDict[act.name] == true{
                activityCount += 1
            }
        }
//        if currentDay.compDict[act.name] == true{
//            activityCount += 1
//        }
        var freqency = act.freqency
        
        return ("\(activityCount)/\(freqency)")
        
    }
}


#Preview {
    ContentView()
}

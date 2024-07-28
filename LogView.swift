//
//  LogView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/14/24.
//

import SwiftUI
import SwiftData
struct LogView: View {
    @Environment(\.modelContext) var modelContext
    @State private var chosenDay = Date.now
    @State private var showingSheet = false
    @State private var showingWeightSheet = false
    @Query var days : [Day]
    @Query var activities : [Activity]
    
    //@Query var dayList : [DayList]
    
    @State private var actForDay = [Activity]()
    @State private var foundMatch = false
    @State private var currentDay: Day?
   

    var body: some View {
        NavigationStack{
            VStack {
                
                    
                HStack{
                    Spacer()
                    Button("edit weights"){
                        print("week weight 1 \(showingWeightSheet)")
                        showingWeightSheet.toggle()
                        print("week weight 2 \(showingWeightSheet)")
                    }
                    .sheet(isPresented: $showingWeightSheet){
                        //print("showing week weights sheet")
                        WeekWeightsView()
                    }
                    Spacer()
                    Spacer()
                    Button("new activity"){
                        print("new activity 1 \(showingSheet)")
                        showingSheet.toggle()
                        print("new activity 2 \(showingSheet)")
                    }
                    .sheet(isPresented: $showingSheet){
                        NewActivityView()
                    }
//                    Button("clear everything"){
//                        do {
//                            try modelContext.delete(model: Activity.self)
//                            print("deleted all activities.")
//                        } catch {
//                            print("Failed to delete all activities.")
//                        }
//                        do {
//                            try modelContext.delete(model: Day.self)
//                            print("deleted all days.")
//                        } catch {
//                            print("Failed to delete all days.")
//                        }
//                    }
                    Spacer()
                    
                    
                }
                 
                Form{
                    Section{
                        Text(currentDay == nil ? "--" : "\(getOverallWeekScore(day: currentDay!, activities: activities, days: days))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Section{
                        DatePicker("choose a day", selection: $chosenDay, displayedComponents: .date)
                            .onChange(of: chosenDay, initial: true){
                                foundMatch = false
                                for day in days{
                                    
                                    //if day.date == chosenDay{
                                    if getStrDate(day: day.date) == getStrDate(day: chosenDay){
                                        print("found a match")
                                        foundMatch = true
                                        print (day.date)
                                        print (chosenDay)
                                        print(day.activities)
                                        //actForDay = day.activities
                                        currentDay = day
                                        print(day.compDict)
                                        
                                    }
                                }
                                if foundMatch == false{
                                    let newDay = Day(date: chosenDay, activities: [], compDict: [:])
                                    print("new day")
                                    modelContext.insert(newDay)
                                    for act in activities{
                                        //print(act.startDate!)
                                        print(newDay.date)
                                        let calendar = Calendar.current
                                        let actStartDate = calendar.dateComponents([.year, .month, .day],from: act.startDate ?? Date.now)
                                        let newDayDate = calendar.dateComponents([.year, .month, .day],from: newDay.date)
                                        let actStartDt = calendar.date(from: actStartDate)!
                                        let newDayDt =  calendar.date(from: newDayDate)!
                                        
                                        if (actStartDt <= newDayDt){
                                            newDay.activities.append(act)
                                            newDay.compDict[act.id.uuidString] = false
                                        }
                                    }
                                    print(newDay.compDict)
                                    actForDay = newDay.activities
                                    currentDay = newDay
                                    try? modelContext.save()
                                    
                                    
                                }
                            }
                    }
                    //            let componets = Calendar.current.dateComponents([.weekOfYear], from: currentDay?.date ?? Date.now)
                    //            let weekOfYear = componets.weekOfYear ?? 0
                    //            Text("the week of the year is \(weekOfYear)")
                    Section{
                        if let currentDay = currentDay{
                            List(currentDay.activities){activity in
                                HStack{
                                    NavigationLink(destination: ActivityView(activity: activity)){
                                        //ActivityView(activity: activity)
                                    //}label: {
                                        Text(activity.name)
                                            .foregroundStyle(currentDay.compDict[activity.id.uuidString] == true ? .green : .primary)
                                            .swipeActions{
                                                
                                                Button("delete", systemImage: "trash", role: .destructive) {
                                                    modelContext.delete(activity)
                                                }
                                                if currentDay.compDict[activity.id.uuidString] == false{
                                                    Button("completed", systemImage: "checkmark.circle"){
                                                        currentDay.compDict[activity.id.uuidString] = true
                                                        try? modelContext.save()
                                                    }
                                                }else{
                                                    Button("incomplete", systemImage: "x.circle"){
                                                        currentDay.compDict[activity.id.uuidString] = false
                                                        try? modelContext.save()
                                                    }
                                                }
                                            }
                                    }
                                    
                                    
                                    Spacer()
                                    
                                    
                                    Text("\(getWeekScore(act: activity, currentDay: currentDay, days: days))/\(activity.freqency)")
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("RateMyWeek")
        }
        
    
    }
    
    func getActivities()-> [Activity]{
        return activities
    }
    func getStrDate(day: Date)->String{
        return day.formatted(date: .abbreviated, time: .omitted)
    }
    
    
    
    
}

#Preview {
    LogView()
}

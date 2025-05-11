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
    @State private var showingNotificationSheet = false
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
//                    Button("edit notifications"){
//                        checkForPermission()
//                        //showingNotificationSheet.toggle()
//                    }
//                    .sheet(isPresented: $showingNotificationSheet){
//                        NotificationView()
//                    }
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
                        Text(currentDay == nil ? "--" : String(format: "%.2f",(getOverallWeekScore(day: currentDay!, activities: activities, days: days))))
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
                    Section {
                        if let currentDay = currentDay {
                            List(currentDay.activities) { activity in
                                VStack {
                                    HStack {
                                        // NavigationLink should only wrap the text or view you want to be tappable for navigation
                                        NavigationLink(destination: ActivityView(activity: activity)) {
                                            HStack {
                                                Text(activity.name)
                                                    .foregroundStyle(currentDay.compDict[activity.id.uuidString] == true ? .green : .primary)
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    HStack {
                                        Text("\(getWeekScore(act: activity, currentDay: currentDay, days: days))/\(activity.freqency)")
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            //withAnimation(.scale){
                                                if currentDay.compDict[activity.id.uuidString] == false {
                                                    currentDay.compDict[activity.id.uuidString] = true
                                                    try? modelContext.save()
                                                    print("Checkmark button pressed")
                                                }else if currentDay.compDict[activity.id.uuidString] == true{
                                                    print("it's false")
                                                }
                                          // }
                                        }) {
                                            Image(systemName: "checkmark.circle")
                                                .imageScale(.large)
                                                .foregroundColor(.green)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        Button(action: {
                                            //withAnimation(.scale){
                                                if currentDay.compDict[activity.id.uuidString] == true {
                                                    currentDay.compDict[activity.id.uuidString] = false
                                                    try? modelContext.save()
                                                    print("X button pressed")
                                                }
                                          //  }
                                        }) {
                                            Image(systemName: "x.circle")
                                                .imageScale(.large)
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        
                                    }
                                    //.padding(.top, 5)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        modelContext.delete(activity)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
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
    func checkForPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings{ settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow{
                        showingNotificationSheet.toggle()
                    }
                    
                }
            case .denied:
                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow{
                        showingNotificationSheet.toggle()
                    }
                }
            case .authorized:
                showingNotificationSheet.toggle()
            default:
                return
            }
        }
    }
    
    
    
    
}

#Preview {
    LogView()
}

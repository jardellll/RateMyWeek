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
                        
                        }
                    }
                    if foundMatch == false{
                        let newDay = Day(date: chosenDay, activities: [])
                        print("new day")
                        modelContext.insert(newDay)
                        for act in activities{
                            newDay.activities.append(act)
                        }
                        actForDay = newDay.activities
                     
                        
                    }
                }
                    
                
            List(actForDay){activity in
                Text(activity.name)
                    .swipeActions{
                        
                        Button("delete", systemImage: "trash", role: .destructive) {
                            modelContext.delete(activity)
                        }
                        Button("completed", systemImage: "checkmark.circle"){
                            
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

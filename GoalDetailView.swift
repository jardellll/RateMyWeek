//
//  GoalDetailView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/15/24.
//

import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Query var activities: [Activity]
    var goal: Goal
    @State private var edit = false
    @State private var editOrCancel = "edit"
    @State private var newName = ""
    @State private var newOverallDef = ""
    @State private var newOneYearDef = ""
    @State private var newFiveYearDef = ""
    var body: some View {
        NavigationStack{
            Button(editOrCancel){
                if !edit{
                    newName = goal.name
                    newOverallDef = goal.overallDef
                    newOneYearDef = goal.oneYearDef
                    newFiveYearDef = goal.fiveYearDef
                    editOrCancel = "cancel"
                    edit.toggle()
                }else{
                    editOrCancel = "edit"
                    edit.toggle()
                }
            }
            if !edit{
                List{
                    Section("overall definition"){
                        Text("\(goal.overallDef)")
                    }
                    Section("Categories"){
                        ForEach(goal.category) {cat in
                            Text(cat.rawValue)
                        }
                    }
                    Section("activities"){
                        if !goal.activities.isEmpty{
                            ScrollView(.horizontal, showsIndicators: true){
                                HStack(spacing: 50){
                                    ForEach(activities){act in
                                        if goal.activities.contains(act.id.uuidString){
                                            Text(act.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Section("one year definition"){
                        Text("\(goal.oneYearDef)")
                    }
                    Section("five year definition"){
                        Text("\(goal.fiveYearDef)")
                    }
                }
                .navigationTitle(goal.name)
            }else{
                List{
                    Section("rename"){
                        TextField("\(goal.name)",text:$newName)
                    }
                    Section("overall definition"){
                        TextEditor(text: $newOverallDef)
                    }
                    Section("choose a category"){
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack(spacing: 50){
                                ForEach(Goal.categories.allCases){ cat in
                                    Button(cat.rawValue){
                                        if goal.category.contains(cat){
                                            if let index = goal.category.firstIndex(of: cat){
                                                goal.category.remove(at: index)
                                            }
                                        }else{
                                            goal.category.append(cat)
                                        }
                                        print(goal.category)
                                    }
                                    .foregroundStyle(goal.category.contains(cat) == true ? .green : .primary)
                                }
                            }
                        }
                    }
                    Section("add existing activities to this goal"){
                        if !activities.isEmpty{
                            ScrollView(.horizontal, showsIndicators: true){
                                HStack(spacing: 50){
                                    ForEach(activities){act in
                                        Button("\(act.name)"){
                                            if goal.activities.contains(act.id.uuidString){
                                                if let index = goal.activities.firstIndex(of: act.id.uuidString){
                                                    goal.activities.remove(at: index)
                                                }
                                            }else{
                                                goal.activities.append(act.id.uuidString)
                                            }
                                            print(goal.activities)
                                            
                                        }
                                        .foregroundStyle(goal.activities.contains(act.id.uuidString) == true ? .green : .primary)
                                    }
                                }
                            }
                        }
                    }
                    Section("one year definition"){
                        TextEditor(text: $newOneYearDef)
                    }
                    Section("five year definition"){
                        TextEditor(text: $newFiveYearDef)
                    }
                    Section(){
                        Button("save"){
                            goal.name = newName
                            goal.overallDef = newOverallDef
                            goal.oneYearDef = newOneYearDef
                            goal.fiveYearDef = newFiveYearDef
                            editOrCancel = "edit"
                            edit = false
                        }
                    }
                }
                    .navigationTitle(goal.name)
                
            }
            
        }
    }
}

#Preview {
    GoalDetailView(goal: Goal(name: "goal 1", overallDef: "jwnwi", oneYearDef: "wnkeonfw", fiveYearDef: "djonwdd", activities: [], category: []))
}

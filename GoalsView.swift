//
//  GoalsView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/14/24.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var creatingNewGoal = false
    @State private var goalName = ""
    @State private var overallDef = ""
    @State private var oneYearDef = ""
    @State private var fiveYearDef = ""
    @State private var goalActivities = [Activity]()
    @State private var goalCategories = [Goal.categories]()
    
    @Query var goals: [Goal]
    @Query var activities: [Activity]
    var body: some View {
        NavigationStack{
            Button("create new goal"){
                creatingNewGoal = true
            }
            if creatingNewGoal{
                List{
                    TextField("name", text: $goalName)
                    Section("overall definition"){
                        TextEditor(text: $overallDef)
                    }
                    Section("one year definition"){
                        TextEditor(text: $oneYearDef)
                    }
                    Section("five year definition"){
                        TextEditor(text: $fiveYearDef)
                    }
                    Section("choose a category"){
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack(spacing: 50){
                                ForEach(Goal.categories.allCases){ cat in
                                    Button(cat.rawValue){
                                        if goalCategories.contains(cat){
                                            if let index = goalCategories.firstIndex(of: cat){
                                                goalCategories.remove(at: index)
                                            }
                                        }else{
                                            goalCategories.append(cat)
                                        }
                                        print(goalCategories)
                                    }
                                    .foregroundStyle(goalCategories.contains(cat) == true ? .green : .primary)
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
                                            if goalActivities.contains(act){
                                                if let index = goalActivities.firstIndex(of: act){
                                                    goalActivities.remove(at: index)
                                                }
                                            }else{
                                                goalActivities.append(act)
                                            }
                                            print(goalActivities)
                                            
                                        }
                                        .foregroundStyle(goalActivities.contains(act) == true ? .green : .primary)
                                    }
                                }
                            }
                        }
                    }
                    Section{
                        Button("save"){
                            let newGoal = Goal(name: goalName, overallDef: overallDef, oneYearDef: oneYearDef, fiveYearDef: fiveYearDef, activities: goalActivities, category: goalCategories)
                            
                            modelContext.insert(newGoal)
                            //newGoal.category.
                            
                            //modelContext.insert(newGoal)
                            creatingNewGoal = false
                        }
                        Button("cancel"){
                            creatingNewGoal = false
                        }
                    }
                }
            }
            else{
                List(goals){ goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)){
                        Text(goal.name)
                            .swipeActions{
                                Button("delete",systemImage: "trash", role: .destructive){
                                    modelContext.delete(goal)
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    GoalsView()
}

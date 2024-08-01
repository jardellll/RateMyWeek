//
//  WeekWeightsView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/7/24.
//

import SwiftUI
import SwiftData
struct WeekWeightsView: View {
    
    @Query var activities : [Activity]
    @State private var weights = [String:Int]()
    @State private var newWeights = [String:Int]()
    @Environment(\.modelContext) var modelContext
    @State private var weightsChanged = false
    @State private var weightTotal = 0
    @State private var weight = [Int]()
    @State private var weightAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    List (activities){ act in
                        Section{
                            HStack{
                                VStack{
                                    Text(act.name)
                                    Text("curr weight = \(getWeight(name: act.name))")
                                }
                                //Text("             ")
                                //Spacer()
                                TextField("enter new weight", value: Binding(
                                    get: { newWeights[act.name] ?? getWeight(name: act.name) },
                                    set: { newWeights[act.name] = $0 }), formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                Spacer()
                                Spacer()
                                Spacer()
                                //                    .onChange(of: weight){
                                //                        newWeights[act.name] = weight
                                //                    }
                            }
                        }
                    }
                    .onAppear(){
                        for act in activities{
                            newWeights[act.name] = act.weight
                        }
                    }
                    .onChange(of: weights){
                        //            for value in weights.values{
                        //                weightTotal += value
                        //            }
                        //            weightsChanged = true
                    }
                }
                Section{
                    Button("save"){
                        print(newWeights.values)
                        for value in newWeights.values{
                            weightTotal += value
                            print(weightTotal)
                        }
                        weightsChanged = true
                        if weightsChanged && weightTotal == 100{
                            setWeights(weights: newWeights)
                            dismiss()
                        }
                        else{
                            weightAlert = true
                        }
                        
                    }
                    //.disabled(weightsChanged == false)
                    .alert("weights must equal 100",isPresented: $weightAlert){
                        Button("ok"){ }
                    }
                    Button("cancel"){
                        dismiss()
                    }
                }
            }.navigationTitle("weight editor")
        }
        
    }
    func getWeights() -> [String:Int] {
        var weights = [String:Int]()
        for act in activities{
            weights[act.name] = act.weight
        }
        return weights
    }
    func getWeight(name: String) -> Int {
        var weight = 0
        for act in activities{
            if act.name == name{
                weight = act.weight ?? -1
                break
            }
        }
        return weight
    }
    func setWeights(weights : [String:Int]){
//        var total = 0
//        for value in weights.values{
//            total += value
//        }
//        if total == 100{
            for activity in activities {
                for weight in weights{
                    if weight.key == activity.name{
                        activity.weight = weights[activity.name]
                        break
                    }
                }
                
            }
            try? modelContext.save()
            
        
    }
}

#Preview {
    WeekWeightsView()
}

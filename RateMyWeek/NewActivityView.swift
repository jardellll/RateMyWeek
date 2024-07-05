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
    @State private var name = ""
    @State private var frequency = 0
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form{
            TextField("name your activity", text: $name)
            Picker("how many times per week?", selection: $frequency){
                ForEach(1..<8){
                    Text("\($0)")
                }
            }
            
            Button("save"){
                let newActivity = Activity(name: name, freqency: frequency, days: [])
                modelContext.insert(newActivity)
                //Activities.activities.append(newActivity)
                dismiss()
            }
            Button("cancel"){
                dismiss()
            }
        }
        
        
    }
}

#Preview {
    NewActivityView()
}


// instead of trying to store an array of activities as a swiftdata thing, I can just query all the activities and put that in a list, then pair it up with the day class

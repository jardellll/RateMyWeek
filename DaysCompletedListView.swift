//
//  DaysCompletedListView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/10/24.
//

import SwiftUI

struct DaysCompletedListView: View {
    var days: [Day]
    var body: some View {
        List(days){ day in
            
            Text(day.date.formatted(date: .abbreviated, time: .omitted))
        }
        .navigationTitle("days completed")
    }
}

#Preview {
    DaysCompletedListView(days: [])
}

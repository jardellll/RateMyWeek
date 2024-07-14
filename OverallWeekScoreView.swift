//
//  OverallWeekScoreView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/13/24.
//

import SwiftUI
import SwiftData

struct OverallWeekScoreView: View {
    @Query var days : [Day]
    @Query var activities : [Activity]
    var weekNum: Int
    var yearNum: Int
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    func getOverallWeekScore(weekNum: Int, yearNum: Int)->Int{
        var sameWeekDays = [Day]()
        for day in days{
            let comp = Calendar.current.dateComponents([.weekOfYear, .year], from: day.date)
            let weekComp = comp.weekOfYear
            let yearComp = comp.year
            
            if weekComp == weekNum && yearComp == yearNum{
                sameWeekDays.append(day)
            }
        }
        
        //var overallWeekScore = 0
        
        for day in sameWeekDays{
            for act in activities{
                if day.compDict[act.id.uuidString] ?? false{
                    
                }
            }
        }
        
        
        
        return 0
    }
}

#Preview {
    OverallWeekScoreView(weekNum: 28, yearNum: 2024)
}

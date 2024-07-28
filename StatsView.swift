//
//  StatsView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/14/24.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query var days : [Day]
    @Query var activities : [Activity]
    @State private var count = 0
    @State private var weekMap = [Day : String]()
    @State private var weekNum = "no week"
    var body: some View {
        List{
            Section{
                ScrollView(.horizontal, showsIndicators: true){
                    HStack(spacing: 50){
                        let weekList = getWeeks(days: days)
                        
                        ForEach(weekList, id: \.self){ week in
                            Button{
                                weekNum = week
                            }label: {
                                VStack{
                                    Text("week: \(week)")
                                    let ODPW = OneDayPerWeek(curWeekNum: week, days: days)
                                    Text("\(getOverallWeekScore(day:ODPW.first!, activities:activities, days:days))")
                                    
                                }
                            }
                            
                        }
                        //                    ForEach(ODPW){ day in
                        //                        Text("\(getOverallWeekScore(day:day,activities:activities,days:days))")
                        //                        weekMap[day] = weekList[0]
                        //                    }
                    }
                }
            }
            Section{
                if weekNum != "no week"{
                    let ODPW = OneDayPerWeek(curWeekNum: weekNum, days: days)
                    ForEach(ODPW.first!.activities, id: \.self){act in
                        HStack{
                            Text(act.name)
                            Text("\(getWeekScore(act: act, currentDay:ODPW.first!, days: days))/\(act.freqency)")
                        }
                    }
                }
            }
        }
        
    }
//    func createMap(weekList: [String], ODPW: [Day])-> [String : Day]{
//        var weekMap = [String : Day]()
//        var count = 0
//        ForEach(weekList, id: \.self){week in
//            weekMap[week] = ODPW.first
//            count += 1
//        }
//        ForEach(0..<weekList.count, id: \.self){ i in
//            let week = weekList[i]
//            let day = ODPW[i]
//            weekMap[week] = day
//        }
//    }
    func getWeeks(days: [Day])-> [String]{
        var weekList = [String]()
        for day in days{
            let comp = Calendar.current.dateComponents([.weekOfYear], from: day.date)
            let weekNum = comp.weekOfYear
            if !weekList.contains(String(weekNum ?? 0)){
                weekList.append(String(weekNum ?? 0))
            }
        }
        var sortedWeekList: [String]{
            weekList.sorted{ Int($0)! < Int($1)!}
        }
        return sortedWeekList
        
    }
    func OneDayPerWeek(curWeekNum: String, days: [Day])-> [Day]{
        var dayList = [Day]()
        //for week in weekList{
            for day in days {
                let comp = Calendar.current.dateComponents([.weekOfYear], from: day.date)
                let weekNum = comp.weekOfYear
                if Int(curWeekNum) == weekNum{
                    dayList.append(day)
                    break
                }
                
            }
       // }
        return dayList
    }
    
    
    //so the functions from the previous page are accessible
    //I just need to create a scroll view kinda that stores the weeks of the year
    //then the person can select a week
    //it'll be some work since I will have to create the scroll view by myself. I can get the week numbers from all the days
        //maybe loop through all the days that are stored and extract all the unique week numbers, then with the list of weeks, create the scrollView
    //all the score related functions take in a specific day, either I change them to take a week or given the week I pass in a day of that week so the function is happy
}

#Preview {
    StatsView()
}

//
//  StatsView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/14/24.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query var days : [Day]
    @Query var activities : [Activity]
    @State private var count = 0
    @State private var weekMap = [Day : String]()
    @State private var weekNum = "no week"
    @State private var weeks = [Week]()
    @State private var weekList = [String]()
    var body: some View {
        NavigationStack{
            //VStack{
                List{
                    Section(){
                        ScrollView(.horizontal, showsIndicators: true){
                            HStack(spacing: 50){
                                let weekListL = getWeeks(days: days)
                                
                                ForEach(weekListL, id: \.self){ week in
                                    Button{
                                        weekNum = week
                                        //weekList = getWeeks(days: days)
                                        
                                        //                                    var newWeek = Week(dateRange: getWeekDateRange(currentDay: OneDayPerWeek(curWeekNum: week, days: days).first!, days: days), score: getOverallWeekScore(day:OneDayPerWeek(curWeekNum: week, days: days).first!, activities:activities, days:days))
                                        //                                    weeks.append(newWeek)
                                    }label: {
                                        VStack{
                                            //Text("week: \(week)")
                                            let ODPW = OneDayPerWeek(curWeekNum: week, days: days)
                                            var weekDateRange = getWeekDateRange(currentDay: ODPW.first!, days: days)
                                            Text("\(weekDateRange.0)")
                                            Text(String(format: "%.2f",(getOverallWeekScore(day:ODPW.first!, activities:activities, days:days))))
                                            
                                        }
                                    }
                                    
                                }
                                //                    ForEach(ODPW){ day in
                                //                        Text("\(getOverallWeekScore(day:day,activities:activities,days:days))")
                                //                        weekMap[day] = weekList[0]
                                //                    }
                            }
                        }
                        
                        if weekNum != "no week"{
                            //Divider()
                            let ODPW = OneDayPerWeek(curWeekNum: weekNum, days: days)
                            ForEach(ODPW.first!.activities, id: \.self){act in
                                VStack{
                                    HStack{
                                        Text(act.name)
                                            .font(.headline)
                                        
                                        Spacer()
                                        Text("\(getWeekScore(act: act, currentDay:ODPW.first!, days: days))/\(act.freqency)")
                                    }
                                    
                                    HStack{
                                        let daysCompleted = getDaysCompleted(act: act, currentDay: ODPW.first!, days: days)
                                        Text("Sun")
                                            .foregroundStyle(daysCompleted["Sun"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Mon")
                                            .foregroundStyle(daysCompleted["Mon"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Tues")
                                            .foregroundStyle(daysCompleted["Tues"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Wed")
                                            .foregroundStyle(daysCompleted["Wed"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Thurs")
                                            .foregroundStyle(daysCompleted["Thurs"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Fri")
                                            .foregroundStyle(daysCompleted["Fri"] == true ? .green : .primary)
                                        Spacer()
                                        Text("Sat")
                                            .foregroundStyle(daysCompleted["Sat"] == true ? .green : .primary)
                                    }
                                }
                            }
                        }
                    }header: {
                        Text("by week")
                    }
//                    Section{
//                        if weekNum != "no week"{
//                            let ODPW = OneDayPerWeek(curWeekNum: weekNum, days: days)
//                            ForEach(ODPW.first!.activities, id: \.self){act in
//                                VStack{
//                                    HStack{
//                                        Text(act.name)
//                                            .font(.headline)
//                                        
//                                        Spacer()
//                                        Text("\(getWeekScore(act: act, currentDay:ODPW.first!, days: days))/\(act.freqency)")
//                                    }
//                                    
//                                    HStack{
//                                        let daysCompleted = getDaysCompleted(act: act, currentDay: ODPW.first!, days: days)
//                                        Text("Sun")
//                                            .foregroundStyle(daysCompleted["Sun"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Mon")
//                                            .foregroundStyle(daysCompleted["Mon"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Tues")
//                                            .foregroundStyle(daysCompleted["Tues"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Wed")
//                                            .foregroundStyle(daysCompleted["Wed"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Thurs")
//                                            .foregroundStyle(daysCompleted["Thurs"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Fri")
//                                            .foregroundStyle(daysCompleted["Fri"] == true ? .green : .primary)
//                                        Spacer()
//                                        Text("Sat")
//                                            .foregroundStyle(daysCompleted["Sat"] == true ? .green : .primary)
//                                    }
//                                }
//                            }
//                        }
//                    }header: {
//                        Text("days")
//                    }
                    Section(){
                        weekChart(weeks: weeks)
                            .frame(height: 300)
                        
                    }header: {
                        Text("overall trend")
                    }
                }
                .listStyle(SidebarListStyle())
                .onAppear(){
                    weekList = getWeeks(days: days)
                    weeks.removeAll()
                    for week in weekList {
                        var ODPW = OneDayPerWeek(curWeekNum: week, days: days).first!
                        //var dateRange = (String,String)()
                        var dateRange = getWeekDateRange(currentDay: ODPW, days: days)
                        var weekScore = getOverallWeekScore(day:ODPW, activities:activities, days:days)
                        var newWeek = Week(dateRange: dateRange.1, score: weekScore)
                        weeks.append(newWeek)
                    }
                }
                .navigationTitle("Stats")
                .navigationBarTitleDisplayMode(.inline)
                
            //}
            
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
    
struct weekChart: View {
    var weeks: [Week]
    var body: some View {
        
        Chart(weeks){ week in
                LineMark(
                        x: .value("week of", week.dateRange),
                        y: .value("score", week.score)
                )
                PointMark(
                    x: .value("week of", week.dateRange),
                    y: .value("score", week.score)
                )
                .annotation(position:.automatic, alignment: .bottom, spacing: 5){
                    Text("\(String(format: "%.2f",week.score))")
                }
            
        }
        .chartScrollableAxes(.horizontal)
        
        
        
    }
    
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

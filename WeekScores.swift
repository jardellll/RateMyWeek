//
//  WeekScores.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 7/22/24.
//

import Foundation
import SwiftData

func getSameWeekDays(currentDay: Day , days: [Day])-> [Day]{
    let componets = Calendar.current.dateComponents([.weekOfYear], from: currentDay.date)
    let weekOfYear = componets.weekOfYear
    _ = Calendar.current.dateComponents([.day], from: currentDay.date)
    
    let currDayYearComp = Calendar.current.dateComponents([.year], from: currentDay.date)
    let currDayYearCompInt = currDayYearComp.year
    
    //find seven days before
    var forwardDays = [String]()
    var forwardCount = 0
    Calendar.current.enumerateDates(startingAfter: currentDay.date, matching: DateComponents(hour: 0), matchingPolicy: .nextTime,repeatedTimePolicy: .first, direction: .forward){ (date, _ , stop) in
        
        forwardCount += 1
        if date != nil && forwardDays.count < 8 {
            let comp = Calendar.current.dateComponents([.year], from: date!)
            let dateYear = comp.year
            if dateYear! == currDayYearCompInt {
                forwardDays.append(date!.formatted(date: .abbreviated, time: .omitted))
            }
        }
        if forwardCount == 7{
            stop = true
        }
        
        
    }
    
    
    //find seven days after
    var backwardDays = [String]()
    var backwardCount = 0
    Calendar.current.enumerateDates(startingAfter: currentDay.date, matching: DateComponents(hour: 0), matchingPolicy: .nextTime,repeatedTimePolicy: .first, direction: .backward){ (date, _ , stop) in
        
        backwardCount += 1
        if date != nil && backwardDays.count < 8 {
            let comp = Calendar.current.dateComponents([.year], from: date!)
            let dateYear = comp.year
            if dateYear! == currDayYearCompInt {
                
                backwardDays.append(date!.formatted(date: .abbreviated, time: .omitted))
            }
        }
        
        if backwardCount == 7{
            stop = true
        }
    }
    
    //combine the two then check which ones are in the same week as the day passed in
    var dayRange = [String]()
    dayRange.append(contentsOf: forwardDays)
    dayRange.append(contentsOf: backwardDays)
    //print(dayRange)
    var sameWeekDays = [Day]()
    
    for day in days{
        let dayyyyy = day.date.formatted(date: .abbreviated, time: .omitted)
        let c = Calendar.current.dateComponents([.weekOfYear], from: day.date)
        let week = c.weekOfYear
        let comp = Calendar.current.dateComponents([.year], from: day.date)
        let dayYear = comp.year
        if week != nil {
            print(week!)
        }
        else {print("no week")}
        
        if (dayRange.contains(dayyyyy) && week == weekOfYear && dayYear == currDayYearCompInt){
            sameWeekDays.append(day)
            if Calendar.current.dateComponents([.year], from: day.date) == Calendar.current.dateComponents([.year], from: currentDay.date) {
                print("found a day in the same week")
            }
        }
    }
    print("--------------------------")
    
    return sameWeekDays
}

func getWeekScore(act: Activity, currentDay: Day , days: [Day]) -> Int{
    print("starting for one day")
    
    let sameWeekDays = getSameWeekDays(currentDay: currentDay, days: days)
    //now check if they have the activity completed
    var activityCount = 0
    
    for sameWeekDay in sameWeekDays{
        if sameWeekDay.compDict[act.id.uuidString] == true{
            activityCount += 1
        }
    }
//        if currentDay.compDict[act.name] == true{
//            activityCount += 1
//        }\
    
    return activityCount
//        let freqency = act.freqency
//        print("ending for one day")
//        return ("\(activityCount)/\(freqency)")
    
}

func getOverallWeekScore(day: Day, activities: [Activity], days: [Day])-> Double{
    var overallWeekScore = 0.00
    for act in activities{
        let actWeekScore = Double(getWeekScore(act: act, currentDay: day, days: days))
        let freq = Double(act.freqency)
        let weight = Double(act.weight ?? 1)
        let weightedScore = actWeekScore/freq * (weight)
        overallWeekScore += weightedScore
    }
    return overallWeekScore
}
func getDaysCompleted(act: Activity,currentDay: Day , days: [Day])-> [String: Bool] {
    
    let sameWeekDays = getSameWeekDays(currentDay: currentDay, days: days)
    var daysCompleted : [String: Bool] = [:]
    var weekdayTranslation : [Int: String] = [:]
    
    weekdayTranslation [1] = "Sun"
    weekdayTranslation [2] = "Mon"
    weekdayTranslation [3] = "Tues"
    weekdayTranslation [4] = "Wed"
    weekdayTranslation [5] = "Thurs"
    weekdayTranslation [6] = "Fri"
    weekdayTranslation [7] = "Sat"
    
    for sameWeekDay in sameWeekDays{
        let comp = Calendar.current.dateComponents([.weekday], from: sameWeekDay.date)
        let weekday = comp.weekday
        let weekdayString = weekdayTranslation[weekday!]
        if sameWeekDay.compDict[act.id.uuidString] == true{
            
            daysCompleted[weekdayString!] = true
        }else{
            daysCompleted[weekdayString!] = false
        }
    }
    
    return daysCompleted
}

func getWeekDateRange(currentDay: Day , days: [Day])-> (String, String){
    let sameWeekDays = getSameWeekDays(currentDay: currentDay, days: days).sorted(by:{ $0.date < $1.date })
    var dateRangeLong = sameWeekDays.first!.date.formatted(date: .abbreviated, time: .omitted)
    dateRangeLong.append(" - ")
    dateRangeLong.append(sameWeekDays.last!.date.formatted(date: .abbreviated, time: .omitted))
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd"
    
    var dateRangeShort = dateFormatter.string(from: sameWeekDays.first!.date)
    dateRangeShort.append(" - ")
    dateRangeShort.append(dateFormatter.string(from:sameWeekDays.last!.date))
    
    
    return (dateRangeLong, dateRangeShort)
}

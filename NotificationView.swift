//
//  NotificationView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 8/11/24.
//

import SwiftUI
import UserNotifications
import SwiftData

struct NotificationView: View {
    //@StateObject var delgate = NotificationDelegate(activities: [], days: [], modelContext: )
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    let defaults = UserDefaults.standard
    @Query var activities : [Activity]
    @State private var notifiNum = 0
    var notifiNums = [0,1,2,3,4,5,6,7]
    @State private var selectedTimes: [Date] = Array(repeating: Date(), count: 8)
    @Query var days : [Day]
    var body: some View {
        NavigationStack{
            List{
                Section{
                    Text("how many times per day would you like to be notified?")
                    Picker("how many times per day would you like to be notified?", selection: $notifiNum){
                        ForEach(notifiNums, id: \.self){ num in
                            Text("\(num)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                Section{
                    ForEach(0..<notifiNum, id: \.self){ index in
                        DatePicker("notification \(index+1)", selection: $selectedTimes[index], displayedComponents: .hourAndMinute)
                    }
                }
                Section{
                    Button("save"){
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        sendNotification(times: selectedTimes)
                        defaults.set(notifiNum, forKey: "NotifiNumber")
                        defaults.set(selectedTimes, forKey: "Times")
                        dismiss()
                    }
                    Button("cancel"){
                        dismiss()
                    }
                }
            }
            .onAppear(){
                let delegate = NotificationDelegate(activities: activities, days: days, modelContext: modelContext)
                UNUserNotificationCenter.current().delegate = delegate
                //print("Delegate set successfully")
                notifiNum = defaults.integer(forKey: "NotifiNumber")
                selectedTimes = defaults.object(forKey: "Times") as? [Date] ?? [Date](repeating: Date.now, count: 8)
            }
            .navigationTitle("Notification Settings")
        }
    }
//    func checkForPermission(){
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings{ settings in
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
//                    if didAllow{
//                        self.sendNotification()
//                    }
//                    
//                }
//            case .denied:
//                return
//            case .authorized:
//                self.sendNotification()
//            default:
//                return
//            }
//        }
//    }
    func sendNotification(times: [Date]){
//        let title = "Update your progress"
//        let body = "check an activity off your list"
        var activityActions = [UNNotificationAction]()
        for act in activities{
            let name = act.name+"Action"
            let actAction = UNNotificationAction(identifier: name, title: act.name)
            activityActions.append(actAction)
        }
        
        let notificationCategory = UNNotificationCategory(identifier: "ACTIVITY_COMPLETION", actions: activityActions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "",options: .customDismissAction)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([notificationCategory])
        
        let content = UNMutableNotificationContent()
        content.title = "Update your progress"
        content.subtitle = "check an activity off your list"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "ACTIVITY_COMPLETION"
        
        for time in times{
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: time)
            
            var formattedTime = DateComponents()
            if let hour = components.hour, let minute = components.minute{
                formattedTime.hour = hour
                formattedTime.minute = minute
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: formattedTime, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request)
        }
        
        
    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//           didReceive response: UNNotificationResponse,
//           withCompletionHandler completionHandler:
//             @escaping () -> Void) {
//           
//       // Get the meeting ID from the original notification.
////       let userInfo = response.notification.request.content.userInfo
////       let meetingID = userInfo["MEETING_ID"] as! String
////       let userID = userInfo["USER_ID"] as! String
//        print("made it into the function")
//        var actList = [String]()
//        for act in activities{
//            actList.append(act.name+"Action")
//        }
//            
//       // Perform the task associated with the action.
//       switch response.actionIdentifier {
//           
//       case let action where actList.contains(action):
//           //var choosenAct : Activity
//           print("got into the case")
//           
//           for act in actList{
//               
//               if act == action{
//                   print("matched the one clicked to an action")
//                   let day = getDay()
//                   
//                   for act in activities{
//                       if action == act.name+"Action"{
//                           print("matched the action to an activity")
//                           let choosenAct = act
//                           
//                           if day.compDict[choosenAct.id.uuidString] ==  false{
//                               day.compDict[choosenAct.id.uuidString] = true
//                               try? modelContext.save()
//                               print("made it where need to be")
//                               break
//                           }
//                       }
//                   }
//                   
//                   
//                   
//                   
//                   
//               }
//           }
//           
//           
//          break
//            
//       default:
//           print("something is wrong")
//          break
//       }
//        
//       completionHandler()
//    }
//    func getStrDate(day: Date) -> String {
//        return day.formatted(date: .abbreviated, time: .omitted)
//    }
//    
//    func getDay() -> Day {
//        let currDay = getStrDate(day: Date.now)
//        for day in days {
//            if getStrDate(day: day.date) == currDay {
//                return day
//            }
//        }
//        let newDay = Day(date: Date.now, activities: [], compDict: [:])
//        print("New day")
//        modelContext.insert(newDay)
//        
//        let calendar = Calendar.current
//        for act in activities {
//            let actStartDate = calendar.dateComponents([.year, .month, .day], from: act.startDate ?? Date.now)
//            let newDayDate = calendar.dateComponents([.year, .month, .day], from: newDay.date)
//            let actStartDt = calendar.date(from: actStartDate)!
//            let newDayDt = calendar.date(from: newDayDate)!
//            
//            if actStartDt <= newDayDt {
//                newDay.activities.append(act)
//                newDay.compDict[act.id.uuidString] = false
//            }
//        }
//        try? modelContext.save()
//        return newDay
//    }
//    
//    
}
class NotificationDelegate: NSObject,ObservableObject, UNUserNotificationCenterDelegate {
    var activities: [Activity]
    var days: [Day]
    var modelContext: ModelContext
    
    init(activities: [Activity], days: [Day], modelContext: ModelContext) {
        self.activities = activities
        self.days = days
        self.modelContext = modelContext
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification action received: \(response.actionIdentifier)")
        completionHandler()
        
        var actList = [String]()
        for act in activities {
            actList.append(act.name + "Action")
        }
        
//        switch response.actionIdentifier {
        if actList.contains(response.actionIdentifier){
//            print("Matched the one clicked to an action")
            let day = getDay()
            
            for act in activities {
                if response.actionIdentifier == act.name + "Action" {
                    print("Matched the action to an activity")
                    if day.compDict[act.id.uuidString] == false {
                        day.compDict[act.id.uuidString] = true
                        try? modelContext.save()
                        print("Made it where need to be")
                        break
                    }
                }
            }
//        default:
//            print("Something is wrong")
        }
        
        completionHandler()
    }
    
    func getStrDate(day: Date) -> String {
        return day.formatted(date: .abbreviated, time: .omitted)
    }
    
    func getDay() -> Day {
        let currDay = getStrDate(day: Date.now)
        for day in days {
            if getStrDate(day: day.date) == currDay {
                return day
            }
        }
        let newDay = Day(date: Date.now, activities: [], compDict: [:])
        print("New day")
        modelContext.insert(newDay)
        
        let calendar = Calendar.current
        for act in activities {
            let actStartDate = calendar.dateComponents([.year, .month, .day], from: act.startDate ?? Date.now)
            let newDayDate = calendar.dateComponents([.year, .month, .day], from: newDay.date)
            let actStartDt = calendar.date(from: actStartDate)!
            let newDayDt = calendar.date(from: newDayDate)!
            
            if actStartDt <= newDayDt {
                newDay.activities.append(act)
                newDay.compDict[act.id.uuidString] = false
            }
        }
        try? modelContext.save()
        return newDay
    }
}

#Preview {
    NotificationView()
}

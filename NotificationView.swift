//
//  NotificationView.swift
//  RateMyWeek
//
//  Created by Jardel Emile on 8/11/24.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    let defaults = UserDefaults.standard
    @State private var notifiNum = 0
    var notifiNums = [0,1,2,3,4,5,6,7]
    @State private var selectedTimes: [Date] = Array(repeating: Date(), count: 8)
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
        
        let content = UNMutableNotificationContent()
        content.title = "Update your progress"
        content.subtitle = "check an activity off your list"
        content.sound = UNNotificationSound.default
        
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
}

#Preview {
    NotificationView()
}

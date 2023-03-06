//
//  Testing4ViewModel.swift
//  T1-Pomodoro
//
//  Created by emre usul on 27.02.2023.
//

import Foundation
import AVKit
import SwiftUI
import AudioToolbox


     class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
         
       
       
        @Published var isActive = false
        @Published var showingAlert = false
        @Published var timeRemaining: Int = 1*60
         
        @Published var todayPomodoro: Int = 0
        @Published var weekPomodoro: Int = 0
        @Published var allTimePomodoro: Int = 0
         
        @Published var height = 200.0
        @Published var rectangleHeight: Float = 0.0
         
        private var lastDateString: String {
            get {
                return UserDefaults.standard.string(forKey: "lastDay") ?? String() }
        }

        private var lastWeekStartString: String {
            get {
                return UserDefaults.standard.string(forKey: "lastWeekStart") ?? String() }
        }
         
        public var currentDay: String  {
             get{
                 return Date.now.formatted(date: .long, time: .omitted) }
        }
        
        func getCurrentWeekStart() -> String {
            let startWeek = (Date.now.startOfWeek?.formatted(date: .long, time: .omitted))!
            return startWeek
        }

        @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
         
         
        func start() {
            self.isActive = true
            addNotification()
        }
        
        var timeRemaingDisplay:String {
            let minutes = timeRemaining / 60
            let seconds = timeRemaining % 60
            return String(format: "%02i:%02i", minutes, seconds)
          
        }
         
         func getPomodoro() {
             todayPomodoro = UserDefaults.standard.integer(forKey: "pomodoro")
         }
         
         func getWeekPomodoro() {
             weekPomodoro = UserDefaults.standard.integer(forKey: "weekPomodoro")
         }
         
         func getHour(pomodoro: Int) -> String {
             let total = pomodoro * 25
             let hour = total / 60
             let minutes = total % 60
             
             if hour == 0 {
                 return "\(minutes) Min"
             }
             
             else {
                 return "\(hour) hour \(minutes) min"
             }
             
         }
         

         
         func getAllTimePomodoro() {
             allTimePomodoro = UserDefaults.standard.integer(forKey: "allTimePomodoro")
         }
         
         
        func pause() {
            self.isActive = false
        }
        
        func restart() {
            self.isActive = false
            timeRemaining = 1*60
            rectangleHeight = 0
            height = 200.0
        }
         
        func rectangle() -> Float {
            let rectangle = ((60.0 - Double(timeRemaining))/Double(timeRemaining))
            return Float(rectangle)
        }
                
        func updateCountdown() {
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                height -= 3.33
                rectangleHeight = Float((200 - height)/200)
            } else {
                    todayPomodoro += 1
                    weekPomodoro += 1
                    allTimePomodoro += 1
                
             
                    UserDefaults.standard.set(todayPomodoro, forKey: "pomodoro")
                    UserDefaults.standard.set(weekPomodoro, forKey: "weekPomodoro")
                    UserDefaults.standard.set(allTimePomodoro, forKey: "allTimePomodoro")
                
                    self.isActive = false
                    self.timeRemaining = 1*60
                    self.height = 200.0
                

            }
        }
         
         override init() {
             super.init()
             self.authorizeNotification()
         }
         
         func authorizeNotification() {
             UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _ in
             }
             
             UNUserNotificationCenter.current().delegate = self
         }
         
         func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
             completionHandler([.sound, .banner])
         }
         
         func addNotification() {
             let content = UNMutableNotificationContent()
             content.title = "\(self.timeRemaingDisplay)"
             content.subtitle = "Congratulations You did it"
             content.sound = UNNotificationSound.defaultCritical
             
             let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeRemaining), repeats: false))
             UNUserNotificationCenter.current().add(request)
         }
         
         func newDay() {
            if lastDateString != currentDay {
                todayPomodoro = 0
                UserDefaults.standard.set(todayPomodoro, forKey: "pomodoro")
                UserDefaults.standard.set(currentDay, forKey: "lastDay")
            }
         }
         
         func checkNewWeek(){
             if lastWeekStartString != getCurrentWeekStart(){
                 weekPomodoro = 0
                 UserDefaults.standard.set(weekPomodoro, forKey: "weekPomodoro")
                 UserDefaults.standard.set(getCurrentWeekStart(), forKey: "lastWeekStart")
             }
         }
    }



extension Date {
    var startOfWeek: Date? {
        var gregorian = Calendar(identifier: .iso8601)
        
        guard let monday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return monday
    }
}

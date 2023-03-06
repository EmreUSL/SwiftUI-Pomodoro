//
//  T1_PomodoroApp.swift
//  T1-Pomodoro
//
//  Created by emre usul on 24.02.2023.
//

import SwiftUI

@main
struct T1_PomodoroApp: App {
    @StateObject var pomodoromodel: PomodoroModel = .init()
    @State var lastActiveTime: Date = Date()
    @Environment(\.scenePhase) var phase
    var body: some Scene {
        WindowGroup {
          Testing4()
                .environmentObject(pomodoromodel)
        }
        .onChange(of: phase) { newValue in
          
            if pomodoromodel.isActive {
                if newValue == .background {
                    lastActiveTime = Date()
                }
                
                if newValue == .active {
                    let currentTimeDiff = Date().timeIntervalSince(lastActiveTime)
                    if pomodoromodel.timeRemaining - Int(currentTimeDiff) <= 0 {
                        pomodoromodel.isActive = false
                        pomodoromodel.timeRemaining = 1*60
                    } else {
                        pomodoromodel.timeRemaining -= Int(currentTimeDiff)
                        pomodoromodel.height -= (3.33*currentTimeDiff)
                    }
                }
            }
        }
    }
}

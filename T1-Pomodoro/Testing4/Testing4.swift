//
//  Testing4.swift
//  T1-Pomodoro
//
//  Created by emre usul on 27.02.2023.
//

import SwiftUI

struct Testing4: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
    
        VStack {
            
            TabView {
                PomodoroView()
                    .environmentObject(pomodoroModel)
                    .tabItem {
                        Label("Pomodoro", systemImage: "timer")
                    }
                
                StatisticView()
                    .tabItem {
                        Label("Statistic", systemImage: "pencil")
                    }
            }
            
            Spacer()
        }
         
    }
    
    
}

struct Testing4_Previews: PreviewProvider {
    static var previews: some View {
        Testing4()
            .environmentObject(PomodoroModel())
    }
}

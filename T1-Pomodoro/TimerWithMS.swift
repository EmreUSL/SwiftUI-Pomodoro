//
//  TimerWithMS.swift
//  T1-Pomodoro
//
//  Created by emre usul on 26.02.2023.
//

import SwiftUI

struct TimerWithMS: View {
    
    @State var timeRemaining = 150
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isStarted = false
    
    func convertSecondToTime(timeInSeconds: Int) -> String {
        
        let minutes = timeInSeconds / 60
        let second = timeInSeconds % 60
        
        return String(format: "%02i:%02i", minutes, second)
    }
    
    var body: some View {
        
        VStack {
            
            Text(convertSecondToTime(timeInSeconds: timeRemaining))
                .padding()
                .font(.system(size: 100))

            
            HStack(spacing: 50) {
                Button("Start") {
                    isStarted.toggle()
                }
                .foregroundColor(.green)
                
                Button("Pause") {
                    isStarted.toggle()
                }
                .foregroundColor(.brown)
            }.onReceive(timer) { _ in
                if timeRemaining > 0 && isStarted{
                    timeRemaining -= 1
                }
        
            }
        }
    }
    

}

struct TimerWithMS_Previews: PreviewProvider {
    static var previews: some View {
        TimerWithMS()
    }
}

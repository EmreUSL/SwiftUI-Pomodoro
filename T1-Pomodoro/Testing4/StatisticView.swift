//
//  StatisticView.swift
//  T1-Pomodoro
//
//  Created by emre usul on 27.02.2023.
//

import SwiftUI
import Charts

struct StatisticView: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @State var sampleAnalytics: [SiteView] = sample_analytics
    @State var currentTab: String = "7 Days"
    var body: some View {
        
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(pomodoroModel.currentDay)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Today")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        VStack {
                            Text("Pomodoro")
                                .font(.title.bold())
                            Text("\(pomodoroModel.todayPomodoro)")
                                .font(.title.bold())
                                .onAppear() {
                                    pomodoroModel.getPomodoro()
                                }
                        }
                        Spacer()
                        VStack {
                            Text("Total Hour")
                                .font(.title.bold())
                            Text(pomodoroModel.getHour(pomodoro: pomodoroModel.todayPomodoro))
                                .font(.title.bold())
                        }
                       
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 60)))
                    
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(pomodoroModel.getCurrentWeekStart())
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("This Week")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        VStack {
                            Text("Pomodoro")
                                .font(.title.bold())
                            Text("\(pomodoroModel.weekPomodoro)")
                                .font(.title.bold())
                                .onAppear(){
                                    pomodoroModel.getWeekPomodoro()
                                }
                        }
                        Spacer()
                        VStack {
                            Text("Total Hour")
                                .font(.title.bold())
                            Text(pomodoroModel.getHour(pomodoro: pomodoroModel.weekPomodoro))
                                .font(.title.bold())
                        }
                       
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 80)))
                    
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("All The Time")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Total")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        VStack {
                            Text("Pomodoro")
                                .font(.title.bold())
                            Text("\(pomodoroModel.allTimePomodoro)")
                                .font(.title.bold())
                                .onAppear {
                                    pomodoroModel.getAllTimePomodoro()
                                }
                        }
                        Spacer()
                        VStack {
                            Text("Total Hour")
                                .font(.title.bold())
                            Text(pomodoroModel.getHour(pomodoro: pomodoroModel.allTimePomodoro))
                                .font(.title.bold())
                        }
                       
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 100)))
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle("Statistics")
        }
        
        
    }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = sampleAnalytics.max { item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
        Chart {
            ForEach(sampleAnalytics) { item in
                BarMark(x: .value("Hour", item.hour, unit: .hour),
                        y: .value("Views", item.views))
            }
        }
        .chartYScale(domain: 0...(max + 5000))
        .frame(height: 250)
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
            .environmentObject(PomodoroModel())
    }
}

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", self / 100000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self)
    }
}

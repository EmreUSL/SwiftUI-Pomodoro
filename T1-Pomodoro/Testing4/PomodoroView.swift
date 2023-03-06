//
//  PomodoroView.swift
//  T1-Pomodoro
//
//  Created by emre usul on 27.02.2023.
//

import SwiftUI

struct PomodoroView: View {
    @EnvironmentObject var viewModel: PomodoroModel
  
    
    var body: some View {
        VStack(spacing: 25) {
            
            HStack {
                VStack {
                    Text("Pomodoro")
                        .font(.title2)
                        .bold()
                        .padding()

                    
                    Text("\(viewModel.todayPomodoro)")
                        .font(.title)
                        .bold()
                        .onAppear() {
                            viewModel.getPomodoro()
                            viewModel.newDay()
                        }
                    
                }
                Spacer()
                VStack {
                    Text(viewModel.currentDay)
                        .font(.title2)
                        .bold()
                        .padding()
                       
                }
            }
            .padding()
         
         
            ZStack {
                Image("lion.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.white.shadow(.drop(radius: 25)))
                    }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                    
                    Image("lion.blank")
                        .resizable()
                    
                }
                .clipShape(RectBand(from: 0, to: 1 - CGFloat(viewModel.rectangleHeight)))
                .scaledToFit()
                .frame(width: 200)
                
            }
          
            
            Text("\(viewModel.timeRemaingDisplay)")
                .font(.system(size:70, weight: .medium, design: .monospaced))
                .padding()
                .frame(width: 250)
                .background(.thinMaterial)
                .cornerRadius(20)
            
            Label("\(viewModel.isActive ? "Stop" : "Start")", systemImage: "\(viewModel.isActive ? "pause.fill" : "play.fill")")
                .foregroundColor(viewModel.isActive ? .red : .yellow)
                .font(.title).onTapGesture {
                    if viewModel.isActive == false {
                        viewModel.start()
                    } else {
                        viewModel.pause()
                        alertView()
                    }
                }
            Spacer()
        }.onReceive(viewModel.timer) { _ in
            viewModel.updateCountdown()
            viewModel.newDay()
            viewModel.checkNewWeek()
            
        }
    }
    
    func alertView() {
     
        let alert = UIAlertController(title: "Quit Pomodoro", message: "Do you really want to this", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Yes", style: .destructive) { _ in
            viewModel.restart()
        }
        
        let resume = UIAlertAction(title: "Resume", style: .default) { _ in
            viewModel.start()
        }
        
        alert.addAction(resume)
        alert.addAction(cancel)
    
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct PomodoroView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroView()
            .environmentObject(PomodoroModel())
    }
}

struct RectBand: Shape {
    var from: CGFloat
    var to: CGFloat
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(CGRect(
                x: rect.origin.x,
                y: rect.origin.y + from * rect.size.height,
                width: rect.size.width,
                height: (to-from) * rect.size.height
            ))
        }
    }
}

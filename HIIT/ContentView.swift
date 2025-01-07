
//  ContentView.swift
//  HIIT
//
//  Created by 仲村士苑 on 2025/01/05.
//

import SwiftUI

struct ContentView: View {
    
    @State var timeRemaining: TimeInterval = 15
    @State private var totalTime: TimeInterval = 15
    @State var timer: Timer?
    @State var isRunning: Bool = false
//    @State var restartBtn: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                ZStack{
                    getCircle()
                    if isRunning {
                        Text(formattedTime())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        
                    } else {
                        Text("トレーニングモード 開始")
                            .font(.title2)
                    }
                }
            }
                .frame(maxWidth: 500)
                .padding(.bottom, 50)
                
            
                // start button
 
                
            VStack(spacing: 10){
                
                Button {
                    if isRunning {
                   
                        stopTimer()
                       
                    }
                    else if !isRunning && timeRemaining != totalTime{
                        restartTimer()
                    }
    
                    else {
                       
                        startTimer()
                     
                        
                    }
      
                    isRunning.toggle()
                    
                   
                    
                } label: {
                    
                    if !isRunning{
                        Text( "Start")
                                .font(.largeTitle)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxWidth:.infinity)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(10)
                    }else if isRunning && timeRemaining != totalTime{
                        
                        Text("Restart")
                            .font(.largeTitle)
                            .fixedSize(horizontal: true, vertical: false)
                             .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                              .background(.blue)
                              .cornerRadius(10)
                       
                    }
                    else{
                        
                        Text( "Stop")
                                .font(.largeTitle)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(maxWidth:.infinity)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(10)
                    }

                      
                }

                
//                if isRunning && timeRemaining != totalTime{
//                        Button {
//                            restartTimer()
//                        } label: {
//                            Text("Restart")
//                                .font(.largeTitle)
//                                .fixedSize(horizontal: true, vertical: false)
//                                .frame(maxWidth: .infinity)
//                                .foregroundStyle(.white)
//                                .background(.blue)
//                                .cornerRadius(10)
//                        }
//                       
//                    }
    
                
            // reset button
                
                if isRunning{
                    Button {
                        resetTimer()
                    } label: {
                        
                        Text("reset")
                            .font(.largeTitle)
                            .fixedSize(horizontal: true, vertical: false)
                            .frame(maxWidth:.infinity)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                }
                
            }
            .navigationTitle(isRunning ? "トレーニングモード" :  "HIIT")

                // トレーニングタイム
            
                if !isRunning{
                    VStack{
                        Stepper(value: Binding(
                        get: { Int(totalTime) },
                         set: { newValue in
                             if newValue >= 10 && newValue <= 25 {
                        totalTime = TimeInterval(newValue)
                              timeRemaining = totalTime
                        } else {
//                                showAlert = true
                                }
                            }
                        ), in: 10...25, step: 1) {
                            Text("トレーニングタイム: \(Int(totalTime)) 秒")
                                .font(.headline)
                }
            }
                .padding()
        }
            
    }
            .padding(.horizontal, 30)

}
    
    
    

    
    func getCircle() -> some View {
        
   
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.2)
                
                
                Circle()
                    .trim(from: 0, to: CGFloat(1 - (timeRemaining / totalTime)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .rotation(Angle(degrees: -90))
                    .scaleEffect(x: -1, y: 1)
                    .foregroundStyle(.red)
                    .animation(.linear(duration: 1), value: timeRemaining)

            
        }
        .frame(width: 300, height: 300)

      
    }

    
    
    
    
    func formattedTime()-> String{
        let minutes = Int(timeRemaining)/60
        let second = Int(timeRemaining) % 60
        return String(format:"%02d:%02d", minutes, second)
    }
    
    
    
    func startTimer(){

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            if timeRemaining > 0{
                timeRemaining -= 1
            }else{
                stopTimer()
            }
        }
    }
    
    
    
    func resetTimer(){
        
        timer?.invalidate()
        timeRemaining = totalTime
        isRunning = false

    }
        
    
    
    func stopTimer(){
        timer?.invalidate()
        isRunning = false
    }
    
    func restartTimer() {
          timer?.invalidate()
          startTimer()
        
      }
    
    
 
}

#Preview {
    ContentView()
}



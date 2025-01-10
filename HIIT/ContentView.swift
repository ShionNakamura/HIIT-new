
//  ContentView.swift
//  HIIT
//
//  Created by 仲村士苑 on 2025/01/05.
//

import SwiftUI

struct ContentView: View {
    
    @State var timeRemaining: TimeInterval = 15
    @State private var totalTime: TimeInterval = 15
    @State private var restTime: TimeInterval = 10
    @State private var setsTime: Int = 3
    @State var timer: Timer?
    @State var isRunning: Bool = false
    @State var isResting: Bool = false

    
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
                        
                        Text("HIIT セット回数残り: \(setsTime) セット")
                            .font(.headline)
                            .padding(.top, 90)
                        
                    }
                    else if setsTime == 0 {
                        
                        Text("トレーニングモード 完了")
                            .font(.title2)
                        
                    }
                    
                    else {
                        
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
                    if !isRunning {
                   
                        startTimer()
                     
                        
                    }
                
    
                    else {
                    
                       
                        stopTimer()
                        

                        
                    }
      
                    isRunning.toggle()

                   
                    
                } label: {
                    
                    if !isRunning{
                        btn(text: "Start")

                    }
                    else{
                        
                   
                        btn(text: "Stop")

                    }

                }

                
                if isRunning && timeRemaining != totalTime{
                        Button {
                            restartTimer()
                        } label: {
                            btn(text: "Restart")

                        }
                       
                    }
    
                
            // reset button
                
                if isRunning{
                    Button {
                        resetTimer()
                    } label: {
                        btn(text: "Reset")
                    }
                }
                
            }
            .navigationTitle(!isRunning ? "HIIT" :
                             !isResting ? "トレーニングモード": "休憩")
            

                // トレーニングタイム
            
                if !isRunning{
                    VStack{
                        Stepper(value: Binding(
                        get: { Int(totalTime) },
                         set: { newValue in
                             if newValue >= 3 && newValue <= 25 {
                        totalTime = TimeInterval(newValue)
                              timeRemaining = totalTime
                        }
                            }
                        ), in: 3...25, step: 1) {
                            Text("トレーニングタイム: \(Int(totalTime)) 秒")
                                .font(.headline)
                }
                        
                        Stepper(value: Binding(
                            get: { Int(restTime) },
                         set: { newValue in
                             if newValue >= 3 && newValue <= 20 {
                                 restTime = TimeInterval(newValue)
                        }
                            }
                        ), in:3...25, step: 1) {
                            Text("休憩インターバル: \(Int(restTime)) 秒")
                                .font(.headline)
                }
                        
                        Stepper(value: Binding(
                                  get: { setsTime },
                                  set: { newValue in
                                      // fix that latter//////////
                                      if newValue >= 1 && newValue <= 12 {
                                          setsTime = newValue
                                      }
                                  }
                              ), in: 1...12, step: 1) {
                                  Text("HIIT セット回数: \(setsTime) セット")
                                      .font(.headline)
                              }
 
            }
                .padding()
                    
        }
            
            
    }
        

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
                    .scaleEffect(x : -1, y: 1)
                    .foregroundStyle(isResting ? .green:.red)
                    .animation(.linear(duration: 1), value: timeRemaining)
                
             

        }
        .frame(width: 300, height: 300)
        

    }
    

    func btn(text: String) -> some View{
        
        Text(text)
        .font(.largeTitle)
        .fixedSize(horizontal: true, vertical: false)
        .frame(maxWidth:.infinity)
        .foregroundStyle(.white)
        .background(.blue)
        .cornerRadius(10)
        .padding(.horizontal, 50)
        
    }
    
    
    
    
    func formattedTime()-> String {
        let minutes = Int(timeRemaining)/60
        let second = Int(timeRemaining) % 60
        return String(format:"%02d:%02d", minutes, second)
    }
    
    

    func startTimer() {
        
        timer?.invalidate()

        guard setsTime != 0  else{ return self.resetTimer()}

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
          
            if timeRemaining > 0 {
                
                timeRemaining -= 1
                
            }
            
            else  {
       
                switchToRest()

             
            }
          
        }
    }

    
    func switchToRest() {
        

        if setsTime != 0{
            isResting.toggle()
        }
        
 
        if isResting {
            setTimer()
        }
        
        
        timeRemaining = restTime
        
        
        timer?.invalidate()
        
        guard setsTime != 0  else{ return self.resetTimer()}
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            
            if timeRemaining > 0 && setsTime > 0 {
                
                timeRemaining -= 1
                
            }
            
            else {
              
                    startTimer()
             
            }
            
        }
    }

    
    

    
    func setTimer() {
            // Reduce the set count only when workout phase ends
        if setsTime > 0 {
            
                setsTime -= 1

        }

    }
    
    
    func resetTimer(){
        
        timer?.invalidate()
        timeRemaining = totalTime
        isRunning = false
        isResting = false
        setsTime = 8
        
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



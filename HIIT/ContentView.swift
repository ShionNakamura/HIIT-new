import SwiftUI
import AudioToolbox

struct ContentView: View {
    
    @State var timeRemaining: TimeInterval = 30
    @State private var totalTime: TimeInterval = 30
    @State private var restTime: TimeInterval = 10
    @State private var setsTime: Int = 3
    @State var timer: Timer?
    @State var isRunning: Bool = false
    @State var isResting: Bool = false
    @State var isStopped: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if setsTime != 0 {
                        VStack(alignment: .center) {
                            ZStack {
                                
                                getCircle()
                                
                                if isRunning {
                                    Text(formattedTime())
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .padding()
                                    
                                    Text("HIIT セット回数残り: \(setsTime) セット")
                                        .font(.headline)
                                        .padding(.top, 90)
                                    
                                } else {
                                    Text("トレーニングモード 開始")
                                        .font(.title2)
                                }
                                
                            }
                            
                        }
                        .frame(maxWidth: 500)
                        .padding(.bottom, 50)
                    } else {
                        
                        Text("トレーニングモード 終了")
                            .font(.title)
                        Text("今日もお疲れ様でした!! 🙌👏")
                            .font(.title)
                            .onAppear(){
                                vibrate()
                                playSound()
                            }
                        
                    }
                        

                    if setsTime != 0 {
                        VStack(spacing: 10) {
                            
                            Button {
                                
                                if !isRunning {
                                    startTimer()
                                    
                                } else {

                                    stopTimer()
                                        
                                    isStopped =  true
                                }
                                
                                isRunning.toggle()

                                
                                
                            } label: {
                                
                                if !isRunning {
                                    
                                    withAnimation {
                                        
                                        btn(text: "Start")
                                        
                                    }
                                } else {
                                    
                                    withAnimation {
                                        
                                        btn(text: "Stop")
                                        
                                    }
                                }
                            }
                            
                            if isStopped {
                                Button {
                                    
                                    restartTimer()
                                    
                                } label: {
                                    withAnimation {
                                        btn(text: "Restart")
                                    }
                                }
                                
                                Button {
                                    
                                    withAnimation{
                                        resetTimer()
                                    }
                                    
                                } label: {
                                    
                                    btn(text: "Reset")
                                        
                                }
                            }
                        }
                        
                        .navigationTitle(!isRunning ? "HIIT" :
                                            !isResting ? "トレーニングモード 🔥 " :
                                            setsTime == 0 ? "トレーニングモード完了" : "休憩  ")
                    
                       
                    }
                    
                    if !isRunning {
                        withAnimation(){
                            VStack {
          
                                    Stepper(value: Binding(
                                        get: { Int(totalTime) },
                                        set: { newValue in
                                            if newValue >= 20 && newValue <= 30 {
                                                totalTime = TimeInterval(newValue)
                                                timeRemaining = totalTime
                                                
                                           
                                            }
                                            
                                        }
                                    ), in: 20...30, step: 1) {
                                        Text("トレーニングタイム: \(Int(totalTime)) 秒")
                                            .font(.headline)
                                    }
                                    
                                    
                                    Stepper(value: Binding(
                                        get: { Int(restTime) },
                                        set: { newValue in
                                            if newValue >= 10 && newValue <= 20 {
                                                restTime = TimeInterval(newValue)
                                                
                                                
                                            }
                                        }
                                    ), in: 10...20, step: 1) {
                                        Text("休憩インターバル: \(Int(restTime)) 秒")
                                            .font(.headline)
                                    }
                                    
                                    Stepper(value: Binding(
                                        get: { setsTime },
                                        set: { newValue in
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
            }
        }
    }
    
    

    func getCircle() -> some View {
        withAnimation {
            if setsTime != 0 {
                return AnyView(
                    ZStack {
                       
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.2)

                            Circle()
                                .trim(from: 0, to: CGFloat(1 - (timeRemaining / totalTime)))
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .rotation(Angle(degrees: -90))
                                .scaleEffect(x: -1, y: 1)
                                .foregroundStyle(isResting ? .green : .red)
                            .animation(timeRemaining == totalTime ? nil : .linear(duration: 1), value: timeRemaining)
                
                       
                    }
                    .frame(width: 300, height: 300)
                )
            } else {
                return AnyView(EmptyView())
            }
        }
    }
    
    

    func btn(text: String) -> some View {
        
        Text(text)
            .font(.largeTitle)
            .fixedSize(horizontal: true, vertical: false)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(10)
            .padding(.horizontal, 50)
        
    }

    func formattedTime() -> String {
        
        let minutes = Int(timeRemaining) / 60
        let second = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, second)
        
    }

    
    func startTimer() {
        
        isResting = false
        timer?.invalidate()
        timeRemaining = totalTime
        
        guard setsTime != 0 else {
                self.resetTimer()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                
                timeRemaining -= 1
                
            } else {
                
                self.switchToRest()
                            
            }
        }
    }
    
    

    func switchToRest() {
        if setsTime != 0 {
            isResting.toggle()
        }

        if isResting {
            
            setTimer()
            
        }
        
        timeRemaining = restTime

        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 && setsTime > 0 {
                
                timeRemaining -= 1
                
            } else {
                
                startTimer()
                
            }
        }
    }
    
    

    func setTimer() {
        
        if setsTime > 0 {
            setsTime -= 1
        }
        
    }
    

    func resetTimer() {
        timer?.invalidate()
        timeRemaining = 25
        totalTime = 25
        restTime = 10
        setsTime = 8
        isRunning = false
        isResting = false
        isStopped = false
    }

    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
        isStopped = true
    }
    
    

    func restartTimer() {
            timer?.invalidate()
            startTimer()
            isStopped = false
        
    }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "finish", withExtension: "wav") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
 

}

#Preview {
    ContentView()
}



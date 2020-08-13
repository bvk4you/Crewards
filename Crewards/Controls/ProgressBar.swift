//
//  ProgressBar.swift
//  Crewards
//
//  Created by vabhaske on 12/08/20.
//

import SwiftUI
import Combine

struct ProgressBar: View {
    @State var counter: CGFloat = 20
    var completion:()->Void
    var loopLimit = 1
    @State var loopCount = 0
    let currentTimePublisher = Timer.TimerPublisher(interval: 0.05, runLoop: .main, mode: .default)
    @State  var cancellable: AnyCancellable?

    func start() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
        
    }
    func stop() {
        self.cancellable?.cancel()
    }
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height:3)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: 50, height: 2)
                    .offset(x: self.counter, y: 0)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(self.counter > 0 ? .easeInOut : .none)
            }.cornerRadius(45.0)
        }.onAppear {
            self.start()
        }
        .onReceive(currentTimePublisher) { time in
            if (self.counter < 420) {
                self.counter += 40
                if(self.counter == 260)
                {
                    loopCount+=1

                }
                
            }
            else {
                self.counter = -20
            }
            if(loopCount > loopLimit)
            {
                self.cancellable?.cancel()
                completion()
                return
            }

        }
    }
}
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(completion: {})
    }
}

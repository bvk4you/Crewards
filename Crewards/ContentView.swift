//
//  ContentView.swift
//  Crewards
//
//  Created by vabhaske on 21/07/20.
//

import SwiftUI

struct ContentView : View {
    
    @EnvironmentObject var session : SessionStore
    var signInView = PhoneSignInView()
    
    
    var body: some View {
        GeometryReader { geometry in

        Group {
            if (self.session.session != nil) {
                HomeView()
            } else {
                self.signInView
                    .background(Color(.red))
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                .edgesIgnoringSafeArea([.all])

            }
        }
        }
        .onAppear {
            if(self.session.session == nil)
            {
                self.signInView.textBindingManager.text = ""
                self.signInView.otpBindingManager.text = ""
            }
        }

    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
#endif

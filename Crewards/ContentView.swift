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
    
    func getUser () {
        session.listen()
    }
    
    var body: some View {
        GeometryReader { geometry in

        Group {
            if (self.session.session != nil) {
                AppView()
            } else {
                self.signInView
                .background(Color.black)
                .edgesIgnoringSafeArea([.all])

            }
        }
        }
        .onAppear {
            self.getUser()
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

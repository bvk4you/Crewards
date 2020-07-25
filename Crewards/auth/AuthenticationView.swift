//
//  AuthenticationView.swift
//  Julienne
//
//  Created by Ben McMahen on 2019-06-18.
//  Copyright © 2019 Ben McMahen. All rights reserved.
//

import SwiftUI

struct AuthenticationScreen : View {
     @ObservedObject var session:SessionStore
    @State var isPresented = true
    var body : some View {
    
            CustomButton(
                label: "Continue",
                action: {self.isPresented.toggle()}
                    
            )
                .padding()
                .sheet(isPresented: $isPresented){
                        PhoneSignInView()
                }
    }
}

#if DEBUG
struct Authenticate_Previews : PreviewProvider {
    static var previews: some View {
        AuthenticationScreen(session: SessionStore())
            .environmentObject(SessionStore())
    }
}
#endif

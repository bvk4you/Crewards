//
//  CustomButton.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//


import SwiftUI

// todo:
// add disabled, spinner, dark mode?

struct CustomButton : View {
    var label: String
    var action: () -> Void
    var loading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Button(action: action) {
                HStack {
                    Text(label)
                        .fontWeight(.bold)
                    //.padding(UIEdgeInsets(top:0,left: 20,bottom:8,right:20))

            };
            
        }
        .padding([.top, .leading, .trailing], 8.0)
        .buttonStyle(GradientButtonStyle())
        .opacity(loading ? 0.3 : 1)
            
    }
}

#if DEBUG
struct CustomButton_Previews : PreviewProvider {
    static var previews: some View {
        CustomButton(label: "Sign in", action: {
            print("hello")
        })
    }
}
#endif

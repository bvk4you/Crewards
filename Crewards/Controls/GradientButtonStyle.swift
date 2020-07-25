//
//  GradientButtonStyle.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
        .foregroundColor(Color.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(15.0)
        .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
        .shadow(radius: 10)
        
            //.blur(radius:10)

//        .rotationEffect(Angle(degrees: 30))
//        .rotation3DEffect(Angle(degrees: 60), axis: (x: 0, y: 10, z: 0))

    }
}


//
//  FormViews.swift
//  RoastedNotes
//
//  Created by Ben McMahen on 2019-06-19.
//  Copyright © 2019 Ben McMahen. All rights reserved.
//

import SwiftUI

struct InputModifier : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            //.border(Color(red: 1, green: 1, blue: 1, opacity: 0.3), width: 5)
    }
}

struct CustomInput : View {
    @Binding var text: String
    var name: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { Text(name).foregroundColor(.primary)
                .opacity(0.3)
                .font(Font.title.bold())

            }

            TextField("", text: $text)
             .font(Font.title.bold())
            .keyboardType(.phonePad)
            .textContentType(.telephoneNumber)
            
        }
    }
}

#if DEBUG
struct CustomInput_Previews : PreviewProvider {
    
    static var previews: some View {
        CustomInput(text: .constant(""), name: "Some name")
            .padding()
    }
}
#endif

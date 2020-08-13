//
//  NoSeparatorList.swift
//  Crewards
//
//  Created by vabhaske on 12/08/20.
//

import SwiftUI

struct NoSeparatorList<Content>: View where Content: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        
    }
        
    var body: some View {
        if #available(iOS 14.0, *) {
          return  AnyView(ScrollView {
            LazyVStack(alignment:.leading,spacing:20) {
                self.content()
            }
            }
          )
        } else {
          return   AnyView(List {
                self.content()
            }
)
        }
    }
}


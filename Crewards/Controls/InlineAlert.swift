//
//  InlineAlert.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//

import SwiftUI

enum AlertIntent {
    case info, success, question, danger, warning
}

struct InlineAlert : View {
    
    var title: String
    var subtitle: String?
    var intent: AlertIntent = .info
    
    var body: some View {

        HStack(alignment: .top) {
               
                
            
                Image(systemName: "exclamationmark.triangle.fill")
                    .padding(.vertical)
                    .foregroundColor(Color.primary)
            
            
            
                
                
                VStack(alignment: .leading) {
                    Text(self.title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)


                    if (self.subtitle != nil) {
                        Text(self.subtitle!)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)

                    }

                }.padding(.leading)
            
            }
                .padding()
                .background(Color.red)
        
    }
}

#if DEBUG
struct InlineAlert_Previews : PreviewProvider {
    static var previews: some View {
        InlineAlert(
            title: "Nostrud non magna quis veniam dolore magna voluptate.",
            subtitle: "Nulla id amet reprehenderit laboris irure Lorem ex esse eiusmod eiusmod occaecat officia. Quis in reprehenderit dolor veniam id sunt mollit reprehenderit.",
            intent: .info
        ).frame(height: 300)
    }
}
#endif

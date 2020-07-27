//
//  CardsList.swift
//  Crewards
//
//  Created by vabhaske on 26/07/20.
//

import SwiftUI

struct CardsList: View {
    @State var isPresented = false

    init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
         appearance.accessoryType = .none
    }

    var body: some View {
        NavigationView {
        Group
            {
                GeometryReader { geo in
                    List {
                        
                        ForEach(cards) { card in
                            NavigationLink(destination: AppView())
                            {
                                    if(self.isPresented)
                                    {
                                CardView(card:card,geometry: geo)
                                    .padding(.horizontal,0)
                                    .transition(.slide)
                                    .animation(Animation.easeInOut(duration: 0.3))
                                }
                                }
                        }
                        
                    }.padding(.horizontal,0)
                        .onAppear(){
                            self.isPresented = true
                        }
                        .onDisappear(){
                        //self.isPresented = false
                    }

                    
                }
        }.navigationBarTitle(Text("Crewards"), displayMode: .inline)

        }
    }
    
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList()
    }
}

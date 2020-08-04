//
//  CardsList.swift
//  Crewards
//
//  Created by vabhaske on 26/07/20.
//

import SwiftUI
import UIKit
import SkeletonUI
struct CardsList: View {
    @State var isPresented = false
    @ObservedObject var ccData = CCData()
    init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
        appearance.accessoryType = .none
        UITableView.appearance().separatorStyle = .none
    }
    
    func cardHighlightsView(card:Card) -> some View {
        return VStack {
            HStack {
                Text("Great value for money")
                    .font(.system(size: 14, weight:.semibold, design: .default))
                .skeleton(with: card.id == -1)
                .shape(type: .rectangle)
                .animation(type: .linear())

            }
            Spacer()
            
            Text(card.benefits?.vouchers?.isEmpty ?? false ? "text" : card.benefits?.vouchers?[2]?.description?.replacingOccurrences(of: "\\n", with: "\n"))                .font(.system(size: 12, weight:.light, design: .default))
            .skeleton(with: card.id == -1)
                .shape(type: .rectangle)
                .animation(type:.linear())

            Spacer(minLength:20)
            HStack(alignment: .center,spacing: 10) {
                ForEach(card.categories ?? [],id :\.self){ category  in
                    Image(uiImage: UIImage(systemName:category.iconName)?.withRenderingMode(.alwaysTemplate))
                        .foregroundColor(category.iconColor)

                }
            }.padding(.bottom,10)
            .skeleton(with: card.id == -1)
            .shape(type: .rectangle)
            .animation(type: .linear())

        }
        
    }
    func horView() -> some View {
        GeometryReader { geo in
            
            SkeletonList (with:self.ccData.cards,quantity: 6)  { loading, card in
                    
                    VStack {
                        ZStack {
                            if(self.isPresented)
                            {
                                HStack {
                                    CardView(card:card ?? self.ccData.getEmptyCard(),geometry: geo)
                                        .padding(.horizontal,0)
                                        .transition(.moveUpWardsWhileFadingIn)
                                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                                    Spacer()
                                    self.cardHighlightsView(card:card ?? self.ccData.getEmptyCard())
                                    
                                }
                                
                            }
                            else
                            {
                                HStack {
                                    CardView(card:card ?? self.ccData.getEmptyCard(),geometry: geo)
                                        .padding(.horizontal,0)
                                    Spacer()
                                    self.cardHighlightsView(card:card ?? self.ccData.getEmptyCard())
                                }
                                
                                
                            }
                            NavigationLink(destination: EmptyView()) {
                                EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                        }
                        Divider()
                    
                    
                }
                
            }
                
            .navigationBarTitle(Text("Crewards"), displayMode: .inline)
        }
        
    }
    var body: some View {
        NavigationView {
            ZStack {
                self.horView()
                    
                    .padding(.horizontal,0)
                    .onAppear(){
                        self.isPresented = true
                        self.ccData.load()
                        self.ccData.addNewCards()
                }
                    
                .onDisappear(){
                    self.isPresented = false
                }
            }
        }
        
        
    }
    
    
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList()
    }
}

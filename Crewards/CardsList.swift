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
    @Environment(\.presentationMode) var presentationMode
    @State private var showingFilterSheet = false
    init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
        appearance.accessoryType = .none
        UITableView.appearance().separatorStyle = .none
    }
    
   
    func horView() -> some View {
        GeometryReader { geo in
            
            SkeletonList (with:self.ccData.cards,quantity: 6)  { loading, card1 in
               ProductCard(card:card1 ?? self.ccData.getEmptyCard(),geometry: geo, buttonHandler: nil)
            }
                
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(
                // leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()},
                trailing: NavigationLink(destination: SessionInfo()) {
                    Image(systemName: "questionmark.circle")
                        .imageScale(.large)
                        .accessibility(label: Text("user profile"))
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                self.horView()
                    .padding(.horizontal,0)
                Spacer()
                    
                    .onAppear(){
                        self.isPresented = true
                        self.ccData.load()
                        //  self.ccData.addNewCards()
                }
                    
                .onDisappear(){
                    self.isPresented = false
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                            NavigationLink(destination: SessionInfo()) {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .imageScale(.large)
                                .accessibility(label: Text("user profile"))
                                .font(.system(.largeTitle))
                                .frame(width: 47, height: 47)
                                .foregroundColor(Color.white)
                                .onTapGesture {
                                    self.showingFilterSheet=true
                                }
                            
                        }
                        .buttonStyle(PlainButtonStyle())

                        .background(Color.blue)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                        .sheet(isPresented: $showingFilterSheet) {
                            AppView()
                            // action sheet here
                            }
                    }
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

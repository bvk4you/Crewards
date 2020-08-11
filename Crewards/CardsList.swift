//
//  CardsList.swift
//  Crewards
//
//  Created by vabhaske on 26/07/20.
//

import SwiftUI
import UIKit
import SkeletonUI
import Combine
struct CardsList: View {
    @State var isPresented = false
    @EnvironmentObject var ccData:CCData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingFilterSheet = false
    @State var bottomState = CGSize.zero
    @State var sortFilter:[String:SortFilterModel]?
    @State var sortState = SortFilterState()
    
        init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
        appearance.accessoryType = .none
        appearance.backgroundColor = .none
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .none
        
        
    }
 @ViewBuilder   func mainView() -> some View{
        ZStack(alignment: .top) {
            listView()

             Text("Showing \(self.ccData.cards.count) Cards")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.gray)
                .opacity(self.ccData.cards.count == 0 ? 0 : 1)
                .animation(.easeInOut)
                .padding(.bottom,0)
        }
        .onAppear(){
            self.isPresented = true
            self.ccData.load()
            self.ccData.loadSortFilterData()
            self.ccData.addNewCards()
        }
        
        .onDisappear(){
            self.isPresented = false
        }
        
        .onReceive(self.ccData.$sortFilterState) {test in
            self.sortState = test
        }

    }
    
  @ViewBuilder  func listView() -> some View {
        GeometryReader { geo in
            
            SkeletonList (with:self.ccData.cards,quantity: 2)  { loading, card1 in
                NavigationLink(destination: AppView()) {
                    ProductCard(card:card1 ?? self.ccData.getEmptyCard(),geometry: geo, buttonHandler: nil)
                }
                
            }
                
            
        }
    }
    
  @ViewBuilder  func getContentView() -> some View {
        switch(self.ccData.state){
        case .idle:
             mainView()
        
        case .requestedFetch:
             mainView()

        case .fetchRequestFailed:
            Text("Request Failed")
            
        case .fetchRequestSucceededWithData:
             mainView()

            
        case .fetchRequestSucceededWithNoResults:
             Text("No Results found")

        }
    }
    
    var body: some View {
        NavigationView {
            getContentView()
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        
                        Button(action:
                                {
                                    self.showingFilterSheet = true
                                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()

                                }
                                )
                                {
                                    //Image(systemName: "arrow.up.arrow.down.circle")
                            Image("icons8-filter")
                                        .foregroundColor(self.ccData.isFilterApplied() ? Color.red: Color.black)
                                        //.background(self.ccData.isFilterApplied() ? Color.blue: Color.gray)
                                        .accessibility(label: Text("sort or filter"))
                                        .contentShape(Rectangle())
                                        .offset(x: self.ccData.cards.count>0 || self.ccData.isFilterApplied() ? 0 : -100, y: self.ccData.cards.count>0 || self.ccData.isFilterApplied() ? 0 : -100)
                                       // .frame(width: self.ccData.cards.count>0 ? 60 : 0, height: self.ccData.cards.count>0 ? 60 : 0)
    //                                    .cornerRadius(38.5)
    //                                    .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3, y: 3)
    //                                    .transition(.slide)
    //                                    .animation(.easeInOut(duration: 0.2))


                            }
                        .sheet(isPresented: self.$showingFilterSheet, onDismiss: {})
                        {
                                
                            
                            SortFilterView(isPresented:self.$showingFilterSheet)
                                .environmentObject(self.ccData)

                        }
                               
                        )
            
        }
    }
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList()
    }
}

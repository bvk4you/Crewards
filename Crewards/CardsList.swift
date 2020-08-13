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
extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}
struct CardsList: View {
    @State var isPresented = false
    @EnvironmentObject var ccData:CCData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDetailView = false
    @State private var isPresentingDetailView = false

    
    @State var selectedCard:Card?
    
    @State private var showingFilterSheet = false
    @State var bottomState = CGFloat(0)
    @State var detailViewSize = CGSize(width: 0, height: 0)

    @State var sortFilter:[String:SortFilterModel]?
    @State var sortState = SortFilterState()
    @State var cardGeometry:GeometryProxy?
    
    
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
            
            VStack {
                listView()

            }

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
        GeometryReader { geometry in
            ZStack {

                SkeletonList (with:self.ccData.cards,quantity: 2)  { loading, card1 in
                    NavigationLink(destination:
                                    ProductCard(card:card1 ?? self.ccData.getEmptyCard(), buttonHandler: nil)
                    ) {
                        GeometryReader { bounds in
                            ProductCard(card:card1 ?? self.ccData.getEmptyCard(), buttonHandler: nil)

                        }.frame(minHeight:350)

                    }

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
                .navigationBarTitle(
                    Text("")
                    ,
                    displayMode: .inline)
                .navigationBarItems(
                    leading: Text(self.ccData.isFilterApplied() ? "":
                                    "All Cards"
                    )
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.secondaryLabel))
                    .opacity(self.ccData.cards.count == 0 ? 0 : 1)
                    ,
                    trailing:
                        HStack {
                            Text(self.ccData.isFilterApplied() ?
                                    "\(self.ccData.cards.count)" : ""
                            )
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(.secondaryLabel))
                            .opacity(self.ccData.cards.count == 0 ? 0 : 1)

                            Button(action:
                                    {
                                        self.showingFilterSheet = true
                                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()
                                    }
                            )
                            {
                                Image("icons8-filter")
                                    .foregroundColor(self.ccData.isFilterApplied() ? Color.red: Color(.label))
                                    .accessibility(label: Text("sort or filter"))
                                    .contentShape(Rectangle())
                                    .offset(x: self.ccData.cards.count>0 || self.ccData.isFilterApplied() ? 0 : -100, y: self.ccData.cards.count>0 || self.ccData.isFilterApplied() ? 0 : -100)
                            }
                            .sheet(isPresented: self.$showingFilterSheet, onDismiss: {})
                            {
                                SortFilterView(isPresented:self.$showingFilterSheet)
                                    .environmentObject(self.ccData)
                            }
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

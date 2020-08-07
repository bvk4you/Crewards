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
    @EnvironmentObject var ccData:CCData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingFilterSheet = false
    @State var bottomState = CGSize.zero
    @State var sortFilter:[String:SortFilterModel]?
    init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
        appearance.accessoryType = .none
        UITableView.appearance().separatorStyle = .none
        
    }
    
    
    func horView() -> some View {
        GeometryReader { geo in
            
            SkeletonList (with:self.ccData.cards,quantity: 6)  { loading, card1 in
                
                NavigationLink(destination: AppView()) {
                    ProductCard(card:card1 ?? self.ccData.getEmptyCard(),geometry: geo, buttonHandler: nil)
                }
                
            }
                
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(
                // leading: Button("Back"){self.presentationMode.wrappedValue.dismiss()},
                trailing:                     Image(systemName: "arrow.up.arrow.down.circle")
                        .imageScale(.large)
                        .onTapGesture {
                            self.showingFilterSheet = true
                    }
                    .accessibility(label: Text("sort or filter"))
                        
                    .offset(x: self.ccData.cards.count>0 ? 0 : -100, y: self.ccData.cards.count>0 ? 0 : -100)
                    .frame(width: self.ccData.cards.count>0 ? 27 : 0, height: self.ccData.cards.count>0 ? 27 : 0)
                    .cornerRadius(38.5)
                    .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3, y: 3)
                    .transition(.slide)
                    .animation(.spring())
                    
                    
            )
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                self.horView()
                .blur(radius: showingFilterSheet ? 40 : 0,opaque: false)
                    .transition(.slide)
                .animation(.easeInOut(duration: 0.5))
                    
                    
                .onAppear(){
                    self.isPresented = true
                    self.ccData.load()
                    self.ccData.loadSortFilterData()
                    //  self.ccData.addNewCards()
                }

                .onDisappear(){
                    self.isPresented = false
                }
                
                if(self.showingFilterSheet)
                {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        Spacer()
                    }.background(Color.white.opacity(0.3))
                        .onTapGesture {
                            self.showingFilterSheet = false
                    }
                }
                
                BottomCardView()
                    .offset(x: 0, y: showingFilterSheet ? 260 : 1000)
                    .offset(y: bottomState.height)
                    .transition(.moveUpWardsWhileFadingIn)
                    .animation(.easeInOut(duration: 0.3))
                    .gesture(
                        DragGesture().onChanged { value in
                            if self.bottomState.height < value.translation.height {
                                self.bottomState = value.translation
                            }
                        }
                        .onEnded { value in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.showingFilterSheet = false
                                self.bottomState = CGSize.zero
                            }
                        }
                )
                                }
        }
    }
}

struct CardsList_Previews: PreviewProvider {
    static var previews: some View {
        CardsList()
    }
}
struct BottomCardView: View {
     @EnvironmentObject var ccData:CCData
    var body: some View {
        Group {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.1)
            Text("filters here")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .lineSpacing(4)
            HStack {
                List {
                    ForEach(self.ccData.sortFilterData?.allItems ?? [],id:\.self.name){ item in
                        Text(item.name)
                            .font(.system(size: 12, weight: .medium))
                        }

                    }
                
                List {
                    ForEach(self.ccData.sortFilterData?.selectedCategory.options ?? [],id:\.self){ item in
                    Text(item)
                        .font(.system(size: 12, weight: .medium))
                    }
                }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
        
        }
    
        .onAppear {
        }
    }
}

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
    
    @State var editingDone = false {
        didSet {
            if(editingDone != oldValue) {
               // self.ccData.load()
            }
        }

    }
    @State var text = "" {
        didSet {
                text = oldValue
            }
            
        }

        init() {
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
        appearance.accessoryType = .none
        appearance.backgroundColor = .none
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .none
        
        
    }
    
    
    func horView() -> some View {
        GeometryReader { geo in
            
            SkeletonList (with:self.ccData.cards,quantity: 0)  { loading, card1 in
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
                    //.transition(self.ccData.cards.count > 0 ? .moveUpWardsWhileFadingIn : .opacity)
                   // .animation(self.ccData.cards.count > 0 ? .easeInOut(duration: 0.5) : .none)
//
                    
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
//                if(self.ccData.sortFilterData !=   nil)
//                {
                    BottomCardView(editingDone:
                        Binding<Bool>(
                         get: {
                             self.editingDone
                        },
                         set: {
                            self.editingDone = $0
                        }) ,isPresented:self.$showingFilterSheet)
                      
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
                    
                //}
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
    @Binding var editingDone:Bool
    @Binding var isPresented:Bool

    @EnvironmentObject var ccData:CCData
    @State var currentItem:SortFilterItem?
    @State var sortState = SortFilterState()
    var body: some View {
        Group {
            VStack(spacing: 20) {
                Rectangle()
                    .frame(width: 40, height: 5)
                    .cornerRadius(3)
                    .opacity(0.1)
                HStack{
                    Button(action:{
                        self.sortState = self.ccData.sortFilterState
                            self.isPresented=false
                        
                    }){
                        Text("X")
                    }.padding(.trailing,20)
                    
                    Text("Sort/Filter")
                    .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Button(action: {self.sortState = SortFilterState()}){
                        Text("CLEAR ALL")
                        .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.orange)
                    }
                   

                }

                HStack {
                    VStack {
                        List {
                            ForEach(self.ccData.sortFilterData?.allItems ?? [],id:\.self.name){ item in
                                Button(action:{
                                    self.currentItem = item
                                }){
                                    VStack {
                                        HStack{
                                            Text(item.name.capitalized)
                                                .font(.system(size: 14, weight:.semibold))

                                            Spacer()
                                        }
                                        Divider()
                                    }
                                }.foregroundColor(self.currentItem?.name == item.name ? Color(UIColor.black):Color(.gray))
                                
                            }
                            
                        }
                        
                    }
                    VStack {
                        List {
                        ForEach(self.currentItem?.options ?? [],id:\.self){ item in
                            Button(action:{
                                switch(self.currentItem?.name)
                                {
                                case "Categories":
                                    if let index =                                     self.sortState.categoryOptions.firstIndex(of: item) {
                                        self.sortState.categoryOptions.remove(at: index)
                                    }
                                    else
                                    {
                                        self.sortState.categoryOptions.append(item)
                                    }
                                    
                                case "Sort":
                                    self.sortState.sortOn = item
                                default:
                                    print("")
                                
                                }
                                            
                                }
                                ){
                                    if(self.currentItem?.name == "Categories")
                                    {
                                        Text(item.capitalized)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(self.sortState.categoryOptions.contains(item) ? Color.red : Color.black)
                                    }
                                    else if(self.currentItem?.name == "Sort")
                                    {
                                        Text(item.capitalized)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(self.sortState.sortOn == item  ? Color.red : Color.black)

                                    }
                            }
                                    
                        }
                        }
                        Text("test")
                        
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 20)
            //.frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 20)
            HStack {
                Spacer()
            CustomButton(label: "Apply", action: {
                self.isPresented = false
                self.editingDone = true
                self.ccData.loadWithFilter(filter: self.sortState)
            }).padding(.trailing,10)
            }

            .onReceive(self.ccData.$sortFilterState) {test in
                                      print("Combine \(test)")
                self.sortState = test

                }
            .onReceive(self.ccData.$sortFilterData) {test in
                                      print("Combine \(test)")
                self.currentItem = test?.selectedCategory

                }

        }
            
        .onAppear {
            self.sortState = self.ccData.sortFilterState
            self.currentItem = self.ccData.sortFilterData?.selectedCategory
            self.editingDone = false

        }
    }
}

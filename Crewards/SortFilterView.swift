//
//  SortFilterView.swift
//  Crewards
//
//  Created by vabhaske on 10/08/20.
//

import SwiftUI

struct SortFilterView: View {
        @Binding var isPresented:Bool

        @EnvironmentObject var ccData:CCData
        @State var currentItem:SortFilterItem?
        @State var sortState = SortFilterState()
        @State var showProgress = false
    func categoryOptionsView(item:CardCategory) -> some View {
            
              return  HStack {
                    
                Image("icons8-checked")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(self.sortState.categoryOptions.contains(item) ? Color.green : Color(.secondaryLabel))
                Text(item.rawValue.capitalized)
                    .font(.system(size: 12, weight: self.sortState.categoryOptions.contains(item) ? .bold : .medium))
                    .foregroundColor(self.sortState.categoryOptions.contains(item) ? Color(.label) : Color(.secondaryLabel))
              }.eraseToAnyView()
            
    }
    func BenefitOptionsView(item:BenefitsCategory) -> some View {
            
             return   HStack {
                Image("icons8-checked")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color.green :Color(.secondaryLabel))
                Text(item.rawValue.capitalized)
                    .font(.system(size: 12, weight: self.sortState.benefitsOptions.contains(item) ? .bold : .medium))
                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color(.label)  :Color(.secondaryLabel))
             }.eraseToAnyView()
      
    }

    func sortOptionsView(item:String) -> some View {
          return  HStack {
                    Image("icons8-checked")
                        .font(.system(size: 16, weight: .medium))                                                .foregroundColor(self.sortState.sortOn == item  ? Color.green : Color(.secondaryLabel))

                Text(item)
                    .font(.system(size: 12, weight: self.sortState.sortOn == item ? .bold : .medium))
                    .foregroundColor(self.sortState.sortOn == item  ?  Color(.label) :Color(.secondaryLabel))
          }.eraseToAnyView()
    }
    func rewardsView(item:Double) -> some View {
          return  HStack {
                    Image("icons8-checked")
                        .font(.system(size: 16, weight: .medium))                                                .foregroundColor(self.sortState.rewardRange == item  ? Color.green : Color(.secondaryLabel))

                Text(String("More than \(item)%"))
                    .font(.system(size: 12, weight: self.sortState.rewardRange == item ? .bold : .medium))
                    .foregroundColor(self.sortState.rewardRange == item  ?  Color(.label) :Color(.secondaryLabel))
          }.eraseToAnyView()
    }


        var body: some View {
            Group {
                GeometryReader { geo in
                VStack(spacing: 20) {

                    Rectangle()
                        .frame(width: 40, height: 5)
                        .cornerRadius(3)
                        .opacity(0.1)
                    HStack{
                        Button(action:{
                            self.sortState = self.ccData.sortFilterState
                            self.isPresented=false
                            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()

                            
                        }){
                            Text("᙮")
                                .font(.system(size: 28, weight: .bold))

                        }.padding(.trailing,20)
                        .disabled(self.showProgress == true )
                        .opacity(self.showProgress == true ? 0.3 : 1.0)

                        Text("Sort / Filter")
                        .font(.system(size: 16, weight: .bold))
                        Spacer()
                        Button(action: {
                                self.sortState = SortFilterState()
                                let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()

                            
                        }){
                            Text("CLEAR ALL")
                            .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.orange)
                        }
                       

                    }
                    if(self.showProgress)
                    {
                        ProgressBar(completion:{
                            self.isPresented = false
                            self.showProgress = false
                            self.sortState.source = "local"
                            self.ccData.updateSortFilterSelectedTab(item: self.currentItem!)
                            self.ccData.loadWithFilter(filter: self.sortState)

                        })
                        .frame(height:3)
                    }
                    else {
                        Divider()
                            .frame(minHeight:5)
                        
                    }
//                    HStack {
//                        VStack(alignment:.trailing) {
//                        Text(self.currentItem?.title)
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(Color.black)
//                        }
//                    }

                    HStack {
                        
                        VStack(spacing:20) {

                            NoSeparatorList {
                                
                                ForEach(self.ccData.sortFilterData?.allItems ?? [],id:\.self.name){ item in
                                    Button(action:{
                                        self.currentItem = item
                                    }){
                                        VStack {
                                            HStack{
                                                Text(item.name.capitalized)
                                                    .font(.system(size: 14, weight: self.currentItem?.name == item.name ? .bold : .semibold))

                                                Spacer()
                                            }
                                        }
                                    }.foregroundColor(self.currentItem?.name == item.name ? Color(.label):Color(.secondaryLabel))
                                    
                                }
                                
                            }
                            
                        }.frame(width:geo.size.width/2 - 30)
                        //Spacer(minLength:geo.size.)
                        VStack(alignment:.leading,spacing:20) {
                            
                                Text(self.currentItem?.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(.label))
                                NoSeparatorList {
                                switch(self.currentItem?.name)
                                {
                                case "Categories":
                                    ForEach(CardCategory.allCases,id:\.self) { item in
                                        Button(action:{
                                            
                                            if let index = self.sortState.categoryOptions.firstIndex(of: item) {
                                                self.sortState.categoryOptions.remove(at: index)
                                            }
                                            else
                                            {
                                                self.sortState.categoryOptions.append(item)
                                            }

                                        })
                                        {
                                            self.categoryOptionsView(item:item)
                                        }
                                    }
                                    
                                case "Benefits":
                                    ForEach(BenefitsCategory.allCases,id:\.self) { item in
                                        Button(action:{

                                        if let index = self.sortState.benefitsOptions.firstIndex(of: item) {
                                            self.sortState.benefitsOptions.remove(at: index)
                                        }
                                        else
                                        {
                                            self.sortState.benefitsOptions.append(item)
                                        }
                                        })
                                        {
                                            self.BenefitOptionsView(item: item)
                                                .padding(.trailing,10)
                                        }
                                    }

                                 case "Sort":
                                    ForEach(self.currentItem?.options ?? [],id:\.self) { item in
                                        Button(action:{
                                            self.sortState.sortOn = item
                                        }){
                                            sortOptionsView(item: item)
                                        }
                                        
                                    }
                                    
                                case "Rewards":
                                   ForEach(self.currentItem?.options ?? [],id:\.self) { item in
                                       Button(action:{
                                        self.sortState.rewardRange = Double(item)!
                                       })
                                       {
                                        rewardsView(item: Double(item)!)
                                            
                                       }
                                       
                                       
                                   }
                                
                                default: Text("")
                                }
                            }
                            .id(UUID())
                            
                                

                        }
                    }
                    CustomButton(label:"APPLY CHANGES",
                                 action: {
                   
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                                    self.showProgress = true

                        }
                    )
                    .disabled(self.showProgress == true )
                    .opacity(self.showProgress == true ? 0.3 : 1.0)
                    .padding(.bottom,(self.sortState != self.ccData.sortFilterState) ? 20 : -20)
                    .opacity((self.sortState != self.ccData.sortFilterState) ? 1.0 : 0)
                    .animation(.interactiveSpring())


                }
                .padding(.top, 8)
                .padding(.horizontal, 20)
                //.frame(maxWidth: .infinity)
               // .background(Color.white)
                
                .onReceive(self.ccData.$sortFilterState) {test in
                    self.sortState = test

                    }
                .onReceive(self.ccData.$sortFilterData) {test in
                    self.currentItem = test?.selectedCategory

                    }

            }
                
                
            .onAppear {
                self.sortState = self.ccData.sortFilterState
                self.currentItem = self.ccData.sortFilterData?.selectedCategory

            }
            }
    }
}

//struct SortFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        SortFilterView()
//    }
//}

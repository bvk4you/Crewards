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
    
    func categoryOptionsView(item:CardCategory) -> some View {
            
              return  HStack {
                    
                Image("icons8-checked")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(self.sortState.categoryOptions.contains(item) ? Color.green : Color.gray)
                Text(item.rawValue.capitalized)
                    .font(.system(size: 12, weight: self.sortState.categoryOptions.contains(item) ? .bold : .medium))
                    .foregroundColor(self.sortState.categoryOptions.contains(item) ? Color.black : Color.gray)
              }.eraseToAnyView()
            
//        case "Benefits":
//
//             return   HStack {
//                Image("icons8-checked")
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color.green : Color.gray)
//                Text(item.rawValue.capitalized)
//                    .font(.system(size: 12, weight: self.sortState.benefitsOptions.contains(item) ? .bold : .medium))
//                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color.black : Color.gray)
//             }.eraseToAnyView()
//

    
      
    }
    func BenefitOptionsView(item:BenefitsCategory) -> some View {
            
             return   HStack {
                Image("icons8-checked")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color.green : Color.gray)
                Text(item.rawValue.capitalized)
                    .font(.system(size: 12, weight: self.sortState.benefitsOptions.contains(item) ? .bold : .medium))
                    .foregroundColor(self.sortState.benefitsOptions.contains(item) ? Color.black : Color.gray)
             }.eraseToAnyView()
      
    }

    func sortOptionsView(item:String) -> some View {
          return  HStack {
                    Image("icons8-checked")
                        .font(.system(size: 16, weight: .medium))                                                .foregroundColor(self.sortState.sortOn == item  ? Color.green : Color.gray)

                Text(item)
                    .font(.system(size: 12, weight: self.sortState.sortOn == item ? .bold : .medium))
                    .foregroundColor(self.sortState.sortOn == item  ? Color.black : Color.gray)
          }.eraseToAnyView()
    }
    func rewardsView(item:Double) -> some View {
          return  HStack {
                    Image("icons8-checked")
                        .font(.system(size: 16, weight: .medium))                                                .foregroundColor(self.sortState.rewardRange == item  ? Color.green : Color.gray)

                Text(String("More than \(item)%"))
                    .font(.system(size: 12, weight: self.sortState.rewardRange == item ? .bold : .medium))
                    .foregroundColor(self.sortState.rewardRange == item  ? Color.black : Color.gray)
          }.eraseToAnyView()
    }


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
                            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                impactMed.impactOccurred()

                            
                        }){
                            Text("᙮")
                                .font(.system(size: 28, weight: .bold))

                        }.padding(.trailing,20)
                        
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
                    Divider()
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
                                                    .font(.system(size: 14, weight: self.currentItem?.name == item.name ? .bold : .semibold))

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
                                       }){
                                        rewardsView(item: Double(item)!)
                                       }
                                       
                                   }
                                
                                default: Text("")
                                }
                            }
                            HStack
                            {
                                Spacer()
                                Group {
                                    CustomButton(label:"APPLY",
                                                 action: {
                                    self.isPresented = false
                                            self.sortState.source = "local"
                                    self.ccData.loadWithFilter(filter: self.sortState)
                                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()

                                        }
                                    ).padding()
                                    
                                }
                                
                            }
                            
                        }
                    }
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

//struct SortFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        SortFilterView()
//    }
//}

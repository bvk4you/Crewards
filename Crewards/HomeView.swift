//
//  HomeView.swift
//  Crewards
//
//  Created by vabhaske on 26/07/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabbarView()
        
    }
}
struct TabbarView: View {
    @State var selectedTab = Tab.home
    
    enum Tab: Int {
        case home, discover, fanClub, myLists
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
            
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CardsList().tabItem{
                self.tabbarItem(text: "All", image: "creditcard.fill")
            }.tag(Tab.home)
            DiscoverView().tabItem{
                self.tabbarItem(text: "Discover", image: "square.stack")
            }.tag(Tab.discover)
            OffersView().tabItem{
                self.tabbarItem(text: "Offers", image: "indianrupeesign.circle")
            }.tag(Tab.myLists)
            MyCardsView().tabItem{
                self.tabbarItem(text: "You", image: "person.crop.circle")
            }.tag(Tab.fanClub)
            
        }.navigationBarTitle("Home")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

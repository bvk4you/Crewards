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
                self.tabbarItem(text: "Home", image: "film")
            }.tag(Tab.home)
            PhoneSignInView().tabItem{
                self.tabbarItem(text: "Discover", image: "square.stack")
            }.tag(Tab.discover)
            AppView().tabItem{
                self.tabbarItem(text: "Fan Club", image: "star.circle.fill")
            }.tag(Tab.fanClub)
            AppView().tabItem{
                self.tabbarItem(text: "My Lists", image: "heart.circle")
            }.tag(Tab.myLists)
        }.navigationBarTitle("Home")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  BeActiveTabView.swift
//  testWatch
//
//  Created by Brenda Elena Saucedo Gonzalez on 20/05/25.
//

import SwiftUI

struct BeActiveTabView: View {
    
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag("Home")
                .environmentObject(manager)
            
            Text("Content")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag("Content")
        } // -> TabView
        
    } // -> body
    
} // -> BeActiveTabView

#Preview {
    BeActiveTabView()
} // -> Preview

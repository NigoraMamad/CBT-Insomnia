//
//  ActivityCard.swift
//  testWatch
//
//  Created by Brenda Elena Saucedo Gonzalez on 20/05/25.
//

import SwiftUI

struct ActivityCard: View {
    
    @State var activity: Activity
    
    var body: some View {
        
        ZStack {
            
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            
            VStack(spacing: 20) {
                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.system(size: 16))
                        Text(activity.subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                    } // -> VStack
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundStyle(.gray)
                    
                } // -> HStack
                
                Text(activity.amount)
                    .font(.system(size: 24))
                
            } // -> VStack
            .padding()
            
        } // -> ZStack
        
    } // -> body
    
} // -> ActivityCard

#Preview {
    ActivityCard(activity: Activity(id: 0, title: "Daily steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "6,545"))
} // -> Preview

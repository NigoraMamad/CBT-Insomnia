//
//  LastNightCardView.swift
//  CBT-Insomnia
//
//  Created by Michele Coppola on 22/05/25.
//

import SwiftUI

struct LastNightCardView: View {
    var body: some View {
        ZStack {
            CardView(height: 400)
            VStack {
                HStack {
                    HStack {
                        Text("MON")
                            .bold()
                            .font(.largeTitle)
                        VStack {
                            Text("19TH")
                                .font(.caption)
                                .fontWeight(.medium)
                            Text("MAY")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    Text("70%")
                        .bold()
                        .font(.largeTitle)
                }
                .padding(40)
                
                SegmentedCircularProgressView(
                    segments: [
                        SegmentData(value: 0.16, gap: 0.16),
                        SegmentData(value: 0.16, gap: 0.16),
                        SegmentData(value: 0.16, gap: 0.16)
                    ],
                    segmentColor: Color("csOrange"),
                    backgroundCircleColor: Color("csOrange").opacity(0.4) ,
                    lineWidth: 35,
                    size: CGSize(width: 180, height: 180)
                )
                .shadow(radius: 12)
                HStack {
                    VStack(alignment: .leading) {
                        Text("you slept")
                            .font(.callout)
                        Text("5h 30m")
                            .bold()
                            .font(.title)
                    }
                    
                    Spacer()
                }
                .padding(40)
            }
        }
        .foregroundStyle(.white)
        .ignoresSafeArea()
    }
}

#Preview {
    LastNightCardView()
      
}

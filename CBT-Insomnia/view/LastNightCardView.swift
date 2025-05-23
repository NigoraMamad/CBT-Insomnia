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
            VStack(spacing: 25) {
                HStack(spacing: 20) {
                    Image(systemName: "moon.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                    Text("Last night")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .bold()
                }
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
                        .font(.system(size: 48))
                }
            
                
                SegmentedCircularProgressView(
                    segments: [
                        SegmentData(value: 0.16, gap: 0.16),
                        SegmentData(value: 0.16, gap: 0.16),
                        SegmentData(value: 0.16, gap: 0.16)
                    ],
                    segmentColor: Color("csOrange"),
                    backgroundCircleColor: .ultraThinMaterial,
                    lineWidth: 45,
                    size: CGSize(width: 170, height: 170)
                )
                .shadow(radius: 3)
                .padding()
                
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
            }
            .padding(40)
        }
        .background( RoundedRectangle(cornerRadius: 30)
            .foregroundStyle(.ultraThinMaterial.opacity(0.75))
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(LinearGradient(colors: [.white, .black, .black, .white, .white], startPoint: .bottomTrailing, endPoint: .leading))
            }
            .padding()
            .shadow(radius: 4, x: 4, y: 4))
        .foregroundStyle(.white)
        .ignoresSafeArea()
    }
}

#Preview {
    LastNightCardView()
      
}

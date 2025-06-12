//
//  LastNightCard.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 30/05/25.
//

import SwiftUI

struct LastNightCard: View {
    let session: SleepSession
    
    // Calculate efficiency color based on value
    private var efficiencyColor: Color {
        let efficiency = min(session.sleepEfficiency, 100)
        if efficiency < 75 {
            return .lowEfficiency
        } else if efficiency < 85 {
            return .mediumEfficiency
        } else {
            return .accent
        }
    }
    
    // Get message based on efficiency
    private var efficiencyMessage: String {
        let efficiency = min(session.sleepEfficiency, 100)
        if efficiency < 75 {
            return "Keep practicing"
        } else if efficiency < 85 {
            return "Close enough"
        } else {
            return "You got this!"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Text outside the card
            Text("About last night")
                .font(.krungthep(.regular, relativeTo: .callout))
                .foregroundStyle(.white)
            
            // Card content
            VStack {
                if session.isComplete {
                    HStack(spacing: 12) {
                        // Left side - Vertical progress bar aligned at bottom
                        VStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            ZStack(alignment: .bottom) {
                                // Background bar
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 85, height: 150)
                                    .clipShape(RoundedCorners(radius: 2.85, corners: [.topLeft, .topRight]))
                                
                                RoundedCorners(radius: 2.85, corners: [.topLeft, .topRight])
                                    .stroke(efficiencyColor, lineWidth: 1)
                                    .frame(width: 85, height: 150)
                                
                                // Progress fill
                                Rectangle()
                                    .fill(efficiencyColor)
                                    .frame(width: 85, height: max(0, min(150, CGFloat(min(session.sleepEfficiency, 100) / 100) * 150)))
                                
                                // 85% threshold line
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 85, height: 1)
                                    .offset(y: -(150 * 0.85))
                                
                                // 85% label
                                Text("85%")
                                    .font(.krungthep(.regular, relativeTo: .caption))
                                    .foregroundColor(.white)
                                    .offset(x: 65, y: -(150 * 0.80))
                            }
                        }
                        .padding(.leading, 8)
                        .frame(height: 150)
                        
                        // Right side - Text info, closer to the edge
                        VStack(alignment: .trailing, spacing: 4) {
                            Image(systemName: "chevron.right")                                .foregroundColor(.white)
                            
                            Spacer()
                            Text("You slept \(Int(session.timeInBed / 3600))h")
                                .font(.krungthep(.regular, relativeTo: .callout))
                                .foregroundColor(.white)
                            
                            Text(Int(session.sleepEfficiency).formatted(.percent))
                                .font(.dsDigital(.bold, size: 80))
                                .foregroundColor(efficiencyColor)
                            
                            Text(efficiencyMessage.uppercased())
                                .font(.krungthep(.regular, relativeTo: .caption))
                                .foregroundColor(efficiencyColor)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.trailing, 4)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                } else {
                    // In progress state
                    VStack(spacing: 36) {
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.white)
                        Text("Sleep Session In Progress")
                            .font(.krungthep(.regular, size: 20))
                            .foregroundColor(.mediumEfficiency)
                        
                        HStack {
                            Label(session.formattedBadgeInTime, systemImage: "moon.zzz.fill")
                                .font(.krungthep(.regular, relativeTo: .callout))
                                .foregroundStyle(.white)
                            Spacer()
                            Text("--:--")
                                .font(.krungthep(.regular, relativeTo: .callout))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding()
                }
            }
            .frame(width: 334, height: 180)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.lastNightBg)
                    .frame(width: 334, height: 180)
            }
        }
    }
}

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}



#Preview {
    let now = Date()
    let earlier = Calendar.current.date(byAdding: .hour, value: -6, to: now)!
    let session = SleepSession(day: .now, badgeBedTime: earlier, sleepDuration: 3 * 3600)
    
    ZStack {
        Color.black
        LastNightCard(session: session)
    }
    .ignoresSafeArea()
}

//
//  BadgeSleepCard.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 01/06/25.
//

import SwiftUI

struct BadgeSleepCard: View {
    
    let fixedBedTime: String
    let fixedWakeTime: String
    var onBedTap: (() -> Void)? = nil
    var onWakeTap: (() -> Void)? = nil
    @State private var activeButton: SleepButtonType? = .bed
    @State private var usageWeek: Int = 1
    
    enum SleepButtonType {
        case bed, wake
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Week X Text
            Text("WEEK \(usageWeek)")
                .font(.krungthep(.regular, relativeTo: .title3))
                .foregroundColor(.accent)
            
            HStack(alignment: .top, spacing: 40) { // più spazio tra colonne
                VStack(spacing: 4) {
                    Text("In Bed")
                        .font(.krungthep(.regular, relativeTo: .caption))
                        .foregroundColor(.white)
                    Label(fixedBedTime, systemImage: "bed.double.fill")
                        .alignmentGuide(.top) { d in d[.top] }
//                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                
                VStack(spacing: 4) {
                    Text("Awake")
                        .font(.krungthep(.regular, relativeTo: .caption))
                        .foregroundColor(.white)
                    Label(fixedWakeTime, systemImage: "figure.walk")
                        .alignmentGuide(.top) { d in d[.top] }
//                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            }
            .overlay(
                GeometryReader { geo in
                    Divider()
                        .frame(width: geo.size.width * 0.30, height: 1)
                        .background(Color.white)
                        .position(
                            x: geo.size.width / 2,
                            y: 46
                        )
                }
            )
        }
        .onAppear {
            let startDate = UserDefaultsService.shared.getAppStartDate()
            usageWeek = Date().weeksSince(startDate) + 1
        }
        .foregroundStyle(.white)
        .font(.krungthep(.regular, relativeTo: .callout))
//        .frame(width: 340, height: 160)
    }
}

// MARK: - Date Extension

extension Date {
    func weeksSince(_ fromDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: fromDate)?.start ?? fromDate
        let currentWeek = calendar.dateInterval(of: .weekOfYear, for: self)?.start ?? self
        return calendar.dateComponents([.weekOfYear], from: startOfWeek, to: currentWeek).weekOfYear ?? 0
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(.black)
        BadgeSleepCard(fixedBedTime: "02:00", fixedWakeTime: "07:00")
    }
    .ignoresSafeArea()
}

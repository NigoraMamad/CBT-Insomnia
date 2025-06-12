//
//  TrackingBedView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 02/06/25.
//

import SwiftUI
import WatchConnectivity
import SwiftData

struct TrackingBedView: View {
    
    @Environment(\.modelContext) private var modelContext

    @StateObject var receiver = WatchReceiver()
    @State private var showGoodnight = false
    @State private var isMainViewShown = false
    
    @EnvironmentObject private var sleepDataService: SleepDataService
    
    @State private var isTestMode = false
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Spacer()
                
                Image(systemName: "bed.double.fill")
                    .foregroundStyle(.accent)
                    .neon(glowRadius: 1)
                    .font(.system(size: 65))
                    .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    if !receiver.isTracking && !showGoodnight {
                        // Initial state - waiting for tracking to start
                        Text("Go to bed and badge-in your night")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    } else if receiver.isTracking && !showGoodnight {
                        // Tracking state - show progress and feedback
                        Text("Tracking")
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                            .scaleEffect(1.5)
                        
                        if receiver.isWristFlat && receiver.isWristStill {
                            Text("You are in bed!")
                                .foregroundColor(.green)
                                .font(.system(size: 18, weight: .medium))
                        }
                    } else if showGoodnight {
                        // Goodnight state
                        Text("Okay goodnight!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 24, weight: .medium))
                    }
                }
                .frame(height: 200) // Fixed height to prevent layout jumping
                
                Spacer()
            }
            
            // Show OK button when in goodnight state
            if showGoodnight {
                VStack {
                    Spacer()
                    BadgeSleepButton(label: "OK!", isActive: true) {
                        isMainViewShown = true
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .font(.krungthep(.regular, relativeTo: .title))
        .foregroundColor(.white)
        .ignoresSafeArea()
        .onChange(of: receiver.isWristFlat) { _, newValue in
            checkForGoodnight()
        }
        .onChange(of: receiver.isWristStill) { _, newValue in
            checkForGoodnight()
        }
        .fullScreenCover(isPresented: $isMainViewShown) {
            ContentView(context: modelContext) // or whatever your main view is called
        }
        
#if DEBUG
        // In TrackingBedView body
        Toggle("🏷️ Test Badge-in", isOn: $isTestMode)
            .padding()
            .onChange(of: isTestMode) { on in
                if on {
                    receiver.isTracking = true
                    receiver.isWristFlat = true
                    receiver.isWristStill = true
                    checkForGoodnight()
                }
            }
#endif
    }
    
    private func checkForGoodnight() {
        if receiver.isTracking && receiver.isWristFlat && receiver.isWristStill && !showGoodnight {
            // Add a small delay for better UX
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showGoodnight = true
                
                // Save badge-in time
                SleepDataService.shared.startSleepSession(context: modelContext)
                
                // Tell the watch to stop tracking
                WCSession.default.sendMessage(["command": "stopTracking"], replyHandler: nil, errorHandler: { error in
                    print("❌ Failed to send stop command: \(error.localizedDescription)")
                })
            }
        }
    }
}

#Preview {
    TrackingBedView()
}

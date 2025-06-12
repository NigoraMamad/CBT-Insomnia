//
//  ContentViewWrapper.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//


import SwiftUI
import SwiftData

struct ContentViewWrapper: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ContentView(context: modelContext)
    }
}

//#Preview {
//    @Previewable @StateObject var sleepDataService = SleepDataService()
//    ContentViewWrapper()
//        .environmentObject(SleepDataService.shared)
//}

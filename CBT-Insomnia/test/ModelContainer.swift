//
//  ModelContainer.swift
//  CBT-Insomnia
//
//  Created by Nigorakhon Mamadalieva on 09/06/25.
//

import SwiftData

extension ModelContainer {
    static var preview: ModelContainer {
        let schema = Schema([SleepSession.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("❌ Failed to create preview ModelContainer: \(error)")
        }
    }
}

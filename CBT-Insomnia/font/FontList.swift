//
//  Untitled.swift
//  AlarmTest
//
//  Created by Gianpietro Panico on 28/05/25.
//

import SwiftUI

struct FontListView: View {
    var body: some View {
        Text("Controlla la console per l'elenco dei font")
            .onAppear {
                for familyName in UIFont.familyNames.sorted() {
                    print("📂 Font family: \(familyName)")
                    let fontNames = UIFont.fontNames(forFamilyName: familyName)
                    for fontName in fontNames {
                        print("    → \(fontName)")
                    }
                }
            }
    }
}

#Preview {
    FontListView()
}

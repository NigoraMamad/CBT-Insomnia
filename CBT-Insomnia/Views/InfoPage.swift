//
//  InfoPage.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 10/06/25.
//
//
//  InfoPage.swift
//  CBT-Insomnia
//
//  Created by Gianpietro Panico on 10/06/25.
//

import SwiftUI

struct InfoPage: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Disclaimer")
                            .font(.krungthep(.regular, relativeTo: .largeTitle))
                            .foregroundColor(.white)
                        
                        Group {
                            Text("❗️ This app is not a medical device.")
                                .font(.krungthep(.regular, relativeTo: .title))
                            Text("The information provided is for informational purposes only and should not be considered medical advice or used for diagnosing or treating sleep disorders.")
                                .font(.krungthep(.regular, relativeTo: .body))
                                .foregroundColor(.white)
                        }
                        
                        Group {
                            Text("🔒 Sleep data tracking")
                                .font(.krungthep(.regular, relativeTo: .title))
                            Text("The app records your sleep habits locally on your device. Your data is not altered, sold, or shared with third parties.")
                                .font(.krungthep(.regular, relativeTo: .body))
                                .foregroundColor(.white)
                        }
                        
                        Group {
                            Text("📱 Responsible use")
                                .font(.krungthep(.regular, relativeTo: .title))
                            Text("This app is designed to support self-awareness and reflection. If you experience sleep-related issues, please consult a qualified healthcare professional.")
                                .font(.krungthep(.regular, relativeTo: .body))
                                .foregroundColor(.white)
                        }
                        
                        // 🔽 Credits Section
                        Divider()
                            .background(Color.gray.opacity(0.5))
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Credits")
                                .font(.krungthep(.regular, relativeTo: .headline))
                                .foregroundColor(.white)
                            
                            Text("Gianpietro Panico\nDario Saldamarco\nMatteo Romano\nMichele Coppola\nBrenda Saucedo\nNigorakhon Mamadalieva")
                                .font(.krungthep(.regular, relativeTo: .footnote))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 10)
                    }
                    .foregroundColor(.white)
                    .padding()
                }
                .background(Color.black.ignoresSafeArea())
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    InfoPage()
}

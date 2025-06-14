//
//  CustomPicker.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 30/05/25.
//

import SwiftUI

struct CustomPicker: View {
    
    @Namespace private var animation
    
    @Binding var selection: Period
    
    var options: [Period]
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            ForEach(options, id: \.self) { opt in
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selection = opt
                    } // -> withAnimation
                } label: {
                    Text(opt.rawValue)
                        .foregroundStyle(selection == opt ? .black : .white)
                        .frame(maxWidth: .infinity, minHeight: 15, maxHeight: 20)
                        .padding(.vertical, 4)
                } // -> Button
                .background(
                    ZStack {
                        if selection == opt {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .matchedGeometryEffect(id: "background", in: animation)
                        } // -> if
                    } // -> ZStack
                ) // -> Button.background
            } // -> ForEach
            
        } // -> HStack
        .background(.grayNA)
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        
    } // -> body
    
} // -> CustomPicker

#Preview {
    CustomPicker(selection: .constant(Period.day), options: Period.allCases)
} // -> Preview

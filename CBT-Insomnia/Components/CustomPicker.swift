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
                        .font(.system(size: 17.5))
                        .foregroundStyle(selection == opt ? .accent : .black)
                        .frame(maxWidth: .infinity, minHeight: 20)
                        .padding(.vertical, 4)
                } // -> Button
                .background(
                    ZStack {
                        if selection == opt {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "background", in: animation)
                        } // -> if
                    } // -> ZStack
                ) // -> Button.background
            } // -> ForEach
            
        } // -> HStack
        .padding(4)
        .background(.accent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    } // -> body
    
} // -> CustomPicker

#Preview {
    CustomPicker(selection: .constant(Period.day), options: Period.allCases)
} // -> Preview

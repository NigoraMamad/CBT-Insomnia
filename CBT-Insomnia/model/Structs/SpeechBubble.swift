//
//  SpeechBubble.swift
//  CBT-Insomnia
//
//  Created by Brenda Elena Saucedo Gonzalez on 30/02/25.
//

import SwiftUI

struct SpeechBubble: Shape {
    
    var tailSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        // Left Upper Corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        
        // Upper Line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Right Line
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - tailSize))
        
        // Bottom Line (Half-Right)
        path.addLine(to: CGPoint(x: rect.maxX/2 + tailSize, y: rect.maxY - tailSize))
        
        // Diagonal Line (Up to Down)
        path.addLine(to: CGPoint(x: rect.maxX/2, y: rect.maxY))
        
        // Diagonal Line (Down to Up)
        path.addLine(to: CGPoint(x: rect.maxX/2 - tailSize, y: rect.maxY - tailSize))
        
        // Bottom Line (Half-Left)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - tailSize))
        
        // Left Line
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        
        path.closeSubpath()
        
        return path
        
    } // -> path
    
} // -> TicketShape

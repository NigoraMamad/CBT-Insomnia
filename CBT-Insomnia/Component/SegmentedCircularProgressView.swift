
import SwiftUI

struct SegmentData {
    let value: Double
    let gap: Double  
    let id = UUID()
}

struct SegmentedCircularProgressView: View {
    let segments: [SegmentData]
    let segmentColor: Color
    let backgroundCircleColor: Material
    let lineWidth: CGFloat
    let size: CGSize
    
    init(segments: [SegmentData],
         segmentColor: Color = .blue,
         backgroundCircleColor: Material = .ultraThinMaterial,
         lineWidth: CGFloat = 90,
         size: CGSize = CGSize(width: 200, height: 200)) {
        self.segments = segments
        self.segmentColor = segmentColor
        self.backgroundCircleColor = backgroundCircleColor
        self.lineWidth = lineWidth
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Background circle (always present)
            Circle()
                .stroke(backgroundCircleColor, lineWidth: lineWidth)
                .frame(width: size.width, height: size.height)
            
            // Dynamic segments with gaps - positioned exactly on top of background
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                Circle()
                    .trim(from: trimStart(for: index), to: trimEnd(for: index))
                    .stroke(segmentColor, style: StrokeStyle(lineWidth: lineWidth/1.3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: size.width, height: size.height)
            }
        }
    }
    
    private func trimStart(for index: Int) -> CGFloat {
        var totalOffset: Double = 0
        
        for i in 0..<index {
            totalOffset += segments[i].value + segments[i].gap
        }
        
        return CGFloat(totalOffset)
    }
    
    private func trimEnd(for index: Int) -> CGFloat {
        var totalOffset: Double = 0
        
        for i in 0..<index {
            totalOffset += segments[i].value + segments[i].gap
        }
        totalOffset += segments[index].value
        
        return CGFloat(totalOffset)
    }
}

struct SegmentArc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let lineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

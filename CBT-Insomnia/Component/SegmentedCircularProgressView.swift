
import SwiftUI

struct SegmentData {
    let value: Double
    let gap: Double  
    let id = UUID()
}

struct SegmentedCircularProgressView: View {
    let segments: [SegmentData]
    let segmentColor: Color
    let backgroundCircleColor: Color
    let lineWidth: CGFloat
    let size: CGSize
    
    init(segments: [SegmentData],
         segmentColor: Color = .blue,
         backgroundCircleColor: Color = Color.blue.opacity(0.3),
         lineWidth: CGFloat = 40,
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
                    .stroke(segmentColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
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

struct ContentView: View {
    var body: some View {
     
            
            SegmentedCircularProgressView(
                segments: [
                    SegmentData(value: 0.16, gap: 0.16),
                    SegmentData(value: 0.16, gap: 0.16),
                    SegmentData(value: 0.16, gap: 0.16)
                ],
                segmentColor: Color("csOrange"),
                backgroundCircleColor: Color("csOrange").opacity(0.4) ,
                lineWidth: 35,
                size: CGSize(width: 180, height: 180)
            )
    }
}


#Preview {
    ContentView()
}

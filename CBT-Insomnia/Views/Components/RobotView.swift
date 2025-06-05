//
//  RobotView.swift
//  BedAndSleepiOS
//
//  Created by Michele Coppola on 30/05/25.
//

import SwiftUI
import SplineRuntime

struct RobotView: View {
    var body: some View {
        // fetching from cloud
//        let url = URL(string: "https://build.spline.design/UCEi0z8BmCZ6SrFM6KwO/scene.splineswift")!

        // fetching from local
         let url = Bundle.main.url(forResource: "robot2", withExtension: "splineswift")!

        SplineView(sceneFileURL: url).ignoresSafeArea(.all)
            .frame(height: 200) 
    }
}

#Preview { 
    RobotView()
}

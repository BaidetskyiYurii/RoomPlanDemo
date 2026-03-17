//
//  WelcomeView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
                .imageScale(.large)
                .foregroundColor(.indigo)
                .padding(.bottom, 8)
            
            Text("RoomPlan 2D")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            Text("Scan your room and create a 2D floor plan.")
            
            Spacer()
                .frame(height: 50)
            
            NavigationLink("Start Scanning") {
                RoomCaptureScanView()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .fontWeight(.bold)
            
            
            NavigationLink("Try Demo") {
                RoomCaptureScanView(isDemo: true)
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .fontWeight(.bold)
        }
    }
}


#Preview {
    WelcomeView()
}

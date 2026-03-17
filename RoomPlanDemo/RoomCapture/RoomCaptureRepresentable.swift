//
//  RoomCaptureRepresentable.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import RoomPlan
import SwiftUI

struct RoomCaptureRepresentable: UIViewRepresentable {
    private let roomCaptureView: RoomCaptureView

    
    init(roomCaptureView: RoomCaptureView) {
        self.roomCaptureView = roomCaptureView
    }
    
    func makeUIView(context: Context) -> RoomCaptureView {
        return roomCaptureView
    }
    
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {
    }
}

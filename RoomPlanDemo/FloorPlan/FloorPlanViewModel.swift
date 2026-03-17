//
//  FloorPlanViewModel.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import Foundation
import RoomPlan

final class FloorPlanViewModel: ObservableObject {
    @Published var selectedSurface: FloorPlanSurface? = nil
    @Published var selectedObject: FloorPlanObject? = nil
    @Published var selectedAnnotation: FloorPlanAnnotation?
    @Published var selectedType: DetailsType?
    @Published var roomOptionType: RoomOptionType?
    @Published var furnitureToAdd: CapturedRoom.Object.Category?
    @Published var shouldAddFurniture: Bool = false
    @Published var shouldAddText: Bool = false
    @Published var shouldShareImage: Bool = false
    @Published var shareFormat: ImageFormat? = nil
}

//
//  MockDataManager.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 15.01.2025.
//

import Foundation
import RoomPlan

final class MockDataManager: ObservableObject {
    func loadCapturedRoom() -> CapturedRoom? {
        // Step 1: Locate the JSON file in the bundle
        guard let url = Bundle.main.url(forResource: "CapturedRoom", withExtension: "json") else {
            print("Error: CapturedRoom.json not found in the bundle.")
            return nil
        }
        
        // Step 2: Load the data from the JSON file
        do {
            let data = try Data(contentsOf: url)
            
            // Step 3: Decode the data into a CapturedRoom object
            let decoder = JSONDecoder()
            let capturedRoom = try decoder.decode(CapturedRoom.self, from: data)
            
            return capturedRoom
        } catch {
            print("Error decoding CapturedRoom.json: \(error.localizedDescription)")
            return nil
        }
    }
}

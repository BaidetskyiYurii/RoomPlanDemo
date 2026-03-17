//
//  RoomCaptureViewModel.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import Foundation
import RoomPlan
import UIKit

final class RoomCaptureViewModel: ObservableObject {
    // The capture view
    public let roomCaptureView: RoomCaptureView
    
    // Capture and room builder configuration
    private let captureSessionConfig: RoomCaptureSession.Configuration
    private let roomBuilder: RoomBuilder
    
    // The final scan result
    @Published var finalRoom: CapturedRoom?
    
    // Errors
    @Published var isShowError: Bool = false
    @Published var errorMessage: String = ""
    
    // states
    @Published var isScanning: Bool = false
    @Published var isShowingFloorPlan: Bool = false
    
    init() {
        roomCaptureView = RoomCaptureView(frame: .zero)
        captureSessionConfig = RoomCaptureSession.Configuration()
        roomBuilder = RoomBuilder(options: [.beautifyObjects])
        
        roomCaptureView.captureSession.delegate = self
    }
}

// MARK: Methods
extension RoomCaptureViewModel {
    // Start and stop the capture session. Available from our RoomCaptureScanView.
    func startSession() {
        isScanning = true
        roomCaptureView.captureSession.run(configuration: captureSessionConfig)
        
        // Prevent the screen from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopSession() {
        isScanning = false
        roomCaptureView.captureSession.stop()
        
        // Enable the screen to sleep again
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func handleScanButtonTap() {
        if isScanning {
            stopSession()
        } else {
            isShowingFloorPlan = true
        }
    }
    
    func getFinalRoom() -> CapturedRoom? {
        guard let finalRoom else {
            isShowError = true
            errorMessage = "No room capture available."
            return nil }
        
        return finalRoom
    }
    
    func shareCapturedRoom() {
        guard let finalRoom = finalRoom else {
            // Show an error if the room has not been captured yet
            isShowError = true
            errorMessage = "No room capture available to share."
            return
        }
        
        // Define the file URL for the `.usdz` export
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("CapturedRoom.usdz")
        
        do {
            // Export the captured room to the `.usdz` file
            try finalRoom.export(to: fileURL)
            print("CapturedRoom exported to: \(fileURL)")
            
            // Present the share sheet
            presentShareSheet(with: fileURL)
        } catch {
            // Handle errors during export
            isShowError = true
            errorMessage = "Failed to export the room as USDZ. Error: \(error.localizedDescription)"
            print("Error exporting CapturedRoom: \(error.localizedDescription)")
        }
    }
    
    func presentShareSheet(with fileURL: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Unable to find root view controller.")
            return
        }
        
        // Create a UIActivityViewController to share the file
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // Present the activity view controller
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: RoomCaptureSessionDelegate methods
extension RoomCaptureViewModel: RoomCaptureSessionDelegate {
    func captureSession(
        _ session: RoomCaptureSession,
        didEndWith data: CapturedRoomData,
        error: Error?
    ) {
        // Step 1: Handle errors
        if let error = error {
            handleCaptureError(error)
            return
        }
        
        // Step 2: Process the captured data
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let room = try await roomBuilder.capturedRoom(from: data)
                
                // Update the UI or state safely on the main thread
                await MainActor.run {
                    self.handleSuccessfulRoomCapture(room)
                }
            } catch {
                print("Error creating CapturedRoom: \(error.localizedDescription)")
                self.handleRoomProcessingError(error)
            }
        }
    }
}

// MARK: Private Methods
private extension RoomCaptureViewModel {
    // Helper to handle errors
    private func handleCaptureError(_ error: Error) {
        // For example, show an alert to the user or retry capture
        isShowError = true
        errorMessage = error.localizedDescription
        print("Capture session error: \(error.localizedDescription)")
    }
    
    private func handleRoomProcessingError(_ error: Error) {
        // Handle errors from processing the captured data
        isShowError = true
        errorMessage = error.localizedDescription
        print("Room processing error: \(error.localizedDescription)")
    }
    
    private func handleSuccessfulRoomCapture(_ room: CapturedRoom) {
        self.finalRoom = room
        // Optionally notify the user that the room capture succeeded
        print("Successfully captured room: \(room)")
    }
}

import AVFoundation
import Vision
import UIKit

class BarcodeScannerService: NSObject, ObservableObject {
    @Published var scannedCode: String?
    @Published var isScanning = false
    @Published var errorMessage: String?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    func checkCameraPermission() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    func setupCaptureSession() -> AVCaptureSession? {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            errorMessage = "Camera not available"
            return nil
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)

            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                errorMessage = "Could not add video input"
                return nil
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [
                    .ean8,
                    .ean13,
                    .upce,
                    .code128,
                    .code39,
                    .code93,
                    .qr
                ]
            } else {
                errorMessage = "Could not add metadata output"
                return nil
            }

            captureSession = session
            return session
        } catch {
            errorMessage = "Camera setup error: \(error.localizedDescription)"
            return nil
        }
    }

    func startScanning() {
        guard let session = captureSession else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            if !session.isRunning {
                session.startRunning()
                DispatchQueue.main.async {
                    self.isScanning = true
                }
            }
        }
    }

    func stopScanning() {
        guard let session = captureSession else { return }

        DispatchQueue.global(qos: .userInitiated).async {
            if session.isRunning {
                session.stopRunning()
                DispatchQueue.main.async {
                    self.isScanning = false
                }
            }
        }
    }

    func resetScannedCode() {
        scannedCode = nil
    }
}

extension BarcodeScannerService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        scannedCode = stringValue
        stopScanning()
    }
}

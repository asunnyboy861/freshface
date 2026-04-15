import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scannerService = BarcodeScannerService()
    @State private var hasPermission = false
    @State private var showPermissionAlert = false

    let onBarcodeScanned: (String) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                if hasPermission {
                    cameraView
                } else {
                    permissionView
                }
            }
            .navigationTitle("Scan Barcode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                checkPermission()
            }
            .onDisappear {
                scannerService.stopScanning()
            }
            .alert("Camera Access Required", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("FreshFace needs camera access to scan product barcodes. Please enable camera access in Settings.")
            }
            .onChange(of: scannerService.scannedCode) { _, newValue in
                if let code = newValue {
                    onBarcodeScanned(code)
                    dismiss()
                }
            }
        }
    }

    private var cameraView: some View {
        ZStack {
            CameraPreviewView(session: scannerService.setupCaptureSession())
                .ignoresSafeArea()

            scannerOverlay

            VStack {
                Spacer()
                manualEntryButton
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            scannerService.startScanning()
        }
    }

    private var scannerOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 3, dash: [10])
                )
                .frame(width: 280, height: 180)
                .background(Color.clear)

            VStack(spacing: 16) {
                Image(systemName: "barcode.viewfinder")
                    .font(.system(size: 48))
                    .foregroundColor(.white)

                Text("Position barcode within frame")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }

    private var permissionView: some View {
        VStack(spacing: 24) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "FF6B9D"))

            Text("Camera Access Needed")
                .font(.title2.bold())

            Text("To scan product barcodes, FreshFace needs access to your camera.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: requestPermission) {
                Text("Enable Camera")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "FF6B9D"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
    }

    private var manualEntryButton: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "keyboard")
                Text("Enter Manually")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.6))
            .cornerRadius(12)
        }
    }

    private func checkPermission() {
        Task {
            hasPermission = await scannerService.checkCameraPermission()
            if !hasPermission {
                showPermissionAlert = true
            }
        }
    }

    private func requestPermission() {
        Task {
            hasPermission = await scannerService.checkCameraPermission()
            if hasPermission {
                scannerService.startScanning()
            } else {
                showPermissionAlert = true
            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession?

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        if let session = session {
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = UIScreen.main.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = UIScreen.main.bounds
        }
    }
}

#Preview {
    BarcodeScannerView { barcode in
        print("Scanned: \(barcode)")
    }
}

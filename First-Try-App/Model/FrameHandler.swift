//
//  FrameHandler.swift
//  First-Try-App
//
//  Created by Max Young on 11/3/23.
//

import AVFoundation
import CoreImage

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    
    override init() {
        super.init()
        self.checkPermission()
        sessionQueue.async { [unowned self] in
            self.setUpCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // user has previously granted access to the camera
            permissionGranted = true
        case .notDetermined: // user has not yet been asked for camera access
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        // strong reference here not a problem but might become one
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    func setUpCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        // all ui updates should/need to be performed on the main queue
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
        
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}

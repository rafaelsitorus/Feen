//
//  FeenCameraController.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//


#if canImport(UIKit)
import UIKit
import AVFoundation

final class FeenCameraController: UIViewController {
    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let previewLayer = AVCaptureVideoPreviewLayer()

    private let model: CameraModel

    init(model: CameraModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        previewLayer.session = session
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        checkPermissionAndConfigure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    private func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                if granted { self.configureSession() }
            }
        default:
            break
        }
    }

    private func configureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            do {
                guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
                let input = try AVCaptureDeviceInput(device: device)
                if self.session.canAddInput(input) { self.session.addInput(input) }
                if self.session.canAddOutput(self.photoOutput) { self.session.addOutput(self.photoOutput) }
                self.photoOutput.isHighResolutionCaptureEnabled = true
            } catch {
                print("Camera configuration error: \(error)")
            }
            self.session.commitConfiguration()
            self.startSession()
        }
    }

    private func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning { self.session.startRunning() }
        }
    }

    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning { self.session.stopRunning() }
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension FeenCameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error { print("Capture error: \(error)"); return }
        guard let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        DispatchQueue.main.async { self.model.capturedImage = image }
    }
}

extension FeenCameraController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCapture), name: .init("CameraCaptureRequest"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .init("CameraCaptureRequest"), object: nil)
    }
    @objc private func handleCapture() { capturePhoto() }
}
#endif

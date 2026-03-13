//
//  CameraScreen.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import SwiftUI

#if canImport(UIKit)
struct CameraControllerRepresentable: UIViewControllerRepresentable {
    @ObservedObject var model: CameraModel
    func makeUIViewController(context: Context) -> FeenCameraController { FeenCameraController(model: model) }
    func updateUIViewController(_ uiViewController: FeenCameraController, context: Context) {}
}
#endif

struct CameraScreen: View {
    @StateObject var model = CameraModel()

    var body: some View {
        NavigationStack {
            ZStack {
                #if canImport(UIKit)
                CameraControllerRepresentable(model: model)
                    .ignoresSafeArea()
                #else
                Text("Camera is not supported on this platform.")
                #endif

                VStack {
                    Spacer()

                    // Capture button
                    Button {
                        NotificationCenter.default.post(name: .init("CameraCaptureRequest"), object: nil)
                    } label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 72, height: 72)
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 3)
                                    .frame(width: 62, height: 62)
                            )
                    }
                    .padding(.bottom, 40)
                }
            }
            .sheet(isPresented: Binding(
                get: { model.capturedImage != nil && model.analysis == nil },
                set: { if !$0 { model.capturedImage = nil } }
            )) {
                WagePromptSheet(model: model)
            }
            .sheet(isPresented: Binding(
                get: { model.analysis != nil },
                set: { if !$0 { model.analysis = nil; model.capturedImage = nil } }
            )) {
                AnalysisScreen(analysis: model.analysis!, onDismiss: {
                    model.analysis = nil
                    model.capturedImage = nil
                })
            }
        }
    }
}

// MARK: – Wage Input Sheet

struct WagePromptSheet: View {
    @ObservedObject var model: CameraModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                #if canImport(UIKit)
                if let image = model.capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                #endif

                Text("Enter your monthly wage")
                    .font(.headline)

                TextField("e.g. 5000000", text: $model.monthlyWage)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                if model.isAnalyzing {
                    ProgressView("Analyzing invoice…")
                }

                if let error = model.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                Button {
                    model.analyzeInvoice()
                } label: {
                    Text("Analyze Invoice")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(model.isAnalyzing)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 24)
            .navigationTitle("Invoice Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        model.capturedImage = nil
                        dismiss()
                    }
                }
            }
        }
    }
}

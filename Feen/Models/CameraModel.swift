//
//  CameraModel.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import Foundation
import Combine
#if canImport(UIKit)
import UIKit
#endif

final class CameraModel: NSObject, ObservableObject {
    #if canImport(UIKit)
    @Published var capturedImage: UIImage?
    #else
    @Published var capturedImageData: Data?
    #endif

    @Published var isAnalyzing = false
    @Published var analysis: InvoiceAnalysis?
    @Published var errorMessage: String?
    @Published var monthlyWage: String = ""
    @Published var showWagePrompt = false

    #if canImport(UIKit)
    func analyzeInvoice() {
        guard let image = capturedImage,
              let wage = Double(monthlyWage), wage > 0 else {
            errorMessage = "Please enter a valid monthly wage."
            return
        }
        isAnalyzing = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let result = try await GeminiService.shared.analyzeInvoice(image: image, monthlyWage: wage)
                self.analysis = result
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isAnalyzing = false
        }
    }
    #endif
}

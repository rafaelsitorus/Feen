//
//  SplashScreen.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct SplashScreen: View {
    // Animation states
        @State private var isActive = false
        @State private var scaleEffect = 0.6
        @State private var opacity = 0.0
        
        var body: some View {
            if isActive {
                // Show main content after splash
                HistoryView()
            } else {
                // Splash content
                VStack {
                    Spacer()
                    // Application logo (change later)
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .scaleEffect(scaleEffect)
                        .opacity(opacity)
                        .foregroundColor(.green)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .onAppear {
                    // Animate scale and opacity in
                    withAnimation(.easeIn(duration: 1.0)) {
                        scaleEffect = 1.0
                        opacity = 1.0
                    }
                    // After 1.5 seconds, switch to main content
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 1.0)) {
                            isActive = true
                        }
                    }
                }
            }
        }}

#Preview {
    SplashScreen()
}

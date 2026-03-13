import SwiftUI

struct NumpadView: View {
    @Binding var displayValue: String

    let buttons: [[String]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { key in
                        Button(action: { handleInput(key) }) {
                            Text(key)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func handleInput(_ key: String) {
        switch key {
        case "⌫":
            if !displayValue.isEmpty {
                displayValue.removeLast()
            }
        case "":
            if !displayValue.contains("") {
                displayValue += ""
            }
        default:
            // Batasi 10 digit
            if displayValue.count < 10 {
                if displayValue == "0"{
                    displayValue = key
                }
                else {
                    displayValue += key
                }
            }
        }
    }
}

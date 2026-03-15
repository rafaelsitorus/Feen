import SwiftUI

struct NumpadView: View {
    @Binding var displayValue: String
    var onDismiss: (() -> Void)? = nil

    let buttons: [[String]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        ["", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top bar with done button
            HStack {
                Spacer()
                Button("Done") {
                    onDismiss?()
                }
                .font(.subheadline.bold())
                .foregroundColor(.accentColor)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 4)
            }

            // Keys
            VStack(spacing: 8) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row, id: \.self) { key in
                            Button(action: { handleInput(key) }) {
                                Group {
                                    if key == "⌫" {
                                        Image(systemName: "delete.left")
                                            .font(.system(size: 18, weight: .medium))
                                    } else {
                                        Text(key)
                                            .font(.title2.bold())
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(
                                    key == "⌫"
                                    ? Color(.systemGray5)
                                    : Color(.systemGray6)
                                )
                                .cornerRadius(10)
                            }
                            .foregroundColor(key.isEmpty ? .clear : .primary)
                            .disabled(key.isEmpty)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }

    private func handleInput(_ key: String) {
        switch key {
        case "⌫":
            if displayValue.count > 1 {
                displayValue.removeLast()
            } else {
                displayValue = "0"
            }
        case "":
            break
        default:
            if displayValue == "0" {
                displayValue = key
            } else if displayValue.count < 10 {
                displayValue += key
            }
        }
    }
}

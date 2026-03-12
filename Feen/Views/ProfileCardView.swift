import SwiftUI

struct ProfileCardView: View {
    let avatarInitial: String
    let displayName: String
    let displaySourceOfIncome: String
    let formattedIncome: String
    let onEditTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.tealGradient)

            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 160, height: 160)
                .offset(x: 120, y: -40)
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 100, height: 100)
                .offset(x: 140, y: 40)

            HStack(spacing: 16) {
                avatarView
                infoView
                Spacer()
                editButton
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
        .shadow(color: AppTheme.darkTeal.opacity(0.3), radius: 12, x: 0, y: 6)
    }

    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 64, height: 64)
            Text(avatarInitial)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
        }
    }

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(displayName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(displaySourceOfIncome)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.75))
            Text("\(formattedIncome) / month")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 2)
        }
    }

    private var editButton: some View {
        Button(action: onEditTap) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 36, height: 36)
                Image(systemName: "pencil")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }
}

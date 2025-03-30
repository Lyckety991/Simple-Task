//
//  CustomAlertView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 30.03.25.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var onSettings: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)

            Text(message)
                .multilineTextAlignment(.center)
                .font(.subheadline)

            HStack {
                Button("Abbrechen") {
                    onDismiss()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button("Einstellungen öffnen") {
                    onSettings()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        CustomAlertView(
            title: "Benachrichtigungen deaktiviert",
            message: "Du hast die Benachrichtigungen für diese App deaktiviert. Du kannst sie in den iOS-Einstellungen wieder aktivieren.",
            onSettings: {
                print("🔧 Einstellungen öffnen")
            },
            onDismiss: {
                print("❌ Abgebrochen")
            }
        )
    }
}


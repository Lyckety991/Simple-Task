//
//  SettingsView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 29.03.25.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    @Environment(\.dismiss) private var dismiss
    

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Darstellung
                Section("Darstellung") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                scene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                            }
                        }
                }

                // MARK: - Benachrichtigungen
                Section("Benachrichtigungen") {
                    Toggle("Benachrichtigungen aktivieren", isOn: $notificationsEnabled)
                    
                    if !notificationsEnabled {
                        Text("Erinnerungen werden aktuell nicht geplant.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                   

                }

                // MARK: - Feedback
                Section("Feedback") {
                    Button("🐞 Fehler melden") {
                        let mailto = "mailto:dein@email.de?subject=Bug%20in%20SimpleTask&body=Beschreibe%20den%20Fehler%20hier..."
                        if let url = URL(string: mailto) {
                            UIApplication.shared.open(url)
                        }
                    }
                }

                // MARK: - App-Info
                Section("App") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
           
        }
       

    }
}

#Preview {
    SettingsView()
}

//
//  SettingsView.swift
//  Simple-Task
//
//  Created by Patrick Lanham on 29.03.25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    @State private var showMailSheet = false
    @State private var showSettingsAlert = false
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Darstellung") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                }
                
                Section("Benachrichtigungen") {
                    Toggle("Benachrichtigungen aktivieren", isOn: $notificationsEnabled)
                    
                    if !notificationsEnabled {
                        Text("Erinnerungen werden aktuell nicht geplant.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Berechtigung erneut anfragen") {
                        UNUserNotificationCenter.current().getNotificationSettings { settings in
                            if settings.authorizationStatus == .denied {
                                DispatchQueue.main.async {
                                    showSettingsAlert = true
                                }
                            } else {
                                NotificationManager.shared.requestAuthorization()
                            }
                        }
                    }

                   
                    
                    
                }
                    
                    Section("Feedback") {
                        Button("🐞 Fehler melden") {
                            let mailto = "mailto:dein@email.de?subject=Bug%20in%20SimpleTask&body=Beschreibe%20den%20Fehler%20hier..."
                            if let url = URL(string: mailto) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    
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
            }
        .alert("Benachrichtigungen deaktiviert", isPresented: $showSettingsAlert) {
            Button("Einstellungen öffnen") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Abbrechen", role: .cancel) { }
        } message: {
            Text("Du hast Benachrichtigungen deaktiviert. Du kannst sie in den iOS-Einstellungen wieder aktivieren.")
        }
        }
    }


#Preview {
    SettingsView()
}

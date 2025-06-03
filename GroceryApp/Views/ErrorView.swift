//
//  ErrorView.swift
//  GroceryApp
//
//  Created by Assistant on 03.06.25.
//

import SwiftUI

struct ErrorView: View {
    let title: String
    let message: String
    let systemImage: String
    let primaryAction: ErrorAction?
    let secondaryAction: ErrorAction?
    
    init(
        title: String = "Fehler aufgetreten",
        message: String,
        systemImage: String = "exclamationmark.triangle",
        primaryAction: ErrorAction? = nil,
        secondaryAction: ErrorAction? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Error Icon with animated background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.red.opacity(0.1), Color.orange.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: systemImage)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.red, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: true)
            }
            
            // Error Content
            VStack(spacing: 12) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 8)
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                if let primaryAction = primaryAction {
                    Button(action: primaryAction.action) {
                        HStack {
                            if let icon = primaryAction.icon {
                                Image(systemName: icon)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            Text(primaryAction.title)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(PressedButtonStyle())
                }
                
                if let secondaryAction = secondaryAction {
                    Button(action: secondaryAction.action) {
                        HStack {
                            if let icon = secondaryAction.icon {
                                Image(systemName: icon)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            Text(secondaryAction.title)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PressedButtonStyle())
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Supporting Types

struct ErrorAction {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
}

// MARK: - Button Style

struct PressedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Convenience Initializers

extension ErrorView {
    // Network Error
    static func networkError(
        message: String = "Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.",
        retryAction: @escaping () -> Void,
        dismissAction: (() -> Void)? = nil
    ) -> ErrorView {
        ErrorView(
            title: "Verbindungsfehler",
            message: message,
            systemImage: "wifi.slash",
            primaryAction: ErrorAction(title: "Erneut versuchen", icon: "arrow.clockwise", action: retryAction),
            secondaryAction: dismissAction != nil ? ErrorAction(title: "Abbrechen", action: dismissAction!) : nil
        )
    }
    
    // Server Error
    static func serverError(
        message: String = "Der Server ist momentan nicht erreichbar. Bitte versuchen Sie es später erneut.",
        retryAction: @escaping () -> Void,
        dismissAction: (() -> Void)? = nil
    ) -> ErrorView {
        ErrorView(
            title: "Server Fehler",
            message: message,
            systemImage: "server.rack",
            primaryAction: ErrorAction(title: "Erneut versuchen", icon: "arrow.clockwise", action: retryAction),
            secondaryAction: dismissAction != nil ? ErrorAction(title: "Abbrechen", action: dismissAction!) : nil
        )
    }
    
    // Validation Error
    static func validationError(
        message: String,
        dismissAction: @escaping () -> Void
    ) -> ErrorView {
        ErrorView(
            title: "Eingabefehler",
            message: message,
            systemImage: "checkmark.circle.trianglebadge.exclamationmark",
            primaryAction: ErrorAction(title: "OK", action: dismissAction)
        )
    }
    
    // Authentication Error
    static func authenticationError(
        message: String = "Ihre Sitzung ist abgelaufen. Bitte melden Sie sich erneut an.",
        loginAction: @escaping () -> Void,
        dismissAction: (() -> Void)? = nil
    ) -> ErrorView {
        ErrorView(
            title: "Anmeldung erforderlich",
            message: message,
            systemImage: "person.crop.circle.badge.exclamationmark",
            primaryAction: ErrorAction(title: "Anmelden", icon: "person.circle", action: loginAction),
            secondaryAction: dismissAction != nil ? ErrorAction(title: "Später", action: dismissAction!) : nil
        )
    }
}

// MARK: - Preview

#Preview("Network Error") {
    VStack {
        ErrorView.networkError(retryAction: {
            print("Retry tapped")
        }, dismissAction: {
            print("Dismiss tapped")
        })
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
}

#Preview("Server Error") {
    VStack {
        ErrorView.serverError(retryAction: {
            print("Retry tapped")
        })
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
}

#Preview("Validation Error") {
    VStack {
        ErrorView.validationError(
            message: "Benutzername darf nicht leer sein und muss mindestens 3 Zeichen enthalten.",
            dismissAction: {
                print("OK tapped")
            }
        )
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
}

#Preview("Custom Error") {
    VStack {
        ErrorView(
            title: "Kategorie nicht gefunden",
            message: "Die ausgewählte Kategorie konnte nicht geladen werden. Möglicherweise wurde sie bereits gelöscht.",
            systemImage: "folder.badge.questionmark",
            primaryAction: ErrorAction(title: "Kategorien aktualisieren", icon: "arrow.clockwise") {
                print("Refresh categories")
            },
            secondaryAction: ErrorAction(title: "Zurück", icon: "chevron.left") {
                print("Go back")
            }
        )
        
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGroupedBackground))
}

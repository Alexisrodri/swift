import SwiftUI

// MARK: - Error View
struct ErrorView: View {
    let errorMessage: String?
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "wifi.slash")
                .font(.system(size: 60))
                .foregroundColor(.red.opacity(0.7))
            
            VStack(spacing: 8) {
                Text("¡Ups! Algo salió mal")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(errorMessage ?? "Error desconocido")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 12) {
                Button("Reintentar") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("Verificar conexión") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            
            Spacer()
        }
        .padding()
    }
}

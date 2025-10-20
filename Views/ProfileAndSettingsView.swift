import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    @State private var userName = "Usuario"
    @State private var userEmail = "usuario@example.com"
    @State private var favoriteMovies: [Movie] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.6),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header del perfil
                        VStack(spacing: 16) {
                            // Avatar
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 8) {
                                Text(userName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 40)
                        
                        // Estadísticas
                        HStack(spacing: 20) {
                            VStack {
                                Text("\(favoriteMovies.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Películas Favoritas")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("0")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Reseñas")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("0")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Listas")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        // Secciones del perfil
                        VStack(spacing: 16) {
                            ProfileSectionButton(
                                icon: "heart.fill",
                                title: "Mis Favoritas",
                                subtitle: "Películas que me gustan"
                            ) {
                                // Acción para favoritas
                            }
                            
                            ProfileSectionButton(
                                icon: "list.bullet",
                                title: "Mis Listas",
                                subtitle: "Listas personalizadas"
                            ) {
                                // Acción para listas
                            }
                            
                            ProfileSectionButton(
                                icon: "star.fill",
                                title: "Mis Reseñas",
                                subtitle: "Opiniones sobre películas"
                            ) {
                                // Acción para reseñas
                            }
                            
                            ProfileSectionButton(
                                icon: "clock.fill",
                                title: "Historial",
                                subtitle: "Películas vistas recientemente"
                            ) {
                                // Acción para historial
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Profile Section Button
struct ProfileSectionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @State private var isDarkMode = true
    @State private var notificationsEnabled = true
    @State private var language = "Español"
    @State private var showAbout = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.6),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            
                            Text("Configuración")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 40)
                        
                        // Secciones de configuración
                        VStack(spacing: 16) {
                            // Apariencia
                            SettingsSection(title: "Apariencia") {
                                SettingsToggleRow(
                                    icon: "moon.fill",
                                    title: "Modo Oscuro",
                                    subtitle: "Tema oscuro para mejor experiencia",
                                    isOn: $isDarkMode
                                )
                            }
                            
                            // Notificaciones
                            SettingsSection(title: "Notificaciones") {
                                SettingsToggleRow(
                                    icon: "bell.fill",
                                    title: "Notificaciones",
                                    subtitle: "Recibir notificaciones de nuevas películas",
                                    isOn: $notificationsEnabled
                                )
                            }
                            
                            // Idioma
                            SettingsSection(title: "Idioma") {
                                SettingsNavigationRow(
                                    icon: "globe",
                                    title: "Idioma",
                                    subtitle: language,
                                    action: {
                                        // Acción para cambiar idioma
                                    }
                                )
                            }
                            
                            // Información
                            SettingsSection(title: "Información") {
                                SettingsNavigationRow(
                                    icon: "info.circle.fill",
                                    title: "Acerca de",
                                    subtitle: "Versión 1.0.0",
                                    action: {
                                        showAbout = true
                                    }
                                )
                                
                                SettingsNavigationRow(
                                    icon: "questionmark.circle.fill",
                                    title: "Ayuda",
                                    subtitle: "Centro de ayuda y soporte",
                                    action: {
                                        // Acción para ayuda
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Settings Toggle Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding()
    }
}

// MARK: - Settings Navigation Row
struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Logo/Icono
                Image(systemName: "film")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("MoviesApp")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Versión 1.0.0")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Una aplicación de películas desarrollada con SwiftUI y TheMovieDB API")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("© 2024 MoviesApp. Todos los derechos reservados.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Acerca de")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

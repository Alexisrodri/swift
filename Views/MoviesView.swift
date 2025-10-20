import SwiftUI

// MARK: - Hero Carousel View
struct HeroCarouselView: View {
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    
    var body: some View {
        TabView {
            ForEach(movies.prefix(5)) { movie in
                AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                    Text("Error al cargar imagen")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.5)
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                }
                .frame(height: 250)
                .clipped()
                .cornerRadius(16)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(16)
                )
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .shadow(color: .black, radius: 2)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", movie.voteAverage))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                        .shadow(color: .black, radius: 2)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                )
                .overlay(
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        Color.clear
                    }
                )
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .padding(.horizontal, 16)
    }
}

// MARK: - Horizontal Movies Section
struct HorizontalMoviesSection: View {
    let title: String
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    let onLoadMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header de la sección
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Ver más") {
                    onLoadMore()
                }
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            
            // Carrusel horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCardHorizontal(movie: movie) {
                                // Tap manejado por NavigationLink
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            if movie.id == movies.last?.id {
                                onLoadMore()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Main Home View
struct HomeView: View {
    @StateObject private var nowPlayingViewModel = MovieViewModel()
    @StateObject private var upcomingViewModel = MovieViewModel()
    @StateObject private var topRatedViewModel = MovieViewModel()
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo blanco
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // App Bar
                    HStack {
                        Text("MoviesApp")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    // Contenido principal
                    if nowPlayingViewModel.hasError && nowPlayingViewModel.movies.isEmpty {
                        // Vista de error principal
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
                                
                                Text(nowPlayingViewModel.errorMessage ?? "Error desconocido")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            VStack(spacing: 12) {
                                Button("Reintentar") {
                                    nowPlayingViewModel.retry(category: .nowPlaying)
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
                    } else {
                        ScrollView {
                            VStack(spacing: 24) {
                                // Hero Carousel
                                if !nowPlayingViewModel.movies.isEmpty {
                                    HeroCarouselView(
                                        movies: nowPlayingViewModel.movies,
                                        onMovieTap: { movie in
                                            // NavigationLink se manejará en el componente
                                        }
                                    )
                                }
                            
                            // Sección En Cartelera
                            HorizontalMoviesSection(
                                title: "En Cartelera",
                                movies: nowPlayingViewModel.movies,
                                onMovieTap: { movie in
                                    // NavigationLink se manejará en el componente
                                },
                                onLoadMore: {
                                    nowPlayingViewModel.loadMoreMovies(category: .nowPlaying)
                                }
                            )
                            
                            // Sección Próximamente
                            HorizontalMoviesSection(
                                title: "Próximamente",
                                movies: upcomingViewModel.movies,
                                onMovieTap: { movie in
                                    // NavigationLink se manejará en el componente
                                },
                                onLoadMore: {
                                    upcomingViewModel.loadMoreMovies(category: .upcoming)
                                }
                            )
                            
                            // Sección Mejor Valoradas
                            HorizontalMoviesSection(
                                title: "Mejor Valoradas",
                                movies: topRatedViewModel.movies,
                                onMovieTap: { movie in
                                    // NavigationLink se manejará en el componente
                                },
                                onLoadMore: {
                                    topRatedViewModel.loadMoreMovies(category: .topRated)
                                }
                            )
                            
                            // Espacio para el bottom navigation
                            Spacer(minLength: 100)
                        }
                    }
                    }
                }
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    BottomNavigationView(selectedTab: $selectedTab)
                        .background(Color.black.opacity(0.9))
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                nowPlayingViewModel.loadMovies(category: .nowPlaying)
                upcomingViewModel.loadMovies(category: .upcoming)
                topRatedViewModel.loadMovies(category: .topRated)
            }
        }
    }
}

// MARK: - Bottom Navigation View
struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            // Tab Inicio
            Button(action: { selectedTab = 0 }) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.title3)
                    Text("Inicio")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 0 ? .blue : .gray)
            }
            
            Spacer()
            
            // Tab Perfil
            Button(action: { selectedTab = 1 }) {
                VStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.title3)
                    Text("Perfil")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .blue : .gray)
            }
            
            Spacer()
            
            // Tab Configuración
            Button(action: { selectedTab = 2 }) {
                VStack(spacing: 4) {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                    Text("Config")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 2 ? .blue : .gray)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Main Movies View (Actualizada)
struct MoviesView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                ProfileView()
            case 2:
                SettingsView()
            default:
                HomeView()
            }
        }
    }
}
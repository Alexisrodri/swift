import SwiftUI

// MARK: - Hero Carousel View
struct HeroCarouselView: View {
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    
    var body: some View {
        TabView {
            ForEach(movies.prefix(5)) { movie in
                AsyncImage(url: URL(string: movie.backdropURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 300)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
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
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", movie.voteAverage))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                )
                .onTapGesture {
                    onMovieTap(movie)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 300)
        .cornerRadius(0)
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
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("Ver más") {
                    onLoadMore()
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            
            // Carrusel horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        MovieCardHorizontal(movie: movie) {
                            onMovieTap(movie)
                        }
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
    
    @State private var selectedMovie: Movie?
    @State private var showingMovieDetail = false
    @State private var selectedTab = 0
    
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
                
                VStack(spacing: 0) {
                    // App Bar
                    HStack {
                        HStack {
                            Image(systemName: "film")
                                .foregroundColor(.white)
                            Text("MoviesApp")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    // Contenido principal
                    ScrollView {
                        VStack(spacing: 24) {
                            // Hero Carousel
                            if !nowPlayingViewModel.movies.isEmpty {
                                HeroCarouselView(
                                    movies: nowPlayingViewModel.movies,
                                    onMovieTap: { movie in
                                        selectedMovie = movie
                                        showingMovieDetail = true
                                    }
                                )
                            }
                            
                            // Sección En Cartelera
                            HorizontalMoviesSection(
                                title: "En Cartelera",
                                movies: nowPlayingViewModel.movies,
                                onMovieTap: { movie in
                                    selectedMovie = movie
                                    showingMovieDetail = true
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
                                    selectedMovie = movie
                                    showingMovieDetail = true
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
                                    selectedMovie = movie
                                    showingMovieDetail = true
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
            .sheet(isPresented: $showingMovieDetail) {
                if let movie = selectedMovie {
                    MovieDetailView(movie: movie)
                }
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
import SwiftUI

// MARK: - Vertical Movies List View
struct VerticalMoviesListView: View {
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    let onLoadMore: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(movies) { movie in
                    MovieCardVertical(movie: movie) {
                        onMovieTap(movie)
                    }
                    .onAppear {
                        // Cargar más películas cuando llegamos al final
                        if movie.id == movies.last?.id {
                            onLoadMore()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
}

// MARK: - Category Movies View
struct CategoryMoviesView: View {
    let category: MovieCategory
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedMovie: Movie?
    @State private var showingMovieDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Título de la categoría
            HStack {
                Text(category.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            
            // Content
            if viewModel.isLoading && viewModel.movies.isEmpty {
                Spacer()
                ProgressView("Cargando películas...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Reintentar") {
                        viewModel.refreshMovies(category: category)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                Spacer()
            } else {
                // Movies List Vertical
                VerticalMoviesListView(
                    movies: viewModel.movies,
                    onMovieTap: { movie in
                        selectedMovie = movie
                        showingMovieDetail = true
                    },
                    onLoadMore: {
                        viewModel.loadMoreMovies(category: category)
                    }
                )
                
                if viewModel.isLoading {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Cargando más películas...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.loadMovies(category: category)
        }
        .sheet(isPresented: $showingMovieDetail) {
            if let movie = selectedMovie {
                MovieDetailView(movie: movie)
            }
        }
    }
}

// MARK: - Main Movies View
struct MoviesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // App Bar
                MoviesAppBar()
                
                // Tab View con las 3 categorías
                TabView {
                    CategoryMoviesView(category: .nowPlaying)
                        .tabItem {
                            Image(systemName: "play.circle")
                            Text("En Cartelera")
                        }
                    
                    CategoryMoviesView(category: .upcoming)
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Próximamente")
                        }
                    
                    CategoryMoviesView(category: .topRated)
                        .tabItem {
                            Image(systemName: "star.fill")
                            Text("Mejor Valoradas")
                        }
                }
                .accentColor(.blue)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Movies View Preview
struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
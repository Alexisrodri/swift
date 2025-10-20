import SwiftUI

// MARK: - Movies Carousel View
struct MoviesCarouselView: View {
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    let onLoadMore: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(movies) { movie in
                    MovieCard(movie: movie) {
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
        }
    }
}

// MARK: - Main Movies View
struct MoviesView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedCategory: MovieCategory = .nowPlaying
    @State private var selectedMovie: Movie?
    @State private var showingMovieDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // App Bar
                MoviesAppBar()
                
                // Category Picker
                Picker("Categoría", selection: $selectedCategory) {
                    ForEach(MovieCategory.allCases, id: \.self) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .onChange(of: selectedCategory) { newCategory in
                    viewModel.refreshMovies(category: newCategory)
                }
                
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
                            viewModel.refreshMovies(category: selectedCategory)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                } else {
                    // Movies Carousel
                    MoviesCarouselView(
                        movies: viewModel.movies,
                        onMovieTap: { movie in
                            selectedMovie = movie
                            showingMovieDetail = true
                        },
                        onLoadMore: {
                            viewModel.loadMoreMovies(category: selectedCategory)
                        }
                    )
                    .frame(height: 280)
                    
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
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.loadMovies(category: selectedCategory)
            }
            .sheet(isPresented: $showingMovieDetail) {
                if let movie = selectedMovie {
                    MovieDetailView(movie: movie)
                }
            }
        }
    }
}

// MARK: - Movies View Preview
struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}

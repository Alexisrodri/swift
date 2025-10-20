import SwiftUI

// MARK: - Custom App Bar
struct MoviesAppBar: View {
    var body: some View {
        HStack {
            Text("MoviesApp")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

// MARK: - App Bar Preview
struct MoviesAppBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MoviesAppBar()
            Spacer()
        }
        .previewLayout(.sizeThatFits)
    }
}

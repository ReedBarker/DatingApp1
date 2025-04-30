import SwiftUI

struct ProfilePictureView: View {
    let urlString: String

    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: URL(string: urlString)) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: proxy.size.width)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.width)
                .clipped()
                .cornerRadius(12)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(urlString: "https://example.com/profile.jpg")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

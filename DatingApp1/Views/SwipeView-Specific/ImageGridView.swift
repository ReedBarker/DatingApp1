import SwiftUI

struct ImageGridView: View {
    let urls: [String]
        let columns: Int
        private let spacing: CGFloat = 0
        
        init(urls: [String], columns: Int = 2) {
            self.urls = urls
            self.columns = columns
        }

    var body: some View {
        // match your VStack(.padding()) in UserView:
        let totalPadding: CGFloat = 16 * 2
        let screenWidth = UIScreen.main.bounds.width - totalPadding
        let totalSpacing = spacing * CGFloat(columns - 1)
        let colWidth = (screenWidth - totalSpacing) / CGFloat(columns)

        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { col in
                LazyVStack(spacing: spacing) {
                    ForEach(items(in: col), id: \.self) { urlString in
                        AsyncImage(url: URL(string: urlString)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: colWidth, height: colWidth)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: colWidth-8)
                                    .clipped()
                                    .padding(4)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: colWidth, height: colWidth)
                                    .foregroundColor(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
        // allow the grid to size itself vertically
        .fixedSize(horizontal: false, vertical: true)
    }

    private func items(in column: Int) -> [String] {
        urls.enumerated()
            .filter { $0.offset % columns == column }
            .map { $0.element }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static let puppyURLs = [
        "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fimages4.fanpop.com%2Fimage%2Fphotos%2F22000000%2FCute-Puppies-puppies-22040946-1280-800.jpg&f=1&nofb=1&ipt=ed9cadb6ffbc80c5041b437e274bc36a3ca68d9c727b6460bd25f8ead9e44147",
        "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.iheartteacups.com%2Fwp-content%2Fuploads%2F2017%2F01%2FFullSizeRender-4.jpg&f=1&nofb=1&ipt=defadc0b9bdf8e0816c0442be7cb6a2e374ce19439357e6631a3b891dde26792",
        "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fteacupspuppies.com%2Fwp-content%2Fuploads%2F2017%2F03%2Fyorkie-puppy-for-sale-056.jpg&f=1&nofb=1&ipt=27ce7e91b2b40eeb5b1a9d952855bc94d33ccff734d26e0c5ff7e2913c66bb04",
        "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2F1.bp.blogspot.com%2F-yN5dW-B9ius%2FTxICYmlglHI%2FAAAAAAAAAUk%2F513k7HdDDF8%2Fs1600%2FCute_Funny_Puppies_Looking_Around_HD_Wallpaper-Vvallpaper.Net.jpg&f=1&nofb=1&ipt=1e948131ada53d50d0510bd49c45a475c496561797d57334d5f3937d81a46659"
    ]

    static var previews: some View {
        // embed in a ScrollView to preview full vertical layout
        ScrollView {
            ImageGridView(urls: puppyURLs)
        }
        .padding()
    }
}

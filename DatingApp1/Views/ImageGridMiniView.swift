import SwiftUI

struct ImageGridMiniView: View {
    let urls: [String]
    private let spacing: CGFloat = 2
    private let maxImages = 4
    
    private var displayUrls: [String] {
        Array(urls.prefix(maxImages))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / 2 - spacing
            
            Grid(horizontalSpacing: spacing, verticalSpacing: spacing) {
                GridRow {
                    ForEach(0..<2, id: \.self) { index in
                        gridCell(for: index, size: cellSize)
                    }
                }
                
                GridRow {
                    ForEach(2..<4, id: \.self) { index in
                        gridCell(for: index, size: cellSize)
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func gridCell(for index: Int, size: CGFloat) -> some View {
        if index < displayUrls.count {
            AsyncImage(url: URL(string: displayUrls[index])) { phase in
                Group {
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: size, height: size)
                .clipped()
                .contentShape(Rectangle())
            }
        } else {
            Color.clear
                .frame(width: size, height: size)
        }
    }
}

struct ImageGridMiniView_Previews: PreviewProvider {
    static let testURLs = [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwallpaperaccess.com%2Ffull%2F1123322.jpg&f=1&nofb=1&ipt=b499bfb39e09a0b7799b22d616a6fb521e843526b9e1f3b5ba63258083ca0691",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.thesprucepets.com%2Fthmb%2FwpN_ZunUaRQAc_WRdAQRxeTbyoc%3D%2F4231x2820%2Ffilters%3Afill(auto%2C1)%2Fadorable-white-pomeranian-puppy-spitz-921029690-5c8be25d46e0fb000172effe.jpg&f=1&nofb=1&ipt=8516a9605d938c96d9db9fe89fd1cde70543cb68894febca7bc324b79bed0200",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%2Fid%2FOIP.v-LtEtrIBrI24ZV5w0YgBQHaMB%3Fpid%3DApi&f=1&ipt=a8a7a7655abca9de1823a0d8b30d8933c420c23f711a6e06356421c7f2434d46&ipo=images",
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F91%2Fcc%2F98%2F91cc9885810fe193feb3d1269e62c1f2.jpg&f=1&nofb=1&ipt=be35a73f4970d31e47fbd3a23d3fcd1bb34eddb6bf8b887aae8cbe1a2b6dafdf",
        "https://picsum.photos/204"
    ]
    
    static var previews: some View {
        Group {
            ImageGridMiniView(urls: testURLs)
                .frame(width: 100, height: 100)
                .previewLayout(.sizeThatFits)
            
            ImageGridMiniView(urls: Array(testURLs.prefix(2)))
                .frame(width: 100, height: 100)
                .previewLayout(.sizeThatFits)
        }
    }
}

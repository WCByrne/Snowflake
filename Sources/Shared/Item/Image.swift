
import Reindeer
import CoreGraphics

public class Image: Item {
    
    let rect: CGRect
    let image: CGImage?
    
    public required init(element: Element) {
        let attributes = element.attributes
        
        self.rect = CGRect(x: attributes.number(key: "x") ?? 0,
                           y: attributes.number(key: "y") ?? 0,
                           width: attributes.number(key: "width") ?? 0,
                           height: attributes.number(key: "height") ?? 0)
        
        self.image = Image.parse(string: attributes.string(key: "href") ?? "")
        super.init(element: element)
    }
    
    override public func makeLayer(size: CGSize) -> CALayer {
        let layer = CALayer()
        layer.masksToBounds = false
        layer.contents = image
        layer.frame = rect
        layer.applyStyle(style)
        return layer
    }
    
    // MARK: - Helper
    
    static func parse(string: String) -> CGImage? {
        guard !string.isEmpty else { return nil }
        
        let header = "data:image/png;base64,"
        guard let range = string.range(of: header) else { return nil }
        
        let substring = string.substring(from: range.upperBound)
        guard let data = Data(base64Encoded: substring, options: .ignoreUnknownCharacters) else { return nil }
        
        guard let provider = CGDataProvider(data: data as CFData) else { return nil }
        let img = CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        
        return img
    }
}

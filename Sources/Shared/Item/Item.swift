
import Reindeer
import QuartzCore



protocol Displayable {
    func makeLayer() -> CALayer
}


public class Item {
    public let id: String
    
    public let style: Style
    public var size : CGSize { return CGSize.zero }
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.id = attributes.string(key: "id") ?? ""
        self.style = Style(attributes: attributes)
    }
    
    // MARK: - Helper
    static func make(element: Element) -> Item? {
        let mapping: [String: Item.Type] = [
            "g": Group.self,
            "path": Path.self,
            "circle": Circle.self,
            "line": Line.self,
            "polygon": Polygon.self,
            "polyline": Polyline.self,
            "rect": Rectangle.self,
            "ellipse": Ellipse.self,
            "text": Text.self,
            "image": Image.self,
            "linearGradient": LinearGradient.self,
            "radialGradient": RadialGradient.self
        ]

        let shape = mapping[element.name ?? ""]
        return shape?.init(element: element)
    }
    
    
    public func makeLayer(size: CGSize) -> CALayer {
        let layer = CALayer()
        layer.applyStyle(style)
        return layer
    }
}



//class SVGLayer : CALayer {
//    
//    let _style : Style
//    
//    init(style: Style) {
//        self._style = style
//    }
//    
//    override func draw(in ctx: CGContext) {
//        
//        
//    }
//    
//}

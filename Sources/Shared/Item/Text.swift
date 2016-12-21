import Reindeer

public class Text: Item {
    public let point: CGPoint
    public let text: String
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.point = CGPoint(x: attributes.number(key: "x") ?? 0,
                             y: attributes.number(key: "y") ?? 0)
        self.text = attributes.string(key: "name") ?? ""
        
        super.init(element: element)
    }
    
    override public func makeLayer(size: CGSize) -> CALayer {
        let layer = CATextLayer()
        layer.string = text
        layer.position = point
        
        
        layer.applyStyle(style)
        return layer
    }
}

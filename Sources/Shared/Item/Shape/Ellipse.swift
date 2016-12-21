
import Reindeer

public class Ellipse: Shape {
    
    public let center: CGPoint
    public let radius: CGPoint
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.center = CGPoint(x: attributes.number(key: "cx") ?? 0,
                              y: attributes.number(key: "cy") ?? 0)
        self.radius = CGPoint(x: attributes.number(key: "rx") ?? 0,
                              y: attributes.number(key: "ry") ?? 0)
        
        super.init(element: element)
    }
    
    override public var path: CGPath { return _path }
    private lazy var _path: CGPath = {
        return CGPath(ellipseIn: Ellipse.rect(center: self.center, radius: self.radius), transform: nil)
        //    return CGPath(ovalIn: Ellipse.rect(center: self.center, radius: self.radius))
    }()
    
    // MARK: - Helper
    
    static func rect(center: CGPoint, radius: CGPoint) -> CGRect {
        return CGRect(x: center.x - radius.x,
                      y: center.y - radius.y,
                      width: radius.x * 2,
                      height: radius.y * 2)
    }
}

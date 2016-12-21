
import Reindeer

public class Line: Shape {
    
    public let point1: CGPoint
    public let point2: CGPoint
    
    public required init(element: Element) {
        let attributes = element.attributes
        self.point1 = CGPoint(x: attributes.number(key: "x1") ?? 0,
                              y: attributes.number(key: "y1") ?? 0)
        self.point2 = CGPoint(x: attributes.number(key: "x2") ?? 0,
                              y: attributes.number(key: "y2") ?? 0)
        
        super.init(element: element)
    }
    
    override public var path: CGPath { return _path }
    private lazy var _path: CGPath = {
        let path = CGMutablePath()
        path.move(to: self.point1)
        path.addLine(to: self.point2)
        return path
    }()
}
